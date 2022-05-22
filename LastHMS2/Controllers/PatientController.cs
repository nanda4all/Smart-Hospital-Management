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
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using LastHMS2.Class_Attriputes;

namespace LastHMS2.Controllers
{
    public class PatientController : Controller
    {
        private readonly ApplicationDbContext _context;

        public PatientController(ApplicationDbContext context)
        {
            _context = context;
        }

        //***********************************************************
        public IActionResult Master(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }
            var patient = _context.Patients.FirstOrDefault(p => p.Patient_Id == id);
            if (patient == null)
            {
                return NotFound();
            }
            if (!patient.Active)
                return RedirectToAction("LogOut");
            ViewBag.PatientName = patient.Patient_First_Name + " " + patient.Patient_Last_Name;
            ViewBag.PatientId = patient.Patient_Id;
            return View(patient);//????
        }
        //ForDoctor
        public IActionResult DoctorIndex(int? id, int HoId) // display doctor's patients by passing the doctor's Id .... 
        {
            if (id == null)
            {
                return NotFound();
            }
            var doctor = _context.Doctors.FirstOrDefault(m => m.Doctor_Id == id);
            if (doctor == null)
            {
                return NotFound();
            }
            var patients = (from p in _context.Patients
                            join pre in _context.Previews
                            on p.Patient_Id equals pre.Patient_Id
                            where (pre.Doctor_Id == doctor.Doctor_Id && pre.Caring == true && p.Active)
                            select p).Distinct().ToList();
            ViewBag.DocId = id;
            ViewBag.HoId = HoId;
            return View(patients);
        }
        public async Task<IActionResult> SetAllCaringsFalse(int id, int DocId, int HoId)
        {
            var doctor = _context.Doctors.Find(DocId);
            if (!doctor.Active)
                return RedirectToAction("LogOut");

            foreach (var item in _context.Previews.Where(p => p.Patient_Id == id && p.Doctor_Id == DocId))
            {
                item.Caring = false;
            }
            await _context.SaveChangesAsync();
            return RedirectToAction("DoctorIndex", new { id = DocId, HoId });
        }
        //ForResception
        public IActionResult HoPatientsForBill(int id, int EmpId)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut");
            var patients = _context.Patients.Where(p => p.Ho_Id == id && p.Active).ToList();
            ViewBag.HospitalId = id;
            ViewBag.EmpId = EmpId;
            return View(patients);
        }
        //ForDoctor
        public IActionResult HoPatientsForPreview(int id, int DocId)
        {
            var data = (from pat in _context.Patients
                        join pre in _context.Previews
                        on pat.Patient_Id equals pre.Patient_Id
                        where pre.Doctor_Id == DocId
                        select pat).ToList();

            var patients = (from d in data
                            group d by d into c
                            select c.Key).ToList();

            ViewBag.HospitalId = id;
            ViewBag.DocId = DocId;
            return View(patients);
        }
        //ForResception
        public IActionResult HoPatientsForReservation(int id, int EmpId)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut");
            var patients = _context.Patients.Include(p => p.Patient_Phone_Numbers).Where(p => p.Ho_Id == id).ToList();
            ViewBag.HoId = id;
            ViewBag.EmpId = EmpId;
            return View(patients);
        }
        //ForResception
        public IActionResult HoPatientsForResception(int id, int EmpId)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut");
            var patients = _context.Patients.Where(p => p.Ho_Id == id).ToList();
            ViewBag.HoId = id;
            ViewBag.EmpId = EmpId;
            return View(patients);
        }

        //for Nurse . HeadNurse
        public IActionResult DisplayPatientsByName(int id, int EmpId, string patientName = "") // HoId(id) , HeadNurse/Nurse(EmpId)
        {
            var Nurse = _context.Employees.Find(EmpId);
            if (!Nurse.Active)
                return RedirectToAction("LogOut");
            var patients = _context.Patients.Where(p => p.Ho_Id == id && p.Active).ToList();
            ViewBag.EmpId = EmpId;
            if (string.IsNullOrEmpty(patientName))
                return View(patients);
            return View(patients.Where(p => p.Patient_Full_Name.Contains(patientName)).ToList());
        }
        //for Nurse . HeadNurse
        public IActionResult DisplayPatientsByRoomNumber(int id, int EmpId, string roomNumber) // HoId(id) , HeadNurse/Nurse(EmpId)
        {
            var Nurse = _context.Employees.Find(EmpId);
            if (!Nurse.Active)
                return RedirectToAction("LogOut");
            var pats = _context.Patients.Where(p => p.Ho_Id == id && p.Active).ToList();
            var patients = (from p in pats
                            join res in _context.Reservations.ToList()
                            on p.Patient_Id equals res.Patient_Id
                            select new { p, res }).ToList();

            var data = (from p in patients
                        join r in _context.Rooms.ToList()
                        on p.res.Room_Id equals r.Room_Id
                        where r.Room_Number.ToUpper().Contains(roomNumber.ToUpper())
                        select p.p).Distinct().ToList();
            ViewBag.EmpId = EmpId;
            return View(data);
            //ViewBag.EmpId = EmpId;
            //if (string.IsNullOrEmpty(roomNumber))
            //    return View(patients);
            //return View(patients.Where(p =>p.Patient_Full_Name.Contains(roomNumber)).ToList());
        }
        //ForResception
        public async Task<IActionResult> DetailsForResception(int id, int EmpId, int HoId)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut");
            var patient = await _context.Patients
                .FirstOrDefaultAsync(m => m.Patient_Id == id);
            if (patient == null)
            {
                return NotFound();
            }
            ViewBag.HoId = HoId;
            ViewBag.EmpId = EmpId;
            ViewBag.PhoneNumbers = _context.Patient_Phone_Numbers.Where(pn => pn.Patient_Id == id).ToList();

            return View(patient);
        }
        //ForDoctor
        public async Task<IActionResult> DetailsForDoctor(int id, int DocId, int HoId) // patient(id)
        {
            var patient = await _context.Patients
                .FirstOrDefaultAsync(m => m.Patient_Id == id);
            if (patient == null)
            {
                return NotFound();
            }
            ViewBag.HoId = HoId;
            ViewBag.DocId = DocId;
            ViewBag.PhoneNumbers = _context.Patient_Phone_Numbers.Where(pn => pn.Patient_Id == id).ToList();

            return View(patient);
        }
        public IActionResult LogIn()
        {
            var hospitals = _context.Hospitals.ToList();
            return View(hospitals);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LogIn(IFormCollection fc, string ReturnUrl)
        {
            var patients = _context.Patients.Where(d => d.Patient_Email == fc["email"].ToString() && d.Patient_Password == fc["password"].ToString()).ToList();
            if (patients.Count == 0) return NotFound();
            var patient = patients.FirstOrDefault(p => p.Ho_Id == int.Parse(fc["hospital"]));
            if (patient is not null)
            {
                //************* cookie Auth
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Email , patient.Patient_Email),
                    new Claim(ClaimTypes.Name,patient.Patient_Password),
                    new Claim(ClaimTypes.Role,"Patient"),
                };
                var claimsIdentity = new ClaimsIdentity(claims, "LogIn");
                await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(claimsIdentity));
                if (ReturnUrl == null)
                {
                    FCMService.UpdateToken(fc["fcmToken"].ToString(), patient.Patient_Id, UserType.pat, Platform.Web);
                    return RedirectToAction("Master", "Patient", new { id = patient.Patient_Id, HoId = patient.Ho_Id });
                }
                return RedirectToAction(ReturnUrl);
            }
            //*************
            return View();
        }
        public async Task<IActionResult> LogOut(int id)
        {
            await HttpContext.SignOutAsync();
            FCMService.RemoveUnusedToken(id, UserType.pat, Platform.Web);
            return RedirectToAction("Index", "Home");
        }
        //***********************************************************

        // GET: Patient
        public async Task<IActionResult> Index()
        {
            return View(await _context.Patients.ToListAsync());
        }

        // GET: Patient/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var patient = await _context.Patients
                .FirstOrDefaultAsync(m => m.Patient_Id == id);
            if (patient == null)
            {
                return NotFound();
            }

            return View(patient);
        }

        // GET: Patient/Create
        public IActionResult Create(int id, int EmpId)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut");
            Patient p = new Patient
            {
                Ho_Id = id,
                Patient_Email = "mmmmmmmmmmmmmmmmm",
                Patient_Password = "mmmmmmmmmmmmmmm"
            };
            ViewBag.Cities = _context.Cities.Select(c => new SelectListItem { Value = c.City_Id.ToString(), Text = c.City_Name }).ToList();
            ViewBag.Areas = new List<SelectListItem>();
            ViewBag.EmpId = EmpId;
            return View(p);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Patient patient, int EmpId, string[] pn)
        {
            if (ModelState.IsValid)
            {
                patient.Patient_Email = patient.Patient_EmailName.Replace(" ", "_"); // Name in english
                patient.Patient_Password = patient.Patient_National_Number;
                _context.Add(patient);
                await _context.SaveChangesAsync();

                Patient_Phone_Numbers[] pns = new Patient_Phone_Numbers[pn.Length];
                for (int i = 0; i < pn.Length; i++)
                {
                    pns[i] = new Patient_Phone_Numbers
                    {
                        Patient_Id = patient.Patient_Id,
                        Patient_Phone_Number = pn[i]
                    };
                }
                await _context.AddRangeAsync(pns);
                await _context.SaveChangesAsync();
                TempData["PatientAdded"] = "تمت إضافة" + patient.Patient_Full_Name;
                FCMService.AddToken(patient.Patient_Id, UserType.pat);
                return RedirectToAction("Master", "Employee", new { id = EmpId });
            }
            return View(patient);
        }

        // GET: Patient/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var patient = await _context.Patients.FindAsync(id);
            if (patient == null)
            {
                return NotFound();
            }
            return View(patient);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Patient patient)
        {
            if (id != patient.Patient_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(patient);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!PatientExists(patient.Patient_Id))
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
            return View(patient);
        }

        //[Authorize(Roles ="IT")]

        public async Task<IActionResult> ShowActivePatientsForIT(int id) //IT(id)
        {
            var IT = _context.Employees.Find(id);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            ViewBag.EmpId = id;
            return View(await _context.Patients.Where(p => p.Ho_Id == IT.Ho_Id && p.Active).ToListAsync());
        }
        public async Task<IActionResult> ShowUnActivePatientsForIT(int id) //IT(id)
        {
            var IT = _context.Employees.Find(id);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            ViewBag.EmpId = id;
            return View(await _context.Patients.Where(p => p.Ho_Id == IT.Ho_Id && p.Active == false).ToListAsync());
        }

        public async Task<IActionResult> DeActivate(int? id, int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            var patient = await _context.Patients.FindAsync(id);
            patient.Active = false;
            await _context.SaveChangesAsync();
            FCMService.RemoveToken(patient.Patient_Id, UserType.pat);
            return RedirectToAction("ShowActivePatientsForIT", new { id = EmpId });
        }
        public async Task<IActionResult> Activate(int? id, int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            var patient = await _context.Patients.FindAsync(id);
            patient.Active = true;
            await _context.SaveChangesAsync();
            FCMService.AddToken(patient.Patient_Id, UserType.pat);
            return RedirectToAction("ShowUnActivePatientsForIT", new { id = EmpId });
        }
        private bool PatientExists(int id)
        {
            return _context.Patients.Any(e => e.Patient_Id == id);
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
