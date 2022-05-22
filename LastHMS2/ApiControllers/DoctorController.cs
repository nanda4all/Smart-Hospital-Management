//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
//using Microsoft.AspNetCore.Http;
//using Microsoft.AspNetCore.Mvc;
//using Microsoft.EntityFrameworkCore;
//using LastHMS2.Data;
//using LastHMS2.Models;
//using LastHMS2.ShowClasses;

//namespace LastHMS2.ApiControllers
//{
//    [Route("api/[controller]/[action]")]
//    [ApiController]
//    public class DoctorController : ControllerBase
//    {
//        private readonly ApplicationDbContext _context;

//        public DoctorController(ApplicationDbContext context)
//        {
//            _context = context;
//        }
//       // ***********************************************************
//        public async Task<IActionResult> GetWorkDays([FromQuery] int id)
//        {
//            var workDays =await _context.Work_Days.Where(w => w.Doctor_Id == id).Select(s => new
//            {
//                Day = s.Day,
//                End_Hour = s.End_Hour.ToString("c"),
//                Start_Hour = s.Start_Hour.ToString("c")
//            }).ToListAsync();
//            return Ok(workDays);
//        }
//         //(تسجيل الدخول)
//        public async Task<IActionResult> LogIn()
//        {
//            var data = await _context.Hospitals.Select(x => new
//            {
//                HospitalId = x.Ho_Id,
//                HospitalName = x.Ho_Name
//            }).ToListAsync();
//            return Ok(data);
//        }
//        [HttpPost]

//        // PostLogin ==> go to master 
//        // in view onclick (المرضى) ==> /api/Doctor/DisplayPatients/Model.Doctor_Id done
//        // in view onclick (حجز غرفة عمليات) ==> /api/Doctor/CreateSurgery/Model.Doctor_Id
//        // in view onclick (إلغاء حجز غرفة) ==> /api/Doctor/DeleteSurgery/Model.Doctor_Id
//        // in view onclick (حجز موعد ) ==> /api/Doctor/HoPatientsForPreview/Model.Doctor_Id?DocId = id
//        // in view onclick (عرض المواعيد) ==> /api/Doctor/DisplayPreviews/Model.Doctor_Id

//        public async Task<IActionResult> LogIn([FromForm] IFormCollection fc)
//        {
//            bool IsDeptManager = false;
//            var doctors = await _context.Doctors.Where(d => d.Doctor_Email == fc["email"].ToString() && d.Doctor_Password == fc["password"].ToString()).ToListAsync();
//            if (doctors.Count == 0)
//                return Ok(new { Status = false, Message = "The Doctor was Not Found" });
//            var data = (from doc in doctors
//                        join dept in _context.Departments.ToList()
//                        on doc.Department_Id equals dept.Department_Id
//                        where dept.Ho_Id == int.Parse(fc["HoId"])
//                        select doc).ToList();
//            if (data.Count == 0)
//                return Ok(new { Status = false, Message = "No Doctor Matches in this Hospital ..." });
//            Doctor doctor = data[0];
//            //check if the doctor is a deptmanager
//            var Department = _context.Departments.FirstOrDefault(m => m.Dept_Manager.Doctor_Id == doctor.Doctor_Id);
//            if (Department != null) IsDeptManager = true;
//            return Ok(new
//            {
//                Status = true,
//                Message = "Message",
//                data = new
//                {
//                    DoctorId = doctor.Doctor_Id,
//                    DoctorName = doctor.Doctor_First_Name + " " + doctor.Doctor_Last_Name,
//                    HospitalId = int.Parse(fc["HoId"]),
//                    IsManager = IsDeptManager
//                }
//            });
//        }
//        [Route("{id}")]
//        // (العمليات)
//        public async Task<IActionResult> DisplaySurgeries([FromRoute] int id)
//        {
//            var surgeries =await _context.Surgeries.Where(s => s.Doctor_Id == id)
//                .Select(s => new
//                {
//                    SurgeryId = s.Surgery_Number,
//                    SurgeryName = s.Surgery_Name,
//                    SurgeryDate = s.Surgery_Date,
//                    SurgeryTime = s.Surgery_Time,
//                    SurgeryRoom = _context.Surgery_Rooms.Find(s.Surgery_Room_Id).Su_Room_Number,
//                    Floor = _context.Surgery_Rooms.Find(s.Surgery_Room_Id).Su_Room_Floor,
//                    PatientName = _context.Patients.FirstOrDefault(p => p.Active && p.Patient_Id == s.Patient_Id).Patient_Full_Name,
//                    PatientPhoneNumbers = _context.Patient_Phone_Numbers.Where(pn => pn.Patient_Id == s.Patient_Id).ToList()
//                }).ToListAsync();
//            if (surgeries.Count == 0)
//                return Ok(new { Status = false, Message = "No Surgeries fr this Patient" });

