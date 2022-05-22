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
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using LastHMS2.Class_Attriputes;

namespace LastHMS2.Controllers
{
    public class EmployeeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public EmployeeController(ApplicationDbContext context)
        {
            _context = context;
        }
        //***********************************************************
        //  [Authorize(Roles = "IT,Resception,Nurse,HeadNurse")]
        public IActionResult Master(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }
            var employee = _context.Employees.FirstOrDefault(e => e.Employee_Id == id);
            if (employee == null)
            {
                return NotFound();
            }
            if (employee.Employee_Job == "IT") return RedirectToAction("IT", new { id = id });
            if (employee.Employee_Job == "Resception") return RedirectToAction("Resception", new { id = id });
            if (employee.Employee_Job == "Nurse") return RedirectToAction("Nurse", new { id = id });
            if (employee.Employee_Job == "HeadNurse") return RedirectToAction("HeadNurse", new { id = id });
            return NotFound();
        }
        // in view onclick (عرض الغرف) ==> /Room/DisplayRooms/@Model.Ho_Id /Model.Id
        // in view onclick (عرض غرف العمليات) ==> /Surgery_Room/DisplaySurgeryRooms/@Model.Ho_Id /Model.Id
        // in view onclick (عرض الأقسام) ==> /Department/HoDepartments/Model.Ho_Id
        // in view onclick (إضافة موظف استقبال) ==> /Employee/CreateResception/Model.Ho_Id done
        // in view onclick (استعراض رؤساء الأقسام ) ==> /Doctor/DeptManagers/@Model.Doctor_Id  done
        // in view onclick (حظر مستخدم) ==> // /Employee/BlockUser/@Model.Ho_Id // inactive
        //[Authorize(Roles = "IT")]
        public IActionResult IT(int id)
        {
            var IT = _context.Employees.Find(id);
            if (!IT.Active)
                return RedirectToAction("LogOut");
            if (IT == null) return NotFound();
            return View(IT);
        }
        // in view onclick (إلغاء حجز غرفة) ==> /Room/BusyRooms/@Model.Ho_Id //محجوزة done
        // in view onclick (حجز غرفة) ==> /Patient/HoPatientsForReservation/Model.Ho_Id + Model.Employee_Id==> /Room/AvailableRooms/@Model.Patient_Id done
        // in view onclick (عرض الأطباء) ==> /Doctor/HoDoctors/@Model.Ho_Id  
        // in view onclick (تسجيل فاتورة لمريض) ==> /Patient/HoPatientsForBill/@Model.Ho_Id  // for bills
        // in view onclick (حجز موعد للمريض) ==> /Patient/HoPatientsForPreview/@Model.Ho_Id  
        // in view onclick (عرض المرضى) ==> /Patient/HoPatientsForReservation/@Model.Ho_Id  
        // in view onclick (تسجيل مريض) ==> /Patient/Create/@Model.Ho_Id  
        //[Authorize(Roles = "Resception")]
        public async Task<IActionResult> Resception(int id)
        {
            var Resception = await _context.Employees.FindAsync(id);
            if (!Resception.Active)
                return RedirectToAction("LogOut");

            if (Resception == null) return NotFound();
            ViewBag.HospitalName = _context.Hospitals.Find(Resception.Ho_Id).Ho_Name;
            ViewBag.PatientsXYs = await _context.Patients.Where(p => p.Active && p.Ho_Id == Resception.Ho_Id).Select(s => s.Patient_X_Y).ToListAsync();
            return View(Resception);
        }



        // in view onclick (عرض الممرضين) ==> /Employee/DisplayNurses/Model.Ho_Id
        // in view onclick (عن طريق الاسم) ==> /Patient/DisplayPatientsByName/Model.Ho_Id / EMpid / Search string
        // in view onclick (عن طريق رقم الغرفة) ==> /Patient/DisplayPatientsByRoomNumber/Model.Ho_Id / EMpid / Search string
        // [Authorize(Roles = "HeadNurse")]
        public async Task<IActionResult> HeadNurse(int id)

        {
            var HeadNurse = await _context.Employees.FindAsync(id);
            if (!HeadNurse.Active)
                return RedirectToAction("LogOut");
            var XYsPlusNames = await _context.Employees.Where(e => e.Employee_Job == "Nurse" && e.Ho_Id == HeadNurse.Ho_Id && e.Active).Select(s => s.Employee_X_Y + "," + s.Employee_Full_Name).ToListAsync();
            ViewBag.NursesXYs = XYsPlusNames;
            var patientRequests = _context.Requests.Where(r => r.Employee_Id == id && r.Accept == false).Select(s => s.Request_Data);
            ViewBag.PatientRequests = await patientRequests.ToListAsync();
            ViewBag.Rooms = await _context.Rooms.Where(r => r.Ho_Id == HeadNurse.Ho_Id).ToListAsync();
            if (HeadNurse == null) return NotFound();
            return View(HeadNurse);
        }
        // [Authorize(Roles = "HeadNurse")]
        public IActionResult DisplayNurses(int id, int HoId)
        {
            var HeadNurse = _context.Employees.Find(id);
            if (!HeadNurse.Active)
                return RedirectToAction("LogOut");
            ViewBag.HoId = HoId;
            ViewBag.EmpId = id;
            var employees = _context.Employees.Where(e => e.Ho_Id == HoId && e.Employee_Job == "Nurse" && e.Active).ToList();
            return View(employees);
        }

        public IActionResult CreateNurse(int id, int EmpId) // HoId(id) , HeadNurse(EmpId)
        {

            Employee e = new Employee
            {
                Ho_Id = id,
                Employee_Job = "Nurse",
                Active = true,
                Employee_Hire_Date = DateTime.Now,
                Employee_Email = "mmmmmmmmmmmmmmmmmmm",
                Employee_Password = "mmmmmmmmmmmmmmmm",

            };
            ViewBag.Cities = _context.Cities.Select(c => new SelectListItem { Value = c.City_Id.ToString(), Text = c.City_Name }).ToList();
            ViewBag.Areas = new List<SelectListItem>();
            ViewBag.EmpId = EmpId;
            return View(e);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateNurse(Employee Nurse, int EmpId, string[] pn) // HoId(id) , HeadNurse(EmpId)
        {
            if (ModelState.IsValid)
            {
                Nurse.Employee_Email = Nurse.Employee_EmailName.Replace(' ', '_');
                Nurse.Employee_Password = Nurse.Employee_National_Number;
                _context.Add(Nurse);
                await _context.SaveChangesAsync();

                Employee_Phone_Numbers[] epn = new Employee_Phone_Numbers[pn.Length];
                for (int i = 0; i < pn.Length; i++)
                {

                    epn[i] = new Employee_Phone_Numbers
                    {
                        Employee_Id = Nurse.Employee_Id,
                        Employee_Phone_Number = pn[i]
                    };
                }
                await _context.AddRangeAsync(epn);
                await _context.SaveChangesAsync();
                FCMService.AddToken(Nurse.Employee_Id, UserType.emp);
                return RedirectToAction("Master", new { id = EmpId });
            }
            return View(Nurse);
        }

        //[Authorize(Roles = "Nurse")]
        public async Task<IActionResult> NurseAsync(int id)
        {
            var Nurse = _context.Employees.Find(id);
            if (!Nurse.Active)
                return RedirectToAction("LogOut");
            if (Nurse == null) return NotFound();
            ViewBag.Rooms = await _context.Rooms.Where(r => r.Ho_Id == Nurse.Ho_Id).ToListAsync();
            return View(Nurse);
        }
        // in view onclick (استعراض التقارير ) ==> wtf 
        // in view onclick (استعراض الموضفين  ) ==> /Employee/HoEmployees/@Model.Employee_Id done // IT/Resception
        // [Authorize(Roles = "Manager")]

        public IActionResult MasterHoMgr(int? id) // put a LogOut button ...
        {
            if (id == null)
            {
                return NotFound();
            }
            var employee = _context.Employees.FirstOrDefault(e => e.Employee_Id == id);
            if (employee == null)
            {
                return NotFound();
            }
            var Hospital = _context.Hospitals.FirstOrDefault(h => h.Manager.Employee_Id == employee.Employee_Id && h.Active);
            if (Hospital == null)
            {
                return NotFound();
            }
            ViewBag.Requests = _context.Requests.Where(r => r.Employee_Id == id && r.Accept == false).ToList();
            return View(employee);
        }
        public IActionResult HoEmployees(int id)
        {
            var manager = _context.Employees.Find(id);
            if (!manager.Active)
            {
                return RedirectToAction("LogOut");
            }
            var hospital = _context.Hospitals.FirstOrDefault(h => h.Manager.Employee_Id == id && h.Active);
            var Employees = _context.Employees.Where(e => e.Ho_Id == hospital.Ho_Id && (e.Employee_Job == "Resception" || e.Employee_Job == "IT" || e.Employee_Job == "HeadNurse") && e.Active);
            ViewBag.HospitalId = hospital.Ho_Id;
            ViewBag.MgrId = id;
            return View(Employees);
        }
        public IActionResult CreateManager(int id)
        {
            Employee mgr = new Employee()
            {
                Ho_Id = id,
                Employee_Email = "mmmmmmmmmm",
                Employee_Password = "mmmmmmmmmmmmmmm",
                Employee_Hire_Date = DateTime.Now,
                Active = true,
                Employee_Job = "Manager",
                Employee_X_Y = "Manager",
            };
            ViewBag.Cities = _context.Cities.Select(c => new SelectListItem { Value = c.City_Id.ToString(), Text = c.City_Name }).ToList();
            ViewBag.Areas = new List<SelectListItem>();
            return View(mgr);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateManager(Employee employee, string[] pn)
        {
            if (ModelState.IsValid)
            {

                employee.Employee_Email = employee.Employee_EmailName.Replace(" ", "_");
                employee.Employee_Password = employee.Employee_National_Number;
                _context.Add(employee);
                _context.SaveChanges();
                Employee_Phone_Numbers[] pns = new Employee_Phone_Numbers[pn.Length];
                for (int i = 0; i < pn.Length; i++)
                {
                    pns[i] = new Employee_Phone_Numbers
                    {
                        Employee_Id = employee.Employee_Id,
                        Employee_Phone_Number = pn[i]
                    };
                }
                await _context.AddRangeAsync(pns);
                await _context.SaveChangesAsync();
                var hospital = _context.Hospitals.Find(employee.Ho_Id);
                hospital.Manager = employee;
                _context.Update(hospital);
                _context.SaveChanges();
                FCMService.AddToken(employee.Employee_Id, UserType.emp);
                return RedirectToAction("Master", "Admin");
            }
            return View(employee);
        }
        public IActionResult LogInIT()
        {
            var hospitals = _context.Hospitals.ToList();
            return View(hospitals);
        }
        public IActionResult LogInResception()
        {
            var hospitals = _context.Hospitals.ToList();
            return View(hospitals);
        }
        public IActionResult LogInNurse()
        {
            var hospitals = _context.Hospitals.ToList();
            return View(hospitals);
        }
        // LogInHeadNurse ???? 
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LogIn(IFormCollection fc, string ReturnUrl)
        {
            var employees = _context.Employees.Where(d => d.Employee_Email == fc["email"].ToString() && d.Employee_Password == fc["password"].ToString()).ToList();
            if (employees.Count == 0) return NotFound();

            var employee = employees.FirstOrDefault(e => e.Ho_Id == int.Parse(fc["hospital"]));
            if (employee is not null)
            {
                //************* cookie Auth
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Email , employee.Employee_Email),
                    new Claim(ClaimTypes.Name,employee.Employee_Password),
                    new Claim(ClaimTypes.Role,employee.Employee_Job),

                };
                var claimsIdentity = new ClaimsIdentity(claims, "LogIn");
                await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(claimsIdentity));
                if (ReturnUrl == null)
                {

                    FCMService.UpdateToken(fc["fcmToken"].ToString(), employee.Employee_Id, UserType.emp, Platform.Web);

                    return RedirectToAction("Master", "Employee", new { id = employee.Employee_Id, HoId = int.Parse(fc["hospital"]) });
                }
                return RedirectToAction(ReturnUrl);
            }
            //*************
            return NotFound();
        }
        public IActionResult LogInHoMgr()
        {
            var hospitals = _context.Hospitals.ToList();
            return View(hospitals);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LogInHoMgr(IFormCollection fc, string ReturnUrl)
        {
            var employees = _context.Employees.Where(d => d.Employee_Email == fc["email"].ToString() && d.Employee_Password == fc["password"].ToString()).ToList();
            if (employees.Count == 0) return NotFound();
            var HoManager = employees.FirstOrDefault(e => e.Ho_Id == int.Parse(fc["hospital"]));
            if (HoManager is not null)
            {
                //************* cookie Auth
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Email , HoManager.Employee_Email),
                    new Claim(ClaimTypes.Name,HoManager.Employee_Password),
                    new Claim(ClaimTypes.Role,"Manager"),

                };
                var claimsIdentity = new ClaimsIdentity(claims, "LogIn");
                await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(claimsIdentity));
                if (ReturnUrl == null)
                {

                    FCMService.UpdateToken(fc["fcmToken"].ToString(), HoManager.Employee_Id, UserType.emp, Platform.Web);

                    return RedirectToAction("MasterHoMgr", "Employee", new { id = HoManager.Employee_Id });
                }
                return RedirectToAction(ReturnUrl);
            }
            //*************
            return View();

        }
        public async Task<IActionResult> LogOut(int id)
        {
            await HttpContext.SignOutAsync();
            FCMService.RemoveUnusedToken(id, UserType.emp, Platform.Web);
            return RedirectToAction("Index", "Home");
        }
        //***********************************************************

        // GET: Employee
        public async Task<IActionResult> Index()
        {
            return View(await _context.Employees.ToListAsync());
        }

        // GET: Employee/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }
            var employee = await _context.Employees
                .FirstOrDefaultAsync(m => m.Employee_Id == id);
            if (employee == null)
            {
                return NotFound();
            }
            return View(employee);
        }

        // GET: Employee/Create 
        // [Authorize(Roles = "Manager")]
        public IActionResult Create(int HoId, int MgrId) // Mgr.HoId
        {
            var manager = _context.Employees.Find(MgrId);
            if (!manager.Active)
            {
                return RedirectToAction("LogOut");
            }
            Employee e = new Employee
            {
                Ho_Id = HoId,
                Active = true,
                Employee_Email = "mmmmmmmmmmmmmmmmm",
                Employee_Password = "mmmmmmmmmmmmmmmmm",
                Employee_Hire_Date = DateTime.Now,
                Employee_X_Y = "mmmmmmmmmmmmmmm"

            };
            ViewBag.Cities = _context.Cities.Select(c => new SelectListItem { Value = c.City_Id.ToString(), Text = c.City_Name }).ToList();
            ViewBag.Areas = new List<SelectListItem>();
            ViewBag.MgrId = MgrId;
            return View(e);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        // [Authorize(Roles = "Manager")]
        public async Task<IActionResult> Create(Employee employee, int MgrId, string[] pn)
        {
            var manager = _context.Employees.Find(MgrId);
            if (!manager.Active)
            {
                return RedirectToAction("LogOut");
            }
            if (ModelState.IsValid)
            {
                employee.Employee_Email = employee.Employee_EmailName.Replace(' ', '_');
                employee.Employee_Password = employee.Employee_National_Number;
                employee.Employee_X_Y = employee.Employee_Job;
                _context.Add(employee);
                await _context.SaveChangesAsync();
                Employee_Phone_Numbers[] pns = new Employee_Phone_Numbers[pn.Length];
                for (int i = 0; i < pn.Length; i++)
                {
                    pns[i] = new Employee_Phone_Numbers
                    {
                        Employee_Id = employee.Employee_Id,
                        Employee_Phone_Number = pn[i]
                    };
                }
                await _context.AddRangeAsync(pns);
                await _context.SaveChangesAsync();
                FCMService.AddToken(employee.Employee_Id, UserType.emp);
                return RedirectToAction("MasterHoMgr", new { id = MgrId });
            }
            return View(employee);
        }

        // GET: Employee/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var employee = await _context.Employees.FindAsync(id);
            if (employee == null)
            {
                return NotFound();
            }
            return View(employee);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Employee employee)
        {
            if (id != employee.Employee_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(employee);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!EmployeeExists(employee.Employee_Id))
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
            return View(employee);
        }

        // GET: Employee/Delete/5    // Resception / IT / HeadNurse
        public async Task<IActionResult> Delete(int? id, int MgrId)
        {
            var employee = await _context.Employees.FindAsync(id);
            employee.Active = false;
            await _context.SaveChangesAsync();
            FCMService.RemoveToken(employee.Employee_Id, UserType.emp);
            return RedirectToAction("HoEmployees", new { id = MgrId });
        }
        public async Task<IActionResult> DeleteNurse(int? id, int HeadNurseId)
        {
            var employee = await _context.Employees.FindAsync(id);
            employee.Active = false;
            await _context.SaveChangesAsync();
            FCMService.RemoveToken(employee.Employee_Id, UserType.emp);
            return RedirectToAction("DisplayNurses", new { id = HeadNurseId, HoId = employee.Ho_Id });
        }

        public async Task<IActionResult> ShowActiveEmployeesForIT(int id) //IT(id)
        {
            var IT = _context.Employees.Find(id);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            ViewBag.EmpId = id;
            var Nurses = await _context.Employees.Where(e => e.Ho_Id == IT.Ho_Id && e.Active && e.Employee_Job == "Nurse").ToListAsync();
            return View(Nurses);
        }
        public async Task<IActionResult> ShowUnActiveEmployeesForIT(int id) //IT(id)
        {
            var IT = _context.Employees.Find(id);
            if (!IT.Active)
                return RedirectToAction("LogOut");
            ViewBag.EmpId = id;
            return View(await _context.Employees.Where(e => e.Ho_Id == IT.Ho_Id && e.Active == false && e.Employee_Job == "Nurse").ToListAsync());
        }

        public async Task<IActionResult> DeActivate(int? id, int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut");
            var employee = await _context.Employees.FindAsync(id);
            employee.Active = false;
            await _context.SaveChangesAsync();
            FCMService.RemoveToken(employee.Employee_Id, UserType.emp);
            return RedirectToAction("ShowActiveEmployeesForIT", new { id = EmpId });
        }
        public async Task<IActionResult> Activate(int? id, int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut");
            var employee = await _context.Employees.FindAsync(id);
            employee.Active = true;
            await _context.SaveChangesAsync();
            FCMService.AddToken(employee.Employee_Id, UserType.emp);
            return RedirectToAction("ShowUnActiveEmployeesForIT", new { id = EmpId });
        }
        private bool EmployeeExists(int id)
        {
            return _context.Employees.Any(e => e.Employee_Id == id);
        }
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
