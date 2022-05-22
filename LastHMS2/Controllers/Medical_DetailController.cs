using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LastHMS2.Data;
using LastHMS2.Models;
using LastHMS2.Break_Tables;
using FirebaseAdmin.Messaging;

namespace LastHMS2.Controllers
{
    public class Medical_DetailController : Controller
    {
        private readonly ApplicationDbContext _context;

        public Medical_DetailController(ApplicationDbContext context)
        {
            _context = context;
        }
        //***********************************************************
        public IActionResult ShowMedicalDetailsForPatient(int id) //patient Id
        {
            var patient = _context.Patients.Find(id);
            if (!patient.Active)
                return RedirectToAction("LogOut", "Patient");
            var details = _context.Medical_Details.FirstOrDefault(d => d.Patient.Patient_Id == id);

            var allergies = (from a in _context.Allergies
                             join ma in _context.Medical_Allergies
                             on a.Allergy_Id equals ma.Allergy_Id
                             where (ma.Medical_Detail_Id == details.Medical_Details_Id)
                             select a).ToList();
            var family_diseases = (from d in _context.Diseases
                                   join md in _context.Medical_Diseases on d.Disease_Id equals md.Disease_Id
                                   where (md.Medical_Detail_Id == details.Medical_Details_Id && md.Family_Health_History == true)
                                   select d).ToList();

            var chronic_diseases = (from d in _context.Diseases
                                    join md in _context.Medical_Diseases on d.Disease_Id equals md.Disease_Id
                                    where (md.Medical_Detail_Id == details.Medical_Details_Id && md.Chronic_Diseases == true)
                                    select d).ToList();
            //var examination = _context.Examination_Records.Where(e => e.Medical_Detail_Id == details.Medical_Details_Id).ToList();

            //ViewBag.Examination = examination;
            ViewBag.allergies = allergies;
            ViewBag.PatientId = id;
            ViewBag.family_diseases = family_diseases;
            ViewBag.chronic_diseases = chronic_diseases;

            return View(details);
        }
        //add by huda and saher
        public IActionResult ShowMedicalDetailsForDoctor(int id , int DocId , int HoId) //patient Id
        {
            var details = _context.Medical_Details.FirstOrDefault(d => d.Patient.Patient_Id == id);
            if (details == null)
            {
                return RedirectToAction("Create", new { id = id , DocId = DocId , HoId =HoId });
            }
            var allergies = (from a in _context.Allergies
                             join ma in _context.Medical_Allergies
                             on a.Allergy_Id equals ma.Allergy_Id
                             where (ma.Medical_Detail_Id == details.Medical_Details_Id)
                             select a).ToList();


            var family_diseases = (from d in _context.Diseases
                                   join md in _context.Medical_Diseases on d.Disease_Id equals md.Disease_Id
                                   where (md.Medical_Detail_Id == details.Medical_Details_Id && md.Family_Health_History == true)
                                   select d).ToList();

            var chronic_diseases = (from d in _context.Diseases
                                    join md in _context.Medical_Diseases on d.Disease_Id equals md.Disease_Id
                                    where (md.Medical_Detail_Id == details.Medical_Details_Id && md.Chronic_Diseases == true)
                                    select d).ToList();
          //  var examination = _context.Examination_Records.Where(e => e.Medical_Detail_Id == details.Medical_Details_Id).ToList();

           // ViewBag.Examination = examination;
            ViewBag.allergies = allergies;
            ViewBag.family_diseases = family_diseases;
            ViewBag.chronic_diseases = chronic_diseases;
            ViewBag.DocId = DocId;
            ViewBag.HoId = HoId;
            return View(details);
        }
        //***********************************************************

        // GET: Medical_Detail
        public async Task<IActionResult> Index()
        {
            return View(await _context.Medical_Details.ToListAsync());
        }

        // GET: Medical_Detail/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var medical_Detail = await _context.Medical_Details
                .FirstOrDefaultAsync(m => m.Medical_Details_Id == id);
            if (medical_Detail == null)
            {
                return NotFound();
            }

            return View(medical_Detail);
        }

