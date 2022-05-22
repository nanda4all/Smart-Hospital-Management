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
using Microsoft.AspNetCore.Authorization;
using Newtonsoft.Json;

namespace LastHMS2.Controllers
{
    public class RoomController : Controller
    {
        private readonly ApplicationDbContext _context;

        public RoomController(ApplicationDbContext context)
        {
            _context = context;
        }

        //***********************************************************
        //[Authorize(Roles ="Resception")]
        public IActionResult AvailableRooms(int? id,int EmpId ) // patient(id)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut");
            if (id == null) return NotFound();
            var patient = _context.Patients.Find(id);
            if (patient == null) return NotFound();
            var EmptyRooms = _context.Rooms.Where(r =>r.Ho_Id == patient.Ho_Id && r.Room_Empty == true).ToList();
            var ValidReservations = _context.Reservations.Where(res=>res.End_Date == DateTime.MinValue).ToList();
            var rooms = (from room in EmptyRooms
                         join res in ValidReservations
                         on room.Room_Id equals res.Room_Id into GroupedReservations
                         where room.Room_Beds_Count > ValidReservations.Where(res => res.Room_Id == room.Room_Id).Count()
                         from gr in GroupedReservations.DefaultIfEmpty()
                         select new
                         {
                             Room = room,
                             ReservationsCount = ValidReservations.Where(res => res.Room_Id == room.Room_Id).Count() < room.Room_Beds_Count ? ValidReservations.Where(res => res.Room_Id == room.Room_Id).Count() : -1
                         } into a group a by a.Room into b
                         select new
                         {
                             Room = b.Key,
                             ReservationsCount = ValidReservations.Where(res => res.Room_Id == b.Key.Room_Id).Count() < b.Key.Room_Beds_Count ? ValidReservations.Where(res => res.Room_Id == b.Key.Room_Id).Count() : -1
                         }).ToList();


            var rooms1 = (from r in rooms
                     where r.ReservationsCount != -1
                     select new AvailableRoom
                     {
                         Room = r.Room,
                         ReservationsCount = r.ReservationsCount,
                         EmptyBedCount = r.Room.Room_Beds_Count - r.ReservationsCount
                     }).ToList();
            ViewBag.PatientId = patient.Patient_Id;
            ViewBag.EmployeeId = EmpId;
            ViewBag.HoId = patient.Ho_Id;
            return View(rooms1);
        }
        public IActionResult BusyRooms(int id)
        {
            var rooms = _context.Rooms.Where(r => r.Ho_Id == id).ToList();
            var data = (from res in _context.Reservations.ToList()
                        join room in rooms
                        on res.Room_Id equals room.Room_Id
                        where res.End_Date == DateTime.MinValue
                        select new { res, room }
                        into a
                        join p in _context.Patients.ToList()
                        on a.res.Patient_Id equals p.Patient_Id
                        select new BusyRooms
                        {
                            RoomNumber = a.room.Room_Number,
                            StartDate = a.res.Start_Date,
                            PatientName = p.Patient_First_Name + " " + p.Patient_Last_Name
                        }).ToList();
            return View(data);
        }
        //[Authorize(Roles ="IT")]
        public async Task<IActionResult> DisplayRooms(int id, int HoId) // IT(id)
        {
            var IT = _context.Employees.Find(id);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            ViewBag.EmpId = id;
            ViewBag.HoId= HoId;
            return View(await _context.Rooms.Where(r => r.Active && r.Ho_Id == HoId).ToListAsync());
        }
        //***********************************************************


        // GET: Room/Create
        public IActionResult Create(int HoId , int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            Room r = new Room
            {
                Active = true,
                Ho_Id = HoId,
                Room_Empty = true
            };
            ViewBag.EmpId = EmpId;
            return View(r);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Room room , int EmpId)
        {
            if (ModelState.IsValid)
            {
                return RedirectToAction("AddRoom" , "Request" , new { EmpId , room = JsonConvert.SerializeObject(room) });
      
            }
            return View(room);
        }
        private bool RoomExists(int id)
        {
            return _context.Rooms.Any(e => e.Room_Id == id);
        }
    }
}
