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
using LastHMS2.Class_Attriputes;

namespace LastHMS2.Controllers
{
    public class HospitalController : Controller
    {
        private readonly ApplicationDbContext _context;

        public HospitalController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Hospital
        public async Task<IActionResult> Index()
        {
            return View(await _context.Hospitals.ToListAsync());
        }

        // GET: Hospital/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var hospital = await _context.Hospitals
                .FirstOrDefaultAsync(m => m.Ho_Id == id);
            if (hospital == null)
            {
                return NotFound();
            }

            return View(hospital);
        }

        // GET: Hospital/Create
        public IActionResult Create()
        {
            Hospital h = new Hospital
            {
                Active = true,
                Ho_Subscribtion_Date = DateTime.Now,
            };
            ViewBag.Cities = _context.Cities.Select(c => new SelectListItem { Value = c.City_Id.ToString(), Text = c.City_Name }).ToList();
            ViewBag.Areas = new List<SelectListItem>();
            return View(h);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        //[Authorize(Roles = "Admin")]
        public async Task<IActionResult> Create(Hospital hospital , string[] pn)
        {
            if (ModelState.IsValid)
            {
                _context.Add(hospital);
                await _context.SaveChangesAsync();

                List<Hospital_Phone_Numbers> pns = new List<Hospital_Phone_Numbers>();
                for (int i = 0; i < pn.Length; i++)
                {
                    if (pn[i] is not null)
                    {
                        pns.Add(new Hospital_Phone_Numbers
                        {
                            Ho_Id = hospital.Ho_Id,
                            Hospital_Phone_Number = pn[i]
                        });
                    }
                }
                await _context.AddRangeAsync(pns);
                await _context.SaveChangesAsync();
                return RedirectToAction("CreateManager","Employee",new { id = hospital.Ho_Id });
            }
            return View(hospital);
        }

        // GET: Hospital/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var hospital = await _context.Hospitals.FindAsync(id);
            if (hospital == null)
            {
                return NotFound();
            }
            return View(hospital);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id,Hospital hospital)
        {
            if (id != hospital.Ho_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(hospital);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!HospitalExists(hospital.Ho_Id))
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
            return View(hospital);
        }

        // GET: Hospital/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var hospital = await _context.Hospitals
                .FirstOrDefaultAsync(m => m.Ho_Id == id);
            if (hospital == null)
            {
                return NotFound();
            }
            hospital.Active = false;
            _context.Update(hospital);
            await _context.SaveChangesAsync();
            return RedirectToAction("Master", "Admin");
        
        }

        private bool HospitalExists(int id)
        {
            return _context.Hospitals.Any(e => e.Ho_Id == id);
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
