using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LastHMS2.Data;
using LastHMS2.Models;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Authorization;

namespace LastHMS2.Controllers
{
    public class Surgery_RoomController : Controller
    {
        private readonly ApplicationDbContext _context;

        public Surgery_RoomController(ApplicationDbContext context)
        {
            _context = context;
        }
        //***********************************************************
        public IActionResult DoctorIndex(int? id) // display doctor's Surgeries by passing the doctor's Id .... 
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
            var surgery_rooms = (from sr in _context.Surgery_Rooms.ToList()
                                 join s in doctor.Doctor_Surgeries
                                 on sr.Surgery_Room_Id equals s.Doctor_Id
                                 select sr).ToList(); // لازم المحجوزة
            return View(surgery_rooms);
        }

        //[Authorize(Roles ="IT")]
        public async Task<IActionResult> DisplaySurgeryRooms(int id, int HoId) // IT(id)
        {
            var IT = _context.Employees.Find(id);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            ViewBag.EmpId = id;
            ViewBag.HoId = HoId;
            return View(await _context.Surgery_Rooms.Where(sr => sr.Active && sr.Ho_Id == HoId).ToListAsync());
        }
        //***********************************************************



        // GET: Surgery_Room/Create
        public IActionResult Create(int id , int HoId) // IT(id)
        {
            var IT = _context.Employees.Find(id);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            Surgery_Room surgery_Room = new Surgery_Room
            {
                Active = true,
                Ho_Id = HoId,
                Surgery_Room_Ready = true,
            };
            ViewBag.EmpId = id;
            return View(surgery_Room);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Surgery_Room surgery_Room , int EmpId)
        {
            if (ModelState.IsValid)
            {
                return RedirectToAction("AddSurgeryRoom", "Request", new { EmpId, surgeryRoom = JsonConvert.SerializeObject(surgery_Room) });
                _context.Add(surgery_Room);
                await _context.SaveChangesAsync();
                return RedirectToAction("Master", "Employee", new { id = EmpId });
            }
            return View(surgery_Room);
        }

      
        private bool Surgery_RoomExists(int id)
        {
            return _context.Surgery_Rooms.Any(e => e.Surgery_Room_Id == id);
        }
    }
}