        // GET: Medical_Detail/Create
        public IActionResult Create(int? id , int DocId, int HoId)
        {
            if (id == null) return BadRequest();
            if (!_context.Patients.Any(p => p.Patient_Id == id)) return NotFound();
            Medical_Detail d = new Medical_Detail()
            {
                Pa_Id = (int)id
            };
            ViewBag.DocId = DocId;
            ViewBag.HoId = HoId;
            ViewBag.Allergies = _context.Allergies.ToList();
            ViewBag.DiseasesTypes = _context.Diseases_Types.ToList();
            ViewBag.Diseases = new List<SelectListItem>();
            ViewBag.Diseases_Type = _context.Diseases_Types.Select(dt => new SelectListItem { Value = dt.Disease_Type_Id.ToString(), Text = dt.Disease_Type_Name }).ToList();
            return View(d);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Medical_Detail medical_Detail ,int[] Allergies, int[] Diseases,string[]Chronic,string[] Family , int DocId , int HoId)
        {
     
            ViewBag.Allergies = _context.Allergies.ToList();
            ViewBag.DiseasesTypes = _context.Diseases_Types.ToList();
            ViewBag.Diseases = new List<SelectListItem>();
            ViewBag.Diseases_Type = _context.Diseases_Types.Select(dt => new SelectListItem { Value = dt.Disease_Type_Id.ToString(), Text = dt.Disease_Type_Name }).ToList(); ;

            if (ModelState.IsValid)
            {
                medical_Detail.Patient = _context.Patients.Find(medical_Detail.Pa_Id);
                _context.Add(medical_Detail);
                await _context.SaveChangesAsync();
                Medical_Allergy[] ma = new Medical_Allergy[Allergies.Length];
                for (int i = 0; i < ma.Length; i++)
                {
                    ma[i] = new Medical_Allergy()
                    {
                        Medical_Detail_Id = medical_Detail.Medical_Details_Id,
                        Allergy_Id = Allergies[i]
                    };
                }
                await _context.AddRangeAsync(ma);
                await _context.SaveChangesAsync();
                Medical_Disease[] md = new Medical_Disease[Diseases.Length];
                for (int i = 0; i < md.Length; i++)
                {
                    md[i] = new Medical_Disease()
                    {
                        Medical_Detail_Id = medical_Detail.Medical_Details_Id,
                        Disease_Id = Diseases[i],
                        Chronic_Diseases = Chronic[i] == "true" ? true : false,
                        Family_Health_History = Family[i] == "true" ? true : false
                    }; 
                }
                ViewBag.DocId = DocId;
                ViewBag.HoId = HoId;
                await _context.AddRangeAsync(md);
                await _context.SaveChangesAsync();

                #region send notification
                var message = new MulticastMessage()
                {
                    Notification = new Notification()
                    {
                        Title = "الملف الطبي",
                        Body = "تم إضافة الملف الطبي الخاص بك ",
                        //ImageUrl=
                    },
                };

                await FCMService.SendNotificationToUserAsync(medical_Detail.Pa_Id, UserType.pat, message);

                #endregion


                return RedirectToAction("ShowMedicalDetailsForDoctor" , new { id = medical_Detail.Pa_Id ,DocId = DocId , HoId = HoId});
            }
            return View(medical_Detail);
        }

        // GET: Medical_Detail/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var medical_Detail = await _context.Medical_Details.FindAsync(id);
            if (medical_Detail == null)
            {
                return NotFound();
            }
            return View(medical_Detail);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id,Medical_Detail medical_Detail)
        {
            if (id != medical_Detail.Medical_Details_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(medical_Detail);
                    await _context.SaveChangesAsync();

                    #region send notification
                    var message = new MulticastMessage()
                    {
                        Notification = new Notification()
                        {
                            Title = "تعديل على الملف الطبي",
                            Body = "تم تعديل على الملف الطبي ",
                            //ImageUrl=
                        },
                    };
                    var pat = await _context.Medical_Details.Include(p=>p.Patient).FirstOrDefaultAsync(p => p.Medical_Details_Id == medical_Detail.Medical_Details_Id);
                    await FCMService.SendNotificationToUserAsync(pat.Patient.Patient_Id, UserType.pat, message);

                    #endregion

                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!Medical_DetailExists(medical_Detail.Medical_Details_Id))
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
            return View(medical_Detail);
        }

        // GET: Medical_Detail/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }
            var medical_Detail = await _context.Medical_Details.FindAsync(id);
            _context.Medical_Details.Remove(medical_Detail);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        private bool Medical_DetailExists(int id)
        {
            return _context.Medical_Details.Any(e => e.Medical_Details_Id == id);
        }
        public IActionResult GetDiseases(string Diseases_TypeId)
        {
            if (!string.IsNullOrWhiteSpace(Diseases_TypeId))
            {
                List<SelectListItem> DiseasesSelect = _context.Diseases.Where(a => a.Disease_Type_Id.ToString() == Diseases_TypeId)
                    .Select(n => new SelectListItem { Value = n.Disease_Id.ToString(), Text = n.Disease_Name }).ToList();
                return Json(DiseasesSelect);
            }
            return null;
        }
    }
}
