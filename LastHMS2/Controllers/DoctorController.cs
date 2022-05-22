using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LastHMS2.Data;
using LastHMS2.Models;
using Microsoft.AspNetCore.Http;
using LastHMS2.ShowClasses;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Newtonsoft.Json;
using LastHMS2.Class_Attriputes;

namespace LastHMS2.Controllers
{
    public class DoctorController : Controller
    {
        private readonly ApplicationDbContext _context;

        public DoctorController(ApplicationDbContext context)
        {
            _context = context;
        }

        //***********************************************************

        // GET: /Doctor/Master/5
        // in view onclick (إلغاء حجز غرفة) ==> /Surgery_Room/DoctorIndex/Model.Doctor_Id
        // in view onclick (حجز غرفة عمليات) ==> /Surgery/Create/Model.Doctor_Id
        // in view onclick (حجز موعد ) ==> /Patient/HoPatientsForPreview/Model.Doctor_Id
        // in view onclick (المرضى) ==> /Patient/DoctorIndex/Model.Doctor_Id
        //[Authorize(Roles = "Doctor")]
        public IActionResult Master(int? id , int? HoId)
        {

            var doctor = _context.Doctors.FirstOrDefault(m => m.Doctor_Id == id);
            if (doctor == null)
            {
                return NotFound();
            }
            if (!doctor.Active)
                return RedirectToAction("LogOut");
            var Department = _context.Departments.FirstOrDefault(m => m.Dept_Manager.Doctor_Id == doctor.Doctor_Id);

            if (Department != null)
            {
                return RedirectToAction("MasterDeptMgr", new { id = id, HoId = HoId });
            }
            var doctorPreviews = (from pre in _context.Previews
                                 join pat in _context.Patients
                                 on pre.Patient_Id equals pat.Patient_Id
                                 where pre.Doctor_Id == id && pre.Preview_Date > DateTime.Now
                                 orderby pre.Preview_Date
                                 select new ShowPreviewsForDoctor
                                 {
                                     PreviewId = pre.Preview_Id,
                                     PatientName = pat.Patient_First_Name + " " + pat.Patient_Last_Name,
                                     PreviewDate = pre.Preview_Date.ToString("MM/dd/yyyy"),
                                     PreviewHour = pre.Preview_Date.ToString("hh-mm-tt")
                                 }).ToList();
            ViewBag.DoctorName = doctor.Doctor_First_Name + " " + doctor.Doctor_Last_Name;
            ViewBag.DoctorId = doctor.Doctor_Id;
            ViewBag.HospitalId = HoId;
            return View(doctorPreviews);
        }
        // Doctor + 
        // in view on click (أطباء) ==> /Doctor/DisplayDoctrosByDeptId/ViewBag.DeptMgrId      done
        // in view on click (إستعراض دوام الأطباء) ==> /Work_days/DisplayDoctroDays/@Model.DoctorId
        //[Authorize(Roles = "Doctor")]
        public IActionResult MasterDeptMgr(int id , int HoId)
        {
            var doctor = _context.Doctors.FirstOrDefault(m => m.Doctor_Id == id);
            var doctorPreviews = (from pre in _context.Previews
                                  join pat in _context.Patients
                                  on pre.Patient_Id equals pat.Patient_Id
                                  where pre.Doctor_Id == id && pre.Preview_Date > DateTime.Now
                                  orderby pre.Preview_Date
                                  select new ShowPreviewsForDoctor
                                  {
                                      PreviewId = pre.Preview_Id,
                                      PatientName = pat.Patient_First_Name + " " + pat.Patient_Last_Name,
                                      PreviewDate = pre.Preview_Date.ToString("MM/dd/yyyy"),
                                      PreviewHour = pre.Preview_Date.ToString("hh-mm-tt")
                                  }).ToList(); ViewBag.DeptMgrName = doctor.Doctor_First_Name + " " + doctor.Doctor_Last_Name;
            ViewBag.DeptMgrId = doctor.Doctor_Id;
            ViewBag.DoctorName = doctor.Doctor_First_Name + " " + doctor.Doctor_Last_Name;
            ViewBag.HoId = HoId;
            return View(doctorPreviews);
        }
        // in view on click (إضافة جدول دوام) ==> /Work_days/Create/@Model.DoctorId
        public IActionResult DisplayDoctrosByDeptId(int id,int HoId) // dept manager's id
        {
            var Deptmanager = _context.Doctors.FirstOrDefault(d => d.Doctor_Id == id );
            var dept = _context.Departments.Where(d => d.Department_Id == Deptmanager.Department_Id).Include(d => d.Dept_Manager).ToArray()[0];
            if (!Deptmanager.Active && Deptmanager.Doctor_Id == dept.Dept_Manager.Doctor_Id)
                return RedirectToAction("LogOut");
            var doctors = _context.Doctors.Where(d => d.Department_Id == Deptmanager.Department_Id && d.Doctor_Id != Deptmanager.Doctor_Id && d.Active).ToList();
            if (doctors == null) return Ok("this deprtment is empty !!");
            ViewBag.DeptMgrId = id;
            ViewBag.DeptId = Deptmanager.Department_Id;
            ViewBag.HoId = HoId;
            return View(doctors);
        }
        //[Authorize(Roles ="Resception")]
        public IActionResult HoDoctors(int id , int EmpId) //Resception.Ho_Id
        { // تفاصيل عامة ===> ساعات الدوام 
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut", "Employee");
            var departments = _context.Departments.Where(d => d.Ho_Id == id).ToList();
            var doctors = (from d in _context.Doctors.ToList()
                           join dept in departments
                           on d.Department_Id equals dept.Department_Id
                           where d.Active == true
                           select new HoDoctors
                           {
                               DoctorId = d.Doctor_Id,
                               DoctorFullName = d.Doctor_Full_Name,
                               Specialization = _context.Specializations.Find(dept.Department_Name).Specialization_Name,
                               PhoneNumbers = _context.Doctor_Phone_Numbers.Where(pn => pn.Doctor_Id == d.Doctor_Id).Select(s=>s.Doctor_Phone_Number).ToList()
                           }).ToList();
            ViewBag.HoId = id;
            ViewBag.EmpId = EmpId;
            return View(doctors);
        }
        // add by omar and amjad
        public IActionResult DeptManagers(int id , int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut");
            var dept = _context.Departments.Where(d => d.Dept_Manager != null && d.Ho_Id == id).ToList();
            var deptmanagers = (from doc in _context.Doctors.ToList()
                                join d in dept
                                on doc.Doctor_Id equals d.Dept_Manager.Doctor_Id
                                into groupDept
                                from c in groupDept.DefaultIfEmpty()
                                where c is not null
                                select new { c, doc }
                                into a
                                join spec in _context.Specializations.ToList()
                                on a.c.Department_Name equals spec.Specialization_Id
                                select new DeptManagers
                                {
                                    MgrName = a.doc.Doctor_Full_Name,
                                    DeptName = spec.Specialization_Name,
                                    Id = a.c.Department_Id,
                                    DoctorManagerId = a.doc.Doctor_Id
                                }).ToList();
            ViewBag.Ho_Id = id;
            ViewBag.EmpId = EmpId;
            return View(deptmanagers);
        }
        // add by omar and amjad
        public IActionResult EditDeptManager(int id, int DoctorId,int EmpId, string search = "")
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            var department = _context.Departments.Find(id);
            department.Dept_Manager = _context.Doctors.Find(DoctorId);
            var Doctors = _context.Doctors.Where(d => d.Department_Id == id
             && d.Doctor_Id != department.Dept_Manager.Doctor_Id)
            .ToList();
            ViewBag.DeptID = id;
            ViewBag.EmpId= EmpId;
            ViewBag.Ho_Id = department.Ho_Id;
            ViewBag.DoctorId = DoctorId;
            if (string.IsNullOrEmpty(search))
                return View(Doctors);
            else
                Doctors = Doctors.Where(d => d.Doctor_Full_Name.Contains(search)).ToList();
            return View(Doctors);
        }
        public IActionResult LogIn()
        {
            var hospitals = _context.Hospitals.ToList();
            return View(hospitals);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LogIn(IFormCollection fc, string ReturnUrl) //Done Auth
        {
           // TempData["LoginFailed"] = "Login Failed";
            var doctors = _context.Doctors.Where(d => d.Doctor_Email == fc["email"].ToString() && d.Doctor_Password == fc["password"].ToString()).ToList();
            if (doctors.Count == 0) return NotFound();
            var hospital = _context.Hospitals.FirstOrDefault(h => h.Ho_Id == int.Parse(fc["hospital"]));
            var data = (from doc in doctors
                        join dept in _context.Departments.ToList()
                        on doc.Department_Id equals dept.Department_Id
                        where dept.Ho_Id == hospital.Ho_Id
                        select doc).ToList();
            if (data.Count == 0) return NotFound();
            Doctor doctor = data[0];
            
            if (doctor is not null)
            {
                //************* cookie Auth
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Email , doctor.Doctor_Email),
                    new Claim(ClaimTypes.Name,doctor.Doctor_Password),
                    new Claim(ClaimTypes.Role,"Doctor")
                };
                var claimsIdentity = new ClaimsIdentity(claims, "LogIn");
                await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(claimsIdentity));
                if (ReturnUrl == null)
                {

                    FCMService.UpdateToken(fc["fcmToken"].ToString(), doctor.Doctor_Id, UserType.doc, Platform.Web);

                    return RedirectToAction("Master", "Doctor", new { id = doctor.Doctor_Id, HoId = hospital.Ho_Id });
                }
                return RedirectToAction(ReturnUrl);
            }
            //*************
            return View();
        }
        public IActionResult CreateDeptManager(int id , int EmpId) //IT.Ho_Id
        {
            Doctor doctor = new Doctor()
            {
                Doctor_Email = "mmmmmmmmmm",
                Doctor_Password = "mmmmmmmmmmmmmmm",
                Doctor_Hire_Date = DateTime.Now
            };
            var specializations = (from s in _context.Specializations
                                   join dept in _context.Departments
                                   on s.Specialization_Id equals dept.Department_Name
                                   where dept.Ho_Id == id && dept.Dept_Manager == null
                                   select new Specialization_Dept { Dept_Id = dept.Department_Id, Spec_Name = s.Specialization_Name })
                                   .ToList();
            ViewBag.Specializations = specializations;
            ViewBag.Cities = _context.Cities.Select(c => new SelectListItem { Value = c.City_Id.ToString(), Text = c.City_Name }).ToList();
            ViewBag.Areas = new List<SelectListItem>();
            ViewBag.Ho_Id = id;
            ViewBag.EmpId = EmpId;
            return View(doctor);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateDeptManager(Doctor doctor , int EmpId , string[] pn)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut");
            if (ModelState.IsValid)
            {
                doctor.Doctor_Email = doctor.Doctor_EmailName.Replace(" ", "_");
                doctor.Doctor_Password = doctor.Doctor_National_Number;
         
                List<Doctor_Phone_Numbers> pns = new();
                for (int i = 0; i < pn.Length; i++)
                {
                    if (pn[i] is not null)
                    {
                        pns.Add(new Doctor_Phone_Numbers
                        {
                            Doctor_Id = doctor.Doctor_Id,
                            Doctor_Phone_Number = pn[i]
                        });
                    }
                }
                doctor.Doctor_Phone_Numbers = pns;     
                return RedirectToAction("AddDeptManager", "Request", new { EmpId, doctor = JsonConvert.SerializeObject(doctor) });
            }
            return View(doctor);
        }
        public async Task<IActionResult> LogOut(int id)//doc id
        {
            await HttpContext.SignOutAsync();
            FCMService.RemoveUnusedToken(id,UserType.doc,Platform.Web);
            return RedirectToAction("Index", "Home");
        }
        //***********************************************************


        // GET: Doctor
        public async Task<IActionResult> Index()
        {
            return View(await _context.Doctors.ToListAsync());
        }

        public async Task<IActionResult> Details(int? id , int HoId)
        {
            if (id == null)
            {
                return NotFound();
            }

            var doctor = await _context.Doctors
                .FirstOrDefaultAsync(m => m.Doctor_Id == id);
            if (doctor == null)
            {
                return NotFound();
            }
            ViewBag.HoId = HoId;
            return View(doctor);
        } 
        public async Task<IActionResult> DetailsForDeptMgr(int? id , int HoId , int DeptMgrId)
        {
            var Deptmanager = _context.Doctors.Find(DeptMgrId);
            var dept = _context.Departments.Where(d => d.Department_Id == Deptmanager.Department_Id).Include(d => d.Dept_Manager).ToArray()[0];
            if (!Deptmanager.Active && Deptmanager.Doctor_Id == dept.Dept_Manager.Doctor_Id)
                return RedirectToAction("LogOut");
            if (id == null)
            {
                return NotFound();
            }

            var doctor = await _context.Doctors
                .FirstOrDefaultAsync(m => m.Doctor_Id == id);
            if (doctor == null)
            {
                return NotFound();
            }
            ViewBag.HoId = HoId;
            ViewBag.DeptMgrId = DeptMgrId;
            return View(doctor);
        }      
        public async Task<IActionResult> DetailsForResception(int? id,int EmpId,int HoId)
        {
            if (id == null)
            {
                return NotFound();
            }
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut", "Employee");

            var doctor = await _context.Doctors
                .FirstOrDefaultAsync(m => m.Doctor_Id == id);
            if (doctor == null)
            {
                return NotFound();
            }
            ViewBag.HoId = HoId;
            ViewBag.EmpId = EmpId;
            ViewBag.PhoneNumbers = _context.Doctor_Phone_Numbers.Where(pn => pn.Doctor_Id == id).ToList();

            return View(doctor);
        }

        // GET: Doctor/Create
        public IActionResult Create(int id , int DocId , int HoId) // department(id)/ DocId = DeptManagerID
        {
            Doctor doctor = new Doctor()
            {
                Doctor_Email = "mmmmmmmmmm",
                Doctor_Password = "mmmmmmmmmmmmmmm",
                Doctor_Hire_Date = DateTime.Now,
                Department_Id = id
            };
            ViewBag.Cities = _context.Cities.Select(c => new SelectListItem { Value = c.City_Id.ToString(), Text = c.City_Name }).ToList();
            ViewBag.Areas = new List<SelectListItem>();
            ViewBag.HoId = HoId;
            ViewBag.DocId = DocId;
            ViewBag.DeptId = id;
            return View(doctor);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Doctor doctor , int HoId , int DocId , string[] pn) // DocId = DeptManagerID
        {
            if (ModelState.IsValid)
            {
                doctor.Doctor_Email = doctor.Doctor_EmailName.Replace(" ", "_");
                doctor.Doctor_Password = doctor.Doctor_National_Number;
                _context.Add(doctor);
                await _context.SaveChangesAsync();
                List<Doctor_Phone_Numbers> pns = new();
                for (int i = 0; i < pn.Length; i++)
                {
                    if (pn[i] is not null)
                    {
                        pns.Add(new Doctor_Phone_Numbers
                        {
                            Doctor_Id = doctor.Doctor_Id,
                            Doctor_Phone_Number = pn[i]
                        });
                    }
                }
                await _context.AddRangeAsync(pns);
                await _context.SaveChangesAsync();
                FCMService.AddToken(doctor.Doctor_Id, UserType.doc);
                return RedirectToAction("Master", new { id = DocId , HoId = HoId });
            }
            return View(doctor);
        }

        // GET: Doctor/Edit/5
        public async Task<IActionResult> Edit(int? id, int HoId)
        {
            if (id == null)
            {
                return NotFound();
            }
            ViewBag.HoId = HoId;
            ViewBag.Cities = _context.Cities.Select(c => new SelectListItem { Value = c.City_Id.ToString(), Text = c.City_Name }).ToList();
            ViewBag.Areas = new List<SelectListItem>();
            var doctor = await _context.Doctors.FindAsync(id);
            if (doctor == null)
            {
                return NotFound();
            }
            return View(doctor);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id,Doctor doctor)
        {
            if (id != doctor.Doctor_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(doctor);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!DoctorExists(doctor.Doctor_Id))
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
            return View(doctor);
        }

        // GET: Doctor/Delete/5
        public async Task<IActionResult> Delete(int? id , int HoId , int DeptMgrId)
        {
            var doctor = await _context.Doctors.FindAsync(id);
            doctor.Active = false;
            await _context.SaveChangesAsync();
            FCMService.RemoveToken(doctor.Doctor_Id, UserType.doc);
            return RedirectToAction("DisplayDoctrosByDeptId", new { id = DeptMgrId, HoId = HoId });
        }
        // [Authorize(Roles ="IT")]
        public async Task<IActionResult> ShowActiveDoctorsForIT(int id) //IT(id)
        {
            var IT = await _context.Employees.FindAsync(id);
            if (!IT.Active)
                return RedirectToAction("LogOut");
            ViewBag.EmpId = id;
            var data = await (from doc in _context.Doctors
                              join dept in _context.Departments
                              on doc.Department_Id equals dept.Department_Id
                              where dept.Ho_Id == IT.Ho_Id
                              && doc.Active
                              select doc).ToListAsync();
            return View(data);
        } 
       // [Authorize(Roles ="IT")]
        public async Task<IActionResult> ShowUnActiveDoctorsForIT(int id) //IT(id)
        {
            var IT =await  _context.Employees.FindAsync(id);
            if (!IT.Active)
                return RedirectToAction("LogOut");
            ViewBag.EmpId = id;
            var data = await (from doc in _context.Doctors
                        join dept in _context.Departments
                        on doc.Department_Id equals dept.Department_Id
                        where dept.Ho_Id == IT.Ho_Id
                        && doc.Active == false
                        select doc).ToListAsync();
            return View(data);
        }

        public async Task<IActionResult> DeActivate(int? id, int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            var doctor = await _context.Doctors.FindAsync(id);
            doctor.Active = false;
            await _context.SaveChangesAsync();
            FCMService.RemoveToken(doctor.Doctor_Id, UserType.doc);
            return RedirectToAction("ShowActiveDoctorsForIT", new { id = EmpId });
        }
        public async Task<IActionResult> Activate(int? id, int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            var doctor = await _context.Doctors.FindAsync(id);
            doctor.Active = true;
            await _context.SaveChangesAsync();
            FCMService.AddToken(doctor.Doctor_Id, UserType.doc);
            return RedirectToAction("ShowUnActiveDoctorsForIT", new { id = EmpId });
        }

        private bool DoctorExists(int id)
        {
            return _context.Doctors.Any(e => e.Doctor_Id == id);
        }
        // add by omar and amjad
        public IActionResult GetAreas(string CityId)
        {
            if (!string.IsNullOrWhiteSpace(CityId))
            {
                List<SelectListItem> AreaSelect = _context.Areas.Where(a => a.City_Id.ToString() == CityId)
                    .Select(n => new SelectListItem { Value = n.Area_Id.ToString(), Text = n.Area_Name }).ToList();
                return Json(AreaSelect);
            }
            return null;
        }
    }
}
