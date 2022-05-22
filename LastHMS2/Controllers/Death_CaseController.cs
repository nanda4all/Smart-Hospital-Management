using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LastHMS2.Data;
using LastHMS2.Models;
using Microsoft.AspNetCore.Authorization;
using FirebaseAdmin.Messaging;

namespace LastHMS2.Controllers
{
    public class Death_CaseController : Controller
    {
        private readonly ApplicationDbContext _context;

        public Death_CaseController(ApplicationDbContext context)
        {
            _context = context;
        }


        // GET: Death_Case/Create
        [Authorize(Roles ="Resception")]
        public IActionResult Create(int id , int EmpId)
        {
            var Resception =  _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut");
            var patient = _context.Patients.Find(id);
            Death_Case d = new Death_Case
            {
                Dead_Patient = patient,
                Death_Date = DateTime.Now,
                Death_Cause = "mmmmmmmmmmmmmm",
                
            };
            return View();
        }

        // POST: Death_Case/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Death_Case death_Case , int EmpId)
        {
            if (ModelState.IsValid)
            {
                _context.Add(death_Case);
                await _context.SaveChangesAsync();
                var message = new MulticastMessage()
                {
                    Notification = new Notification()
                    {
                        Title = "إنا لله وإنا إليه راجعون",
                        Body = " تم تسجيل وفاة المريض بتاريخ " + death_Case.Death_Date.ToShortDateString(),
                        //ImageUrl=
                    },

                };

                await FCMService.SendNotificationToUserAsync(death_Case.Dead_Patient.Patient_Id, UserType.pat, message);

                return RedirectToAction(nameof(Index));
            }
            return View(death_Case);
        }

    }
}
