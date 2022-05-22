using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LastHMS2.Data;
using LastHMS2.Models;
using FirebaseAdmin.Messaging;

namespace LastHMS2.Controllers
{
    public class RayController : Controller
    {
        private readonly ApplicationDbContext _context;

        public RayController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Ray
        public async Task<IActionResult> Index()
        {
            return View(await _context.Rays.ToListAsync());
        }

        // GET: Ray/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ray = await _context.Rays
                .FirstOrDefaultAsync(m => m.Ray_Id == id);
            if (ray == null)
            {
                return NotFound();
            }

            return View(ray);
        }

        // GET: Ray/Create
        public IActionResult Create()
        {
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Ray_Id,Ray_Date,Ray_Result,Ray_Type_Id,Medical_Detail_Id")] Ray ray)
        {
            if (ModelState.IsValid)
            {
                _context.Add(ray);
                await _context.SaveChangesAsync();
                #region send notification
                //==============================================================================================
                var r = await _context.Ray_Types.FirstOrDefaultAsync(r => r.Ray_Type_Id == ray.Ray_Type_Id);
                var p = _context.Medical_Details.Include(p => p.Patient).FirstOrDefault(p => p.Medical_Details_Id == ray.Medical_Detail_Id);
                var message = new MulticastMessage()
                {
                    Notification = new Notification()
                    {
                        Title = "صورة أشعة جديدة",
                        Body = "تم إضافة صورة " + r.Ray_Type_Name + " جديدة",
                        //ImageUrl=
                    },
                    Data = new Dictionary<string, string>()
                    {
                        { "route","/ShowRays" },
                    }

                };
                await FCMService.SendNotificationToUserAsync(p.Patient.Patient_Id, UserType.pat, message);
                //=========================================================================================
                #endregion
                return RedirectToAction(nameof(Index));
            }
            return View(ray);
        }
        // GET: Ray/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ray = await _context.Rays.FindAsync(id);
            if (ray == null)
            {
                return NotFound();
            }
            return View(ray);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id,Ray ray)
        {
            if (id != ray.Ray_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(ray);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!RayExists(ray.Ray_Id))
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
            return View(ray);
        }

        // GET: Ray/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ray = await _context.Rays.FindAsync(id);
            if (ray == null)
            {
                return NotFound();
            }            
            _context.Rays.Remove(ray);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        private bool RayExists(int id)
        {
            return _context.Rays.Any(e => e.Ray_Id == id);
        }
    }
}