//            return Ok(new
//            {
//                Status = true,
//                Message = "Success",
//                data = new { Surgeries = surgeries , DoctorId = id} 
//            });
//        }
//        [Route("{id}")]
//        // (العمليات) ==> (حجز عملية)
//        public async Task<IActionResult> CreateSurgery([FromRoute] int id,[FromQuery] int PatId,[FromQuery] int SrId , [FromForm] IFormCollection fc)
//        {
//            Surgery s = new Surgery()
//            {
//                Doctor_Id = id,
//                Patient_Id = PatId,
//                Surgery_Room_Id = SrId,
//                Surgery_Name = "dqdwqdq",
//                //Surgery_Date = (DateTime) fc["SurgeryDate"], // needs to be a Converted string to DateTime
//                Surgery_Time = int.Parse(fc["SurgeryTime"])
//            };
//            _context.Add(s);
//            await _context.SaveChangesAsync();
//            return Ok(new { Status = true, Message = "Succes (Surgery Added)" });
//        }
//        [HttpDelete("{id}")]
//        // (العمليات) ==> (إلغاء الحجز)
//        public async Task<IActionResult> DeleteSurgery([FromRoute] int id)
//        {
//            var surgery = await _context.Surgeries.FindAsync(id);
//            if (surgery == null)
//                return Ok(new { Status = false, Message = "Not Found" });

//            _context.Surgeries.Remove(surgery);
//            await _context.SaveChangesAsync();
//            return Ok(new { Status = false, Message = "Deleted Successfully" });
//        }
//        #region Create Preview For Doctor
//        public async Task<IActionResult> ValidateDate(DateTime date,int id,int PatId)
//        {
//            var workDays =await _context.Work_Days.Where(w => w.Doctor_Id == id).ToListAsync();
//            foreach (var item in workDays)
//                if (date.DayOfWeek.CompareTo((DayOfWeek)((int)item.Day)) == 0)
//                {
//                    var DayHours = workDays.Where(w => date.DayOfWeek.CompareTo((DayOfWeek)((int)w.Day)) == 0).ToList()[0];
//                    TimeSpan HalfHour = TimeSpan.FromMinutes(30);
//                    var prev = _context.Previews.Where(p => p.Doctor_Id == id && p.Preview_Date.Date == date.Date).Select(s => s.Preview_Date.TimeOfDay);
//                    List<TimeSpan> data = new List<TimeSpan>();
//                    for (TimeSpan i = DayHours.Start_Hour; i < DayHours.End_Hour; i += HalfHour)
//                    {
//                        if (!prev.Contains(i))
//                            data.Add(i);
//                    }
//                    return Ok(new 
//                    { 
//                        IsValid = true ,
//                        data = new 
//                        {
//                            PatientId = PatId , 
//                            Date = date.Date.ToString("dd-MM-yyyy") , 
//                            AvailableTimes = data  
//                        }
//                    });
//                }

//            return Ok(new { IsValid = false , Message = "يرجى اختيار يوم من ايام دوامك." });
//        }
//        [Route("{id}")]
//        // (حجز موعد) ==> (حجز موعد للمريض)
//        public async Task<IActionResult> CreatePreview([FromRoute]int id ,[FromQuery] int PatId , DateTime date , TimeSpan time)
//        {   
            
//            Preview p = new Preview()
//            {
//                Caring = true,
//                Doctor_Id = id,
//                Patient_Id = PatId,
//                Preview_Date = date /// can be changed
//            };
//            _context.Add(p);
//            await _context.SaveChangesAsync();
//            return Ok(new
//            {
//                Status = true,
//                Message = "تم حجز الموعد بنجاح"
//            });
//        }
//        #endregion // I am heeeeeeeeeeereeeeeeeeeeeeee
   
