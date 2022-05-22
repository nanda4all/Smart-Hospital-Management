using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LastHMS2.Data;
using LastHMS2.Models;
using LastHMS2.ShowClasses;
using FirebaseAdmin.Messaging;

namespace LastHMS2.Controllers
{
    public class PreviewController : Controller
    {
        private readonly ApplicationDbContext _context;

        public PreviewController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Preview
        public async Task<IActionResult> Index()
        {
            return View(await _context.Previews.ToListAsync());
        }

        // GET: Preview/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var preview = await _context.Previews
                .FirstOrDefaultAsync(m => m.Preview_Id == id);
            if (preview == null)
            {
                return NotFound();
            }

            return View(preview);
        }
        #region Create Preview For Patient

        public async Task<IActionResult> CreateForPatient(int id) // Patient(id) // Display All Departments in Patient.HoId
        {
            var patient = _context.Patients.Find(id);
            if (!patient.Active)
                return RedirectToAction("Logout", "Patient");
            var data = await GetDepartments(patient.Ho_Id);
            ViewBag.PatientId = id;
            return View(data);
        }

        public async Task<IActionResult> DeptDoctorsForPatient(int id, int DeptId)// Patient (id)
        {
            var patient = _context.Patients.Find(id);
            if (!patient.Active)
                return RedirectToAction("Logout", "Patient");
            var data = await GetHospitalDoctors(DeptId);
            ViewBag.PatientId = id;
            ViewBag.DeptId = DeptId;
            return View(data);
        }

        public async Task<IActionResult> PickDateAsPatient(int id, int DeptId, int DocId, string ErrorMessage = "") // patient(id) // Create
        {
            var patient = _context.Patients.Find(id);
            if (!patient.Active)
                return RedirectToAction("Logout", "Patient");
            var workDays = await _context.Work_Days.Where(w => w.Doctor_Id == DocId).ToListAsync();
            ViewBag.PatientId = id;
            ViewBag.DeptId = DeptId;
            ViewBag.DocId = DocId;
            ViewBag.ErrorMessage = ErrorMessage;
            ViewBag.Times = new List<SelectListItem>();
            return View(workDays);
        }

        public async Task<IActionResult> PickTimeAsPatientPost(int id, int DocId , int DeptId, DateTime date, TimeSpan PreviewTime)// Department(id)
        {
            var patient = _context.Patients.Find(id);
            if (!patient.Active)
                return RedirectToAction("Logout", "Patient");
            if (date < DateTime.Now || date == default || PreviewTime.ToString() == "12:02:00")
                return RedirectToAction("PickDateAsPatient", new { id = id , DocId = DocId, DeptId = DeptId, ErrorMessage = "الرجاء اختيار وقت متاح" });
            bool success = false;
            var workDays = await _context.Work_Days.Where(w => w.Doctor_Id == DocId).ToListAsync();
            foreach (var item in workDays)
            {
                if (date.DayOfWeek.CompareTo((DayOfWeek)((int)item.Day)) == 0)
                {
                    success = true;
                    break;
                }
            }
            if (!success)
                return RedirectToAction("PickDateAsPatient", new { id = id, DocId = DocId, DeptId = DeptId, ErrorMessage = "الرجاء اختيار وقت متاح" });
            DateTime d = date.Date.Add(PreviewTime);
            var pre = _context.Previews.Where(p => p.Patient_Id == id && p.Preview_Date == d);
            if (!pre.Any())
            {
                if (patient.PreviewCount == 3)
                {
                    TempData["PreviewCount"] = "لقد تجاوزت الحد الأقصى لعدد الحجوزات في اليوم";
                    return RedirectToAction("Master", "Patient", new { id });
                }
                var previews = (from preview in _context.Previews.ToList()
                                join doc in _context.Doctors.ToList()
                                on preview.Doctor_Id equals doc.Doctor_Id
                                where preview.Patient_Id == id &&
                                doc.Department_Id == DeptId &&
                                preview.Preview_Date.Date == DateTime.Now.Date &&
                                doc.Active
                                select preview).ToList();
                if (previews.Count != 0)
                {
                    TempData["PreviewCount"] = "لقد تجاوزت الحد الأقصى لعدد الحجوزات اليومية في هذا القسم";
                    return RedirectToAction("Master", "Patient", new { id });
                }

                Preview p = new Preview
                {
                    Doctor_Id = DocId,
                    Patient_Id = id,
                    Preview_Date = d,
                    Caring = false
                };
                _context.Add(p);
                patient.PreviewCount++;
                await _context.SaveChangesAsync();
                TempData["PreviewAdded"] = "تم تسجيل الموعد بنجاح";
                #region send notification
                //====================================================================
                var pat = await _context.Patients.FirstOrDefaultAsync(pat => pat.Patient_Id == p.Patient_Id);
                var message2 = new MulticastMessage()
                {
                    Notification = new Notification()
                    {
                        Title = "موعد جديد",
                        Body = "لديك موعد جديد للمريض  " + pat.Patient_Full_Name,
                        //ImageUrl=
                    },
                    Data = new Dictionary<string, string>()
                    {
                        { "route","/showPreviewsForDoc" },
                    }

                };
                await FCMService.SendNotificationToUserAsync((int)p.Doctor_Id, UserType.doc, message2);
                //=======================================================================
                #endregion
                return RedirectToAction("Master", "Patient", new { id = id });
            }
            TempData["TImePatient"] = "لدى المريض موعد آخر في نفس التوقيت يرجى اختيار توقيت آخر";
            return RedirectToAction("PickTimeAsPatient", new { id = id, DeptId = DeptId, DocId = DocId, date = date });
        }
        #endregion
        #region Create Preview For Doctor

