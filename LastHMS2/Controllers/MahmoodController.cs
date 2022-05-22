using LastHMS2.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Controllers
{
    public class MahmoodController : Controller
    {
        private readonly ApplicationDbContext _context;

        public MahmoodController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: MahmoodController
        public ActionResult Index()
        {
            return View();
        }

        // GET: MahmoodController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: MahmoodController/Create
        public ActionResult Create()
        {
            ViewBag.Diseases_Type = _context.Diseases_Types.ToList();
            return View();
        }

        // POST: MahmoodController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(int[] a)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: MahmoodController/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: MahmoodController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: MahmoodController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: MahmoodController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}