//        [Route("{id}")]
//        // (عرض المواعيد)
//        public async Task<IActionResult> DisplayPreviews([FromRoute] int id)
//        {
//            // display all patients in the same hospital with a button to book a preview with the patient id 
//            var doctorPreviews = await (from pre in _context.Previews
//                                        join pat in _context.Patients
//                                        on pre.Patient_Id equals pat.Patient_Id
//                                        where pre.Doctor_Id == id
//                                        select new ShowPreviewsForDoctor
//                                        {
//                                            PreviewId = pre.Preview_Id,
//                                            PatientName = pat.Patient_First_Name + " " + pat.Patient_Last_Name,
//                                            PreviewDate = pre.Preview_Date.ToString("MM/dd/yyyy"),
//                                            PreviewHour = pre.Preview_Date.ToString("hh-mm-tt")
//                                        }).ToListAsync();
//            if (doctorPreviews.Count == 0 )
//            {
//                return Ok(new
//                {
//                    Status = false,
//                    Message = "No Previews"
//                });
//            }
//            return Ok(new
//            {
//                Status = true,
//                Messsage = "Success",
//                data = new { Previews = doctorPreviews, DoctorId = id }
//            });
//        }
//        [Route("{id}")]
//        // (المرضى)
//        public async Task<IActionResult> DisplayPatients(int id) // display doctor's patients by passing the doctor's Id .... 
//        {
//            var doctor = await _context.Doctors.FirstOrDefaultAsync(m => m.Doctor_Id == id);
//            if (doctor == null)
//            {
//                return Ok(new { Status = false, Message = "The Doctor Was Not Found" });
//            }
//            var patients =await (from p in _context.Patients
//                            join pre in _context.Previews
//                            on p.Patient_Id equals pre.Patient_Id
//                            where (pre.Doctor_Id == doctor.Doctor_Id && pre.Caring == true && p.Active == true)
//                            select p).ToListAsync();
            
//            return Ok(new
//            {
//                Status = true,
//                Message = "Success",
//                data = new { Patients = patients ,DoctorId = id}
//            });

//        }


//        // For Dept Manager
//        [Route("{id}")]
//         // (الأطباء)
//        public async Task<IActionResult> DisplayDoctrosByDeptId([FromRoute] int id)
//        {
//            var deptManager =await _context.Doctors.FirstOrDefaultAsync(d => d.Doctor_Id == id);
//            var doctors =await _context.Doctors.Where(d => d.Department_Id == deptManager.Department_Id && d.Doctor_Id != deptManager.Doctor_Id).ToListAsync();
//            if (doctors.Count == 0)
//                return Ok(new { Status = true, Message = "this deprtment is empty !!" });
//            return Ok(
//                new 
//                {
//                    Status = true, 
//                    Message = "this deprtment is empty !!",
//                    data = new {DeptDoctors = doctors , DeptmanagerId = deptManager.Doctor_Id }
//                });

//            //ViewBag.DeptId = Deptmanager.Department_Id;
//            //return View(doctors);
//        }
//        //***********************************************************


//        // GET: api/Doctor
//        [HttpGet]
//        public async Task<ActionResult<IEnumerable<Doctor>>> GetDoctors()
//        {
//            return await _context.Doctors.ToListAsync();
//        }

//        // GET: api/Doctor/5
//        [HttpGet("{id}")]
//        public async Task<ActionResult<Doctor>> GetDoctor(int id)
//        {
//            var doctor = await _context.Doctors.FindAsync(id);

//            if (doctor == null)
//            {
//                return NotFound();
//            }

//            return doctor;
//        }

//        // PUT: api/Doctor/5
//        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
//        [HttpPut("{id}")]
//        public async Task<IActionResult> PutDoctor(int id, Doctor doctor)
//        {
//            if (id != doctor.Doctor_Id)
//            {
//                return BadRequest();
//            }

//            _context.Entry(doctor).State = EntityState.Modified;

//            try
//            {
//                await _context.SaveChangesAsync();
//            }
//            catch (DbUpdateConcurrencyException)
//            {
//                if (!DoctorExists(id))
//                {
//                    return NotFound();
//                }
//                else
//                {
//                    throw;
//                }
//            }

//            return NoContent();
//        }

//        // POST: api/Doctor
//        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
//        [HttpPost]
//        public async Task<ActionResult<Doctor>> PostDoctor(Doctor doctor)
//        {
//            _context.Doctors.Add(doctor);
//            await _context.SaveChangesAsync();

//            return CreatedAtAction("GetDoctor", new { id = doctor.Doctor_Id }, doctor);
//        }

//        // DELETE: api/Doctor/5
//        [HttpDelete("{id}")]
//        public async Task<IActionResult> DeleteDoctor(int id)
//        {
//            var doctor = await _context.Doctors.FindAsync(id);
//            if (doctor == null)
//            {
//                return NotFound();
//            }

//            _context.Doctors.Remove(doctor);
//            await _context.SaveChangesAsync();

//            return NoContent();
//        }

//        private bool DoctorExists(int id)
//        {
//            return _context.Doctors.Any(e => e.Doctor_Id == id);
//        }
//    }
//}
