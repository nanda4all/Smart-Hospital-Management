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
using FirebaseAdmin.Messaging;
using LastHMS2.Enums;

namespace LastHMS2.Controllers
{
    public class Work_DaysController : Controller
    {
        private readonly ApplicationDbContext _context;

        public Work_DaysController(ApplicationDbContext context)
        {
            _context = context;
        }
        // GET: Work_Days
        public async Task<IActionResult> GetWorkDays(int id,int HoId,int DeptMgrId =0)
        {
            ViewBag.HoId = HoId;
            int x = id;
            Doctor doctor;
            if (DeptMgrId !=0)
            {
                doctor = _context.Doctors.Find(DeptMgrId);
                var dept = _context.Departments.Where(d => d.Department_Id == doctor.Department_Id).Include(d => d.Dept_Manager).ToArray()[0];
                if (!doctor.Active && doctor.Doctor_Id == dept.Dept_Manager.Doctor_Id)
                    return RedirectToAction("LogOut", "Doctor");
                x = DeptMgrId;
            }
             doctor = _context.Doctors.Find(id);
            if (!doctor.Active)
                return RedirectToAction("LogOut", "Doctor");
            ViewBag.DocId = x;
            ViewBag.DoctorName = _context.Doctors.Find(id).Doctor_Full_Name;
            return View(await _context.Work_Days.Where(w=>w.Doctor_Id == id).ToListAsync());
        }   
       // [Authorize(Roles = "Resception")]
        public async Task<IActionResult> ShowDoctorWorkDays(int id,int EmpId,int HoId)
        {
            var Resception = _context.Employees.Find(EmpId);
            if (!Resception.Active)
                return RedirectToAction("LogOut", "Employee");
            ViewBag.HoId = HoId;
            ViewBag.EmpId = EmpId;
            ViewBag.DoctorName = _context.Doctors.Find(id).Doctor_Full_Name;
            return View(await _context.Work_Days.Where(w=>w.Doctor_Id == id).ToListAsync());
        }

        // GET: Work_Days/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var work_Days = await _context.Work_Days
                .FirstOrDefaultAsync(m => m.Doctor_Id == id);
            if (work_Days == null)
            {
                return NotFound();
            }

            return View(work_Days);
        }

        // GET: Work_Days/Create
        public IActionResult Create(int id)
        {
            ViewBag.DoctorId = id;
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(int[] Day,TimeSpan[] sdate, TimeSpan[] edate,int DoctorId)
        {
            bool valid = true;
            string ErrorMessage = "s";
            
            for (int i = 0; i < Day.Length-1; i++)
            {
                for (int j = i+1; j < Day.Length; j++)
                {
                    if (Day[i] == Day[j]) { valid = false; ErrorMessage = "you Cant repeat the day !!"; } 
                }
            }
            if (valid)
            {
                var DoctorWorkDays = _context.Work_Days.Where(w => w.Doctor_Id == DoctorId).ToArray();
                for (int i = 0; i < Day.Length; i++)
                {
                    for (int j = 0; j < DoctorWorkDays.Length; j++)
                    {
                        if (Day[i] == (int)DoctorWorkDays[j].Day)
                        { valid = false; ErrorMessage = "This Day already exists in the data base !!"; }
                    }
                }
            }
            if (valid)
            {
                Work_Days[] wd = new Work_Days[Day.Length];
                for (int i = 0; i < wd.Length; i++)
                {
                    wd[i] = new Work_Days()
                    {
                        Day = (Enums.WeekDays)Day[i],
                        Start_Hour = sdate[i],
                        End_Hour = edate[i],
                        Doctor_Id = DoctorId
                    };
                }
                await _context.AddRangeAsync(wd);
                await _context.SaveChangesAsync();
                #region send notification
                //==============================================================================================
                var message = new MulticastMessage()
                {
                    Notification = new Notification()
                    {
                        Title = "يمكنك الآن تفقد جدول دوامك",
                        Body = "تم إضافة جدول الدوام",
                        //ImageUrl=
                    },

                };
                await FCMService.SendNotificationToUserAsync(DoctorId, UserType.doc, message);
                //=========================================================================================
                #endregion

                return RedirectToAction(nameof(Index));
            }
            TempData["ErrorMessage"] = ErrorMessage;
            return View();
        }

        // GET: Work_Days/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var work_Days = await _context.Work_Days.FindAsync(id, WeekDays.الأحد);
            if (work_Days == null)
            {
                return NotFound();
            }
            return View(work_Days);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id,Work_Days work_Days)
        {
            if (id != work_Days.Doctor_Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(work_Days);
                    await _context.SaveChangesAsync();
                    #region send notification
                    //==============================================================================================
                    var message = new MulticastMessage()
                    {
                        Notification = new Notification()
                        {
                            Title = "تفقد جدول دوامك",
                            Body = "تم تعديل جدول الدوام",
                            //ImageUrl=
                        },

                    };
                    await FCMService.SendNotificationToUserAsync(id, UserType.doc, message);
                    //=========================================================================================
                    #endregion

                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!Work_DaysExists(work_Days.Doctor_Id))
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
            return View(work_Days);
        }

        // GET: Work_Days/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var work_Days = await _context.Work_Days.FindAsync(id);
            if (work_Days == null)
            {
                return NotFound();
            }
            
            _context.Work_Days.Remove(work_Days);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        private bool Work_DaysExists(int id)
        {
            return _context.Work_Days.Any(e => e.Doctor_Id == id);
        }
    }
}