        public IActionResult Create(int DoctorId , int PatientId ,int HoId , string ErrorMessage = "") // display all patients in the same hospital with a button to book a preview with the patient id 
        {
            var doctor = _context.Doctors.Find(DoctorId);
            if (!doctor.Active)
                return RedirectToAction("Logout", "Doctor");
            ViewBag.PatientId = PatientId;
            ViewBag.DocId = DoctorId;
            ViewBag.HoId = HoId;
            ViewBag.ErrorMessage = ErrorMessage;
            ViewBag.Times = new List<SelectListItem>();
            return View(_context.Work_Days.Where(s => s.Doctor_Id == DoctorId));
        }

      
        public async Task<IActionResult> GetAvailableTimePost(int DocId,int HoId ,int PatientId, DateTime date , TimeSpan PreviewTime)
        {
            var doctor = _context.Doctors.Find(DocId);
            if (!doctor.Active)
                return RedirectToAction("Logout", "Doctor");
            if (date < DateTime.Now || date == default|| PreviewTime.ToString() == "12:02:00")
                return RedirectToAction("Create", new { DoctorId = DocId, PatientId = PatientId, HoId = HoId, ErrorMessage = "الرجاء اختيار وقت متاح" });
            bool success = false;
            var workDays = await _context.Work_Days.Where(w => w.Doctor_Id == DocId).ToListAsync();
            foreach (var item in workDays)
            {
                if (date.DayOfWeek.CompareTo((DayOfWeek)((int)item.Day)) == 0)
                {
                    success = true;
                    break;
                }
            }
            if(!success)
                return RedirectToAction("Create", new { DoctorId = DocId, PatientId = PatientId, HoId = HoId, ErrorMessage = "الرجاء إختيار احد ايام دوامك" });
            DateTime d =  date.Date.Add(PreviewTime);
           var pre =await _context.Previews.Where(p => p.Patient_Id == PatientId && p.Preview_Date == d).ToListAsync();
            if (pre.Count == 0)
            {
                Preview p = new Preview
                {
                    Doctor_Id = DocId,
                    Patient_Id = PatientId,
                    Preview_Date = d,
                    Caring = false
                };
                _context.Add(p);
                await _context.SaveChangesAsync();
                #region send notification
                //==============================================================================================
                var message = new MulticastMessage()
                {
                    Notification = new Notification()
                    {
                        Title = "موعد جديد",
                        Body = "لديك موعد جديد عند الطبيب " + doctor.Doctor_Full_Name,
                        //ImageUrl=
                    },
                    Data = new Dictionary<string, string>()
                    {
                        { "route","/showPreviewsForPat" },
                    }

                };
                await FCMService.SendNotificationToUserAsync((int)p.Patient_Id, UserType.pat, message);
                //=========================================================================================
                #endregion

                return RedirectToAction("Master", "Doctor", new { id = DocId, HoId = HoId });
            }

            TempData["TimePatient"] = "لدى المريض موعد آخر في نفس التوقيت يرجى اختيار توقيت آخر";
            return RedirectToAction("Create" , new { DoctorId = DocId,  HoId =HoId,  PatientId = PatientId});
        }
      
        #endregion
        #region Create Preview For Resception

