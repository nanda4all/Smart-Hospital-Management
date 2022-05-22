using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LastHMS2.Data;
using LastHMS2.Models;
using Microsoft.AspNetCore.Hosting;
using LastHMS2.ShowClasses;
using System.IO;
using FirebaseAdmin.Messaging;

namespace LastHMS2.Controllers
{
    public class Medical_TestController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IWebHostEnvironment _hosting;
        public Medical_TestController(ApplicationDbContext context, IWebHostEnvironment hosting)
        {
            _context = context;
            _hosting = hosting;
        }

        //***********************************************************
        public IActionResult ShowMedicalTestForPatient(int id)//medical id
        {
            var test = (from mt in _context.Medical_Tests.ToList()
                        join type in _context.Test_Types
                        on mt.Test_Type_Id equals type.Test_Type_Id
                        where mt.Medical_Detail_Id == id
                        select new ShowMedicalTest { Date = mt.Test_Date, Test_Type = type.Test_Type_Name, Test_Id = mt.Test_Id, Result = mt.Test_Result }).ToList();
            ViewBag.Medical_Detail_Id = id;
            return View(test);
        }
        //***********************************************************


        // GET: Medical_Test
        public async Task<IActionResult> Index()
        {
            return View(await _context.Medical_Tests.ToListAsync());
        }

        // GET: Medical_Test/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var medical_Test = await _context.Medical_Tests
                .FirstOrDefaultAsync(m => m.Test_Id == id);
            if (medical_Test == null)
            {
                return NotFound();
            }

            return View(medical_Test);
        }

        // GET: Medical_Test/Create
        public IActionResult Create(int id)
        {
            Medical_Test mt = new Medical_Test()
            {
                Medical_Detail_Id = id
            };
            return View(mt);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Medical_Test medical_Test)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    string fileName = string.Empty;
                    if (medical_Test.File != null)
                    {
                        string Medical_Test_Result = Path.Combine(_hosting.WebRootPath, "Medical_Test_Result");
                        fileName = medical_Test.File.FileName;
                        string fullPath = Path.Combine(Medical_Test_Result, fileName);
                        medical_Test.File.CopyTo(new FileStream(fullPath, FileMode.Create));
                        medical_Test.Test_Result = fileName;
                    }
                }
                catch { }

                _context.Add(medical_Test);
                await _context.SaveChangesAsync();
                #region send notification
                //==============================================================================================
                var t = await _context.Test_Types.FirstOrDefaultAsync(t => t.Test_Type_Id == medical_Test.Test_Type_Id);
                var p = _context.Medical_Details.Include(p => p.Patient).FirstOrDefault(p => p.Medical_Details_Id == medical_Test.Medical_Detail_Id);
                var message = new MulticastMessage()
                {
                    Notification = new Notification()
                    {
                        Title = "تحليل جديد",
                        Body = "تم إضافة تحليل " + t.Test_Type_Name + " جديد.",
                        //ImageUrl=
                    },
                    Data = new Dictionary<string, string>()
                    {
                        { "route","/ShowTests" },
                    }

                };
                await FCMService.SendNotificationToUserAsync(p.Patient.Patient_Id, UserType.pat, message);
                //=========================================================================================
                #endregion

                return RedirectToAction(nameof(Index));
            }
            return View(medical_Test);
        }

        // GET: Medical_Test/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var medical_Test = await _context.Medical_Tests.FindAsync(id);
            if (medical_Test == null)
            {
                return NotFound();
            }
            return View(medical_Test);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id,Medical_Test medical_Test)
        {
            if (id != medical_Test.Test_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(medical_Test);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!Medical_TestExists(medical_Test.Test_Id))
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
            return View(medical_Test);
        }

        // GET: Medical_Test/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }
            var medical_Test = await _context.Medical_Tests.FindAsync(id);
            if (medical_Test == null)
            {
                return NotFound();
            }

            _context.Medical_Tests.Remove(medical_Test);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        private bool Medical_TestExists(int id)
        {
            return _context.Medical_Tests.Any(e => e.Test_Id == id);
        }
    }
}
