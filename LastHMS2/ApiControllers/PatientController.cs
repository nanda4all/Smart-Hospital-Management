using FirebaseAdmin.Messaging;
using LastHMS2.Class_Attriputes;
using LastHMS2.Data;
using LastHMS2.Models;
using LastHMS2.Requests;
using LastHMS2.ShowClasses;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace LastHMS2.ApiControllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PatientController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IWebHostEnvironment _hosting;
        public PatientController(ApplicationDbContext context, IWebHostEnvironment hosting)
        {
            _context = context;
            _hosting = hosting;
        }

        [Route("[action]")]
        [HttpPost]
        public async Task<IActionResult> LogInPatient([FromForm] IFormCollection fc)
        {
            var data = await _context.Patients.Where(p => p.Patient_Email == fc["email"].ToString() && p.Active &&
            p.Patient_Password == fc["password"].ToString() && p.Ho_Id == int.Parse(fc["HoId"])).ToListAsync();
            if (data.Count == 0)
                return Ok(new { Status = false, Message = "البيانات المدخلة غير صحيحة" });

            Patient patient = data[0];
            FCMService.UpdateToken(fc["fcmToken"].ToString(), patient.Patient_Id, UserType.pat, Platform.Android);

            return Ok(new
            {
                Status = true,
                Message = "تم تسجيل الدخول بنجاح",
                data = new
                {
                    patientId = patient.Patient_Id,
                    patientName = patient.Patient_First_Name + " " + patient.Patient_Last_Name,
                    HospitalId = int.Parse(fc["HoId"]),
                }
            });
        }

        #region Personal Info
        [Route("[action]")]
        // (تعديل البيانات الشخصية)
        //get
        public async Task<IActionResult> EditPersonalInfoForPa([FromQuery] int id)  //PaId
        {
            var pat = _context.Patients.Find(id);
            if (!pat.Active)
            {
                return Ok(new { status = false, Active = false, Message = "لم يعد لديك حساب في هذه المشفى" });
            }
            var phone = await _context.Patient_Phone_Numbers.Where(p => p.Patient_Id == id).ToListAsync();
            var patient = await (from p in _context.Patients
                                 join a in _context.Areas
                                 on p.Area_Id equals a.Area_Id
                                 where p.Patient_Id == id
                                 select new
                                 {
                                     name = p.Patient_First_Name + " " + p.Patient_Last_Name,
                                     social = p.Patient_Social_Status,
                                     areaName = a.Area_Name,
                                     areaId = a.Area_Id,
                                     cityId = a.City_Id,
                                     phone = phone,
                                     areas = _context.Areas.Where(ar => ar.City_Id == a.City_Id).Select(ar => new { id = ar.Area_Id, name = ar.Area_Name }).ToList()
                                 }).ToListAsync();

            var cities = await _context.Cities.Select(c => new { id = c.City_Id, name = c.City_Name }).ToListAsync();

            return Ok(new
            {
                status =true,
                data = patient,
                cities = cities

            });
        }

        [Route("[action]")]
        [HttpPost]
        // (تعديل البيانات الشخصية)
        //post
        public async Task<IActionResult> EditPersonalInfoForPactientPost([FromForm] IFormCollection fc, [FromQuery] List<string> phones)
        {
            var patient = await _context.Patients.FindAsync(int.Parse(fc["id"]));
            patient.Area_Id = Convert.ToInt32(fc["area"]);
            patient.Patient_Social_Status = fc["social"].ToString();
            var phoneNumbers = await _context.Patient_Phone_Numbers.Where(p => p.Patient_Id == int.Parse(fc["id"])).ToListAsync();
            List<Patient_Phone_Numbers> p = new List<Patient_Phone_Numbers>();

            _context.Patient_Phone_Numbers.RemoveRange(phoneNumbers);
            await _context.SaveChangesAsync();
            for (int i = 0; i < phones.Count; i++)
            {
                Patient_Phone_Numbers temp = new Patient_Phone_Numbers()
                {
                    Patient_Id = int.Parse(fc["id"]),
                    Patient_Phone_Number = phones[i]
                };
                p.Add(temp);
            }
            _context.AddRange(p);
            _context.Update(patient);
            await _context.SaveChangesAsync();
            return Ok(new
            {
                message = "تم التعديل بنجاح"
            });
        }
        #endregion

        #region Previews
        [Route("[action]")]
        // ( عرض مواعيد المريض)
        public IActionResult DisplayPreview([FromQuery] int id, [FromQuery] int Ho_Id)  //PaId
        {
            var pat = _context.Patients.Find(id);
            if (!pat.Active)
            {
                return Ok(new { status = false, Active = false, Message = "لم يعد لديك حساب في هذه المشفى" });
            }
            var spec = (from d in _context.Departments
                        join spe in _context.Specializations
                        on d.Department_Name equals spe.Specialization_Id
                        where d.Ho_Id == Ho_Id
                        select new Specialization_Dept
                        {
                            Dept_Id = d.Department_Id,
                            Spec_Name = spe.Specialization_Name
                        }).ToList();
            var previews = (from pre in _context.Previews.ToList()
                            join doc in _context.Doctors.ToList()
                            on pre.Doctor_Id equals doc.Doctor_Id
                            where pre.Patient_Id == id && pre.Preview_Date.Date >= DateTime.Now.Date
                            orderby pre.Preview_Date
                            select new
                            {
                                PreviewId = pre.Preview_Id,
                                docName = doc.Doctor_First_Name + " " + doc.Doctor_Last_Name,
                                PreviewDate = pre.Preview_Date.ToString("dd/MM/yyyy"),
                                PreviewHour = pre.Preview_Date.ToString("hh:mm:tt"),
                                DoctorPhoneNumber = _context.Doctor_Phone_Numbers.Where(dpn => dpn.Doctor_Id == doc.Doctor_Id).ToList(),
                                speclization = spec.FirstOrDefault(s => s.Dept_Id == Convert.ToInt32(doc.Department_Id)).Spec_Name,
                                isToday = pre.Preview_Date.Date == DateTime.Now.Date ? true : false,

                            }).ToList();
            if (previews.Count == 0)
                return Ok
                    (
                    new
                    {
                        Status = false,
                        Active = true,
                        Message = "ليس لديك معاينات"
                    }
                    );
            return Ok(new
            {
                Status = true,
                data = new { Previews = previews }
            });

        }

        [Route("[action]")]
        // (عرض الأقسام)
        public async Task<IActionResult> DisplayDepartementForCreatePreview(int Ho_Id)
        {
            var dept = await (from d in _context.Departments
                              join spec in _context.Specializations
                              on d.Department_Name equals spec.Specialization_Id
                              where d.Ho_Id == Ho_Id && d.Active == true
                              select new
                              {
                                  id = d.Department_Id,
                                  name = spec.Specialization_Name
                              }).ToListAsync();
            if (dept.Count == 0)
                return Ok(new { message = "لا يوجد أقسام" });

            return Ok(dept);
        }

        [Route("[action]")]
        // (عرض الدكاترة بالأقسام)
        public async Task<IActionResult> DisplayDoctorsForCreatePreview(string Dept_Id)
        {
            var data = await (from d in _context.Doctors
                              join dpn in _context.Doctor_Phone_Numbers
                              on d.Doctor_Id equals dpn.Doctor_Id
                              where d.Department_Id == int.Parse(Dept_Id) && d.Active == true
                              select d).ToListAsync();

            var doctors = (from d in data
                           group d by d into c
                           select new
                           {
                               id = c.Key.Doctor_Id,
                               name = c.Key.Doctor_First_Name + " " + c.Key.Doctor_Last_Name,
                               phone = _context.Doctor_Phone_Numbers.Where(dpn => dpn.Doctor_Id == c.Key.Doctor_Id).ToList(),
                           }).ToList();

            return Ok(new { doctors = doctors });
        }

        [Route("[action]")]
        [HttpPost]
        public async Task<IActionResult> CreatePreview([FromForm] IFormCollection fc, [FromQuery] DateTime date)
        {
            Preview p = new Preview()
            {
                Caring = true,
                Doctor_Id = int.Parse(fc["id"]),
                Patient_Id = int.Parse(fc["PatId"]),
                Preview_Date = date /// can be changed
            };
            _context.Add(p);
            await _context.SaveChangesAsync();
            #region send notification
            //==============================================================================================
            var doc = await _context.Doctors.FirstOrDefaultAsync(pat => pat.Doctor_Id == p.Doctor_Id);
            var message = new MulticastMessage()
            {
                Notification = new Notification()
                {
                    Title = "موعد جديد",
                    Body = "لديك موعد جديد عند الطبيب " + doc.Doctor_Full_Name,
                    //ImageUrl=
                },
                Data = new Dictionary<string, string>()
                    {
                        { "route","/showPreviewsForDoc" },
                    }

            };
            await FCMService.SendNotificationToUserAsync((int)p.Patient_Id, UserType.pat, message);
            //=========================================================================================
            #endregion

            return Ok(new
            {
                Status = true,
                Message = "تم حجز الموعد بنجاح"
            });
        }
        #endregion


        [Route("[action]")]
        // (عرض التفاصيل الطبية)
        public async Task<IActionResult> GetMedicalDetails([FromQuery] int id)//PaId
        {
            var pat = _context.Patients.Find(id);
            if (!pat.Active)
            {
                return Ok(new { status = false, Active = false, Message = "لم يعد لديك حساب في هذه المشفى" });
            }
            var medical = await _context.Medical_Details.FirstOrDefaultAsync(m => m.Patient.Patient_Id == id);

            if (medical == null)
            {
                return Ok(new { status = false, Active = true, Message = "لا يوجد ملف طبي" });
            }

            var allergies = await (from a in _context.Medical_Allergies
                                   join all in _context.Allergies
                                   on a.Allergy_Id equals all.Allergy_Id
                                   where medical.Medical_Details_Id == a.Medical_Detail_Id
                                   select all.Allergy_Name
                             ).ToListAsync();

            var family = await (from md in _context.Medical_Diseases
                                join d in _context.Diseases
                                on md.Disease_Id equals d.Disease_Id
                                where medical.Medical_Details_Id == md.Medical_Detail_Id && md.Family_Health_History == true
                                select d.Disease_Name
                             ).ToListAsync();

            var chronic = await (from md in _context.Medical_Diseases
                                 join d in _context.Diseases
                                 on md.Disease_Id equals d.Disease_Id
                                 where medical.Medical_Details_Id == md.Medical_Detail_Id && md.Chronic_Diseases == true
                                 select d.Disease_Name
                             ).ToListAsync();

            var examination = await (from d in _context.Doctors
                                     join p in _context.Previews
                                     on d.Doctor_Id equals p.Doctor_Id
                                     where p.Patient_Id == id && p.ExaminationRecord != null
                                     select new
                                     {
                                         doctorName = "د." + d.Doctor_First_Name + " " + d.Doctor_Last_Name,
                                         date = p.Preview_Date.ToString("dd-MM-yyyy"),
                                         examination = p.ExaminationRecord
                                     }
                                    ).ToListAsync();

            string PaName = _context.Patients.Find(id).Patient_Full_Name;
            return Ok(new
            {
                status = true,
                data = new
                {
                    medicalId = medical.Medical_Details_Id,
                    name = PaName,
                    blood = medical.MD_Patient_Blood_Type,
                    need = medical.MD_Patient_Special_Needs,
                    plans = medical.MD_Patient_Treatment_Plans_And_Daily_Supplements,
                },
                allegies = allergies,
                family = family,
                chronic = chronic,
                exam = examination
            });
        }

        [Route("[action]")]
        // onclick (الفاتورة)
        public async Task<IActionResult> ShowBillForPatient([FromQuery] int id)
        {
            var patient = await _context.Patients.FirstOrDefaultAsync(p => p.Patient_Id == id);
            if (!patient.Active)
            {
                return Ok(new { status = false, Active = false, Message = "لم يعد لديك حساب في هذه المشفى" });
            }
            var bills = _context.Bills.Where(b => b.Patient_Id == patient.Patient_Id).Select(b => new
            {
                bill_Examination = b.Bill_Examination == null ? 0 : b.Bill_Examination,
                bill_Surgeries = b.Bill_Surgeries == null ? 0 : b.Bill_Surgeries,
                bill_Rays = b.Bill_Rays == null ? 0 : b.Bill_Rays,
                bill_Medical_Test = b.Bill_Medical_Test == null ? 0 : b.Bill_Medical_Test,
                bill_Room_Service = b.Bill_Room_Service == null ? 0 : b.Bill_Room_Service,
                bill_Medication = b.Bill_Medication == null ? 0 : b.Bill_Medication,
                bill_Date = b.Bill_Date.ToShortDateString(),
                paid = b.Paid,
                total =
                b.Bill_Examination.GetValueOrDefault()
                + b.Bill_Surgeries.GetValueOrDefault()
                + b.Bill_Rays.GetValueOrDefault()
                + b.Bill_Medical_Test.GetValueOrDefault()
                + b.Bill_Room_Service.GetValueOrDefault()
                + b.Bill_Medication.GetValueOrDefault()
                ,

            }).ToList();
            if (bills.Count == 0)
                return Ok(new { Status = false, Active = true, Message = "ليس لديك فواتير" });

            return Ok(new
            {
                Status = true,
                Message = "Successful",
                data = bills,

            });
        }

        [Route("[action]")]
        public async Task<IActionResult> RequestNurse([FromQuery] int id)
        {
            var patient = await _context.Patients.FindAsync(id);
            if (!patient.Active)
            {
                return Ok(new { status = false, Active = false, Message = "لم يعد لديك حساب في هذه المشفى" });
            }
            var HeadNurse = _context.Employees.FirstOrDefault(e => e.Ho_Id == patient.Ho_Id && e.Active && e.Employee_Job == "HeadNurse");
            Request request = new Request
            {
                Accept = false,
                Patient_Id = id,
                Employee_Id = HeadNurse.Employee_Id,
                Request_Date = DateTime.Now,
                Request_Type = "SendNurse",
                Request_Description = $" يرجى إرسال ممرض للمريض {patient.Patient_Full_Name} ",
                Doctor_Id = null
                //Request_Data = nothing
            };

            _context.Add(request);
            await _context.SaveChangesAsync();
            #region send notification
            //==============================================================================================
            var message = new MulticastMessage()
            {
                Notification = new Notification()
                {
                    Title = "طلب جديد",
                    Body = "طلب ممرض جديد من قبل المريض " + patient.Patient_Full_Name,
                    //ImageUrl=
                },
                Data = new Dictionary<string, string>()
                                {
                                    { "route","/ShowTests" },
                                }

            };
            await FCMService.SendNotificationToUserAsync(HeadNurse.Employee_Id, UserType.emp, message);
            //=========================================================================================
            #endregion

            return Ok(
                new
                {
                    Status = true,
                    Message = "تم تلقي طلبك سنرسل لك ممرض في أقرب وقت",
                }
                );
        }

        // preview
        [Route("[action]")]
        public async Task<IActionResult> ValidateDateForPatient([FromQuery] DateTime date, [FromQuery] int id, [FromQuery] int DocId)//id(patient)
        {
            var patient = _context.Patients.Find(id);
            if (!patient.Active)
            {
                return Ok(new { IsValid = false, Active = false, Message = "لقد تم حظرك من المشفى" });
            }
            var workDays = await _context.Work_Days.Where(w => w.Doctor_Id == DocId).ToListAsync();
            foreach (var item in workDays)
                if (date.DayOfWeek.CompareTo((DayOfWeek)((int)item.Day)) == 0)
                {
                    var DayHours = workDays.Where(w => date.DayOfWeek.CompareTo((DayOfWeek)((int)w.Day)) == 0).ToList()[0];
                    TimeSpan HalfHour = TimeSpan.FromMinutes(30);
                    List<TimeSpan> prev = _context.Previews.Where(p => p.Doctor_Id == DocId && p.Preview_Date.Date == date.Date).Select(s => s.Preview_Date.TimeOfDay).ToList();
                    Dictionary<string, string> d = new Dictionary<string, string>();
                    for (TimeSpan i = DayHours.Start_Hour; i < DayHours.End_Hour; i += HalfHour)
                    {
                        if (date.DayOfWeek.CompareTo(DateTime.Now.DayOfWeek) == 0)
                        {
                            if (i.Hours <= DateTime.Now.Hour)
                                prev.Add(i);
                        }
                        if (!prev.Contains(i))
                            d.Add(i.ToString("c"), i.Hours >= 12 ? i.Hours == 12 ? "12" + ":" + (i.Minutes == 0 ? "00" : "30") + " PM" : i.Hours - 12 + ":" + (i.Minutes == 0 ? "00" : "30") + " PM" : i.Hours == 0 ? "12" + ":" + (i.Minutes == 0 ? "00" : "30") + " AM" : i.Hours + ":" + (i.Minutes == 0 ? "00" : "30") + "AM");
                    }
                    if (d.Count == 0)
                    {
                        return Ok(new
                        {
                            IsValid = true,
                            empty = true,
                            message = "ليس لدى الطبيب ساعات فارغة في هذا اليوم",
                        }
                            );
                    }
                    return Ok(new
                    {
                        IsValid = true,
                        empty = false,
                        PatientId = id,
                        Date = date.Date.ToString("dd-MM-yyyy"),
                        key = d.Select(d => d.Key).ToList(),
                        value = d.Select(d => d.Value).ToList(),

                    }); ;
                }

            return Ok(new { IsValid = false, Active = true, Message = "يرجى اختيار يوم من ايام دوام الطبيب." });
        }

        [Route("[action]")]
        // (حجز موعد) ==> (حجز موعد للمريض)

        public async Task<IActionResult> CheckTimeForPatient([FromQuery] int PaId, [FromQuery] DateTime date)
        {
            var pre = await _context.Previews.Where(p => p.Patient_Id == PaId && p.Preview_Date == date).ToListAsync();
            if (pre.Count != 0)
            {
                return Ok(new
                {
                    Status = false,
                    Message = "لديك  موعد آخر في نفس التوقيت"
                }
                );
            }
            return Ok(new
            {
                Status = true,
            });
        }

    }
}