        public async Task<IActionResult> CreateForResception(int id,int EmpId) // Patient(id) // Display All Departments in Patient.HoId
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("Logout", "Employee");
            var patient = _context.Patients.Find(id);
            var data =await GetDepartments(patient.Ho_Id);
            ViewBag.PatientId = id;
            ViewBag.EmpId = EmpId;
            return View(data);
        }
        public async Task<IActionResult> DeptDoctorsForResception(int id, int EmpId, int PatientId)// Department (id)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("Logout", "Employee");
            var data = await GetHospitalDoctors(id);
            ViewBag.PatientId = PatientId;
            ViewBag.EmpId = EmpId;
            ViewBag.DeptId = id;
            return View(data);
        }
        public async Task<IActionResult> PickDate(int id, int EmpId, int PatientId , int DocId , string ErrorMessage ="") // Department(id) // Create
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("Logout", "Employee");
            var workDays = await _context.Work_Days.Where(w => w.Doctor_Id == DocId).ToListAsync();
            ViewBag.PatientId = PatientId;
            ViewBag.EmpId = EmpId;
            ViewBag.DeptId = id;
            ViewBag.DocId = DocId;
            ViewBag.ErrorMessage = ErrorMessage;
            ViewBag.Times = new List<SelectListItem>();
            return View(workDays);
        }
        
        public async Task<IActionResult> PickTimePost(int id,int DocId, int EmpId, int PatientId, DateTime date, TimeSpan PreviewTime)// Department(id)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("Logout", "Employee");
            if (date < DateTime.Now || date == default || PreviewTime.ToString() == "12:02:00")
                return RedirectToAction("PickDate", new {id=id,EmpId=EmpId, DocId = DocId, PatientId = PatientId,ErrorMessage = "الرجاء اختيار وقت متاح" });
            bool success = false;
            var workDays = await _context.Work_Days.Where(w => w.Doctor_Id == DocId).ToListAsync();
            foreach (var item in workDays)
            {
                if (date.DayOfWeek.CompareTo((DayOfWeek)((int)item.Day)) == 0)
                {
                    success = true;
                    break;
                }
            }
            if (!success)
                return RedirectToAction("PickDate", new { id = id, EmpId = EmpId, DocId = DocId, PatientId = PatientId, ErrorMessage = "الرجاء اختيار وقت متاح" });
            DateTime d = date.Date.Add(PreviewTime);
            var pre = _context.Previews.Where(p => p.Patient_Id == PatientId && p.Preview_Date == d);
            if (pre.Count() == 0)
            {
                Preview p = new Preview
                {
                    Doctor_Id = DocId,
                    Patient_Id = PatientId,
                    Preview_Date = d,
                    Caring = false
                };
                _context.Add(p);
                await _context.SaveChangesAsync();
                TempData["PreviewAdded"] = "تم تسجيل الموعد بنجاح";
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
                        { "route","/showPreviewsForPat" },
                    }

                };
                await FCMService.SendNotificationToUserAsync((int)p.Patient_Id, UserType.pat, message);
                var pat = await _context.Patients.FirstOrDefaultAsync(pat => pat.Patient_Id == p.Patient_Id);
                var message2 = new MulticastMessage()
                {
                    Notification = new Notification()
                    {
                        Title = "موعد جديد",
                        Body = "لديك موعد جديد للمريض  " + pat.Patient_Full_Name,
                        //ImageUrl=
                    },
                    Data = new Dictionary<string, string>()
                    {
                        { "route","/showPreviewsForDoc" },
                    }

                };
                await FCMService.SendNotificationToUserAsync((int)p.Doctor_Id, UserType.doc, message2);
                //=========================================================================================
                #endregion

                return RedirectToAction("Master", "Employee", new { id = EmpId });
            }

            TempData["TimePatient"] = "لدى المريض موعد آخر في نفس التوقيت يرجى اختيار توقيت آخر";
            //int id, int EmpId, int PatientId, int DocId, DateTime date
            return RedirectToAction("PickDate", new { id = id, EmpId = EmpId, DocId = DocId, PatientId = PatientId });
        }
        #endregion

        // GET: Preview/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var preview = await _context.Previews.FindAsync(id);
            if (preview == null)
            {
                return NotFound();
            }
            return View(preview);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Preview_Id,Preview_Date,Caring,Patient_Id,Doctor_Id")] Preview preview)
        {
            if (id != preview.Preview_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(preview);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!PreviewExists(preview.Preview_Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(preview);
        }

        // GET: Preview/Delete/5
        public async Task<IActionResult> Delete(int? id,int DocId,int HoId)
        {
            if (id == null)
            {
                return NotFound();
            }
            var preview = await _context.Previews.FindAsync(id);
            if (preview == null)
            {
                return NotFound();
            }           
            _context.Previews.Remove(preview);
            await _context.SaveChangesAsync();
            #region send notification
            //==============================================================================================
            var doc = await _context.Doctors.FirstOrDefaultAsync(d => d.Doctor_Id == preview.Doctor_Id);
            var message = new MulticastMessage()
            {
                Notification = new Notification()
                {
                    Title = "ألغي الموعد",
                    Body = "تم إلغاء الموعد عند الطبيب " + doc.Doctor_Full_Name,
                    //ImageUrl=
                },
                Data = new Dictionary<string, string>()
                {
                    { "route","/showPreviewsForPat" },
                }

            };
            await FCMService.SendNotificationToUserAsync((int)preview.Patient_Id, UserType.pat, message);
            //=========================================================================================
#endregion

            return RedirectToAction("Master", "Doctor", new { id = DocId, HoId = HoId });
        }

        private bool PreviewExists(int id)
        {
            return _context.Previews.Any(e => e.Preview_Id == id);
        }
        private List<TimeSpan> PreviewAlgo(List<Work_Days> workDays, DateTime date, int DocId)
        {
            var DayHours = workDays.Where(w => date.DayOfWeek.CompareTo((DayOfWeek)((int)w.Day)) == 0).ToList()[0];
            TimeSpan HalfHour = TimeSpan.FromMinutes(30);
            var prev = _context.Previews.Where(p => p.Doctor_Id == DocId && p.Preview_Date.Date == date.Date).Select(s => s.Preview_Date.TimeOfDay);
            List<TimeSpan> data = new List<TimeSpan>();
            for (TimeSpan i = DayHours.Start_Hour; i < DayHours.End_Hour; i += HalfHour)
            {
                if (!prev.Contains(i))
                    data.Add(i);
            }
            return data;
        }
        private bool ValidateDate(int id, int DocId, int DeptId, DateTime date, List<Work_Days> workDays)
        {

            foreach (var item in workDays)
                if (date.DayOfWeek.CompareTo((DayOfWeek)((int)item.Day)) == 0)
                    return true;
            return false;
        }
        private async Task<List<Specialization_Dept>> GetDepartments(int id)
        {

            var departments = await _context.Departments.Where(w => w.Ho_Id == id).ToListAsync();
            var data = (from dept in departments
                        join spec in _context.Specializations.ToList()
                        on dept.Department_Name equals spec.Specialization_Id
                        select new Specialization_Dept
                        {
                            Dept_Id = dept.Department_Id,
                            Spec_Name = spec.Specialization_Name
                        }).ToList();
            return data;
        }
        private async Task<List<HoDoctors>> GetHospitalDoctors(int id)
        {
            var doctors = await _context.Doctors.Where(d => d.Department_Id == id && d.Active).ToListAsync();
            var data = (from d in doctors
                        select new HoDoctors
                        {
                            DoctorId = d.Doctor_Id,
                            DoctorFullName = d.Doctor_Full_Name,
                            PhoneNumbers = _context.Doctor_Phone_Numbers.Where(dpn => dpn.Doctor_Id == d.Doctor_Id).Select(s => s.Doctor_Phone_Number).ToList()
                        }).ToList();
            return data;
        }

        public async Task<IActionResult> GetTimes(DateTime date , int DocId)
        { // "2022-12-10"

            if ( date != default)
            {
                bool success = false;
                var workDays = await _context.Work_Days.Where(w => w.Doctor_Id == DocId).ToListAsync();
                foreach (var item in workDays)
                {
                    if (date.DayOfWeek.CompareTo((DayOfWeek)((int)item.Day)) == 0)
                    {
                        if (true)
                        {

                        }
                        success = true;
                        break;
                    }
                }
                List<SelectListItem> TimeSelect = null;
                string message = string.Empty;
                if (!success)
                {
                    message = "الرجاء إختيار احد ايام دوامك";
                    return Json(new { TimeSelect, message });
                }
                // Start of algo;
                var DayHours = workDays.Where(w => date.DayOfWeek.CompareTo((DayOfWeek)((int)w.Day)) == 0).ToList()[0];
                TimeSpan HalfHour = TimeSpan.FromMinutes(30);
                var prev = _context.Previews.Where(p => p.Doctor_Id == DocId && p.Preview_Date.Date == date.Date).Select(s => s.Preview_Date.TimeOfDay).ToList();
                List<TimeSpan> data = new List<TimeSpan>();
                for (TimeSpan i = DayHours.Start_Hour; i < DayHours.End_Hour; i += HalfHour)
                {
                    if(date.DayOfWeek.CompareTo(DateTime.Now.DayOfWeek) ==0)
                    {
                        if (i.Hours<=DateTime.Now.Hour)
                        {
                            prev.Add(i);
                        }
                    }
                    if (!prev.Contains(i))
                        data.Add(i);
                }
                if (data.Count==0)
                {
                    message = "لا يوجد اوقات متاحة في هذا اليوم !";
                    return Json(new { TimeSelect, message });
                }
                 TimeSelect = data
                    .Select(n => new SelectListItem { Value = n.ToString(), Text = n.Hours >= 12 ? (n.Hours != 12 ? n.Hours - 12 : n.Hours).ToString() + " : " + (n.Minutes.ToString() == "0" ? "00  " : "30  ") + "PM" : (n.Hours == 0 ? 12 : n.Hours).ToString() + " : " + (n.Minutes.ToString() == "0" ? "00  " : "30  ") + "AM" }).ToList();
                return Json(new { TimeSelect, message });
              
              
            }
         
            return null;
        }

    }
}
