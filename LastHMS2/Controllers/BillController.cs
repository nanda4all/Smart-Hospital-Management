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
using FirebaseAdmin.Messaging;

namespace LastHMS2.Controllers
{
    public class BillController : Controller
    {
        private readonly ApplicationDbContext _context;

        public BillController(ApplicationDbContext context)
        {
            _context = context;
        }
        //***********************************************************
        // Huda
        public async Task<IActionResult> ShowBillForPatient(int? id) //shows the bill for the patient the parameter passes the patient's id
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
            var bills = await _context.Bills.Where(b=>b.Patient_Id == patient.Patient_Id).ToListAsync();
            ViewBag.PatientId = id;
            return View(bills);
        }
        public async Task<IActionResult> ShowBillForResception(int? id,int EmpId) //shows the bill for the Resception the parameter passes the hospital's id
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut","Employee");
            var patient = await _context.Patients.FindAsync(id);
            if (patient is null)
                return NotFound();
            var bills = await _context.Bills.Where(b => b.Patient_Id == id && b.Paid == false)
                .Select(s=>new ShowBills
                {
                    Bill = s,
                    FullName = patient.Patient_Full_Name
                }).ToListAsync();
            ViewBag.PatientId = id;
            ViewBag.EmpId = EmpId;
            ViewBag.HospitalId = patient.Ho_Id;
            return View(bills);
        }
        public async Task<IActionResult> PayBill(int id,int PatId,int EmpId)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut", "Employee");
            var bill = _context.Bills.Find(id);
            bill.Paid = true;
            _context.Update(bill);
            await _context.SaveChangesAsync();

            #region send notification
            var message = new MulticastMessage()
            {
                Notification = new Notification()
                {
                    Title = "تم دفع الفاتورة",
                    Body = "تم دفع الفاتورة بتاريخ " + bill.Bill_Date.ToShortDateString(),
                    //ImageUrl=
                },
                Data = new Dictionary<string, string>()
                    {
                        { "route","/ShowBillForPatient" },
                    }

            };

            await FCMService.SendNotificationToUserAsync(bill.Patient_Id, UserType.pat, message);

            #endregion

            return RedirectToAction("ShowBillForResception" , new { id = PatId,EmpId = EmpId });
        }


        //***********************************************************

        // GET: Bill/Create
        // ????
        public IActionResult Create(int id,int EmpId) // patient's Id
        {
            var patient = _context.Patients.FirstOrDefault(m => m.Patient_Id == id);
            Bill b = new Bill()
            {
                Patient_Id = id
            };
            ViewBag.HospitalId = patient.Ho_Id;
            ViewBag.EmpId = EmpId;

            return View(b);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Bill bill,int id , int EmpId)
        {
            
            if (ModelState.IsValid)
            {
                var HoId = _context.Employees.Find(EmpId).Ho_Id;
                _context.Add(bill);
                await _context.SaveChangesAsync();
                return RedirectToAction("HoPatientsForBill" , "Patient", new { id = HoId , EmpId });
            }
            return View(bill);
        }

        // GET: Bill/Edit/5
        // ????
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var bill = await _context.Bills.FindAsync(id);
            var patient = await _context.Patients.FirstOrDefaultAsync(b => b.Patient_Id == bill.Patient_Id);
            if (bill == null)
            {
                return NotFound();
            }
            ViewBag.Hospital_id = patient.Ho_Id;
            return View(bill);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Bill bill)
        {
            if (id != bill.Bill_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(bill);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!BillExists(bill.Bill_Id))
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
            return View(bill);
        }
        private bool BillExists(int id)
        {
            return _context.Bills.Any(e => e.Bill_Id == id);
        }
    }
}
