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
    public class ReservationController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ReservationController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Reservation
        public async Task<IActionResult> Index()
        {
            return View(await _context.Reservations.ToListAsync());
        }

        // GET: Reservation/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var reservation = await _context.Reservations
                .FirstOrDefaultAsync(m => m.Reservation_Id == id);
            if (reservation == null)
            {
                return NotFound();
            }

            return View(reservation);
        }

        // GET: Reservation/Create
        public async Task<IActionResult> Create(int RoomId,int PatientId,int ReservationBedNumber , int EmptyBedCount,int EmpId)
        {
            var Room = _context.Rooms.Find(RoomId);
            Reservation res = new Reservation()
            {
                Patient_Id = PatientId,
                Room_Id = RoomId,
                End_Date = DateTime.MinValue,
                Start_Date = DateTime.Now
            };
            if (ReservationBedNumber == EmptyBedCount)
                Room.Room_Empty = false;

            _context.Update(Room);
            await _context.AddAsync(res);
            await _context.SaveChangesAsync();
            #region send notification
            //==============================================================================================
            var message = new MulticastMessage()
            {
                Notification = new Notification()
                {
                    Title = "غرفتك جاهزة",
                    Body = "تم حجز الغرفة "+Room.Room_Number+" في الطابق "+Room.Room_Floor,
                    //ImageUrl=
                },

            };
            await FCMService.SendNotificationToUserAsync(PatientId, UserType.pat, message);
            //=========================================================================================
            #endregion

            TempData["Message"] = "تم الحجز بنجاح";
            return RedirectToAction("Resception" , "Employee" , new { id = EmpId });
        }
        // GET: Reservation/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var reservation = await _context.Reservations.FindAsync(id);
            if (reservation == null)
            {
                return NotFound();
            }
            return View(reservation);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id,Reservation reservation)
        {
            if (id != reservation.Reservation_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(reservation);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ReservationExists(reservation.Reservation_Id))
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
            return View(reservation);
        }

        // GET: Reservation/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }
            var reservation = await _context.Reservations.FindAsync(id);
            if (reservation == null)
            {
                return NotFound();
            }            
            _context.Reservations.Remove(reservation);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        private bool ReservationExists(int id)
        {
            return _context.Reservations.Any(e => e.Reservation_Id == id);
        }
    }
}
