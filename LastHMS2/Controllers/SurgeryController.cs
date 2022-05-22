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
using Newtonsoft.Json;
using FirebaseAdmin.Messaging;

namespace LastHMS2.Controllers
{
    public class SurgeryController : Controller
    {
        private readonly ApplicationDbContext _context;

        public SurgeryController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Surgery

        // GET: Surgery/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var surgery = await _context.Surgeries
                .FirstOrDefaultAsync(m => m.Surgery_Number == id);
            if (surgery == null)
            {
                return NotFound();
            }

            return View(surgery);
        }

        #region Create Surgery For Doctor

        public async Task<IActionResult> DisplaySurgeries(int id, int HoId) //Doctor(id)
        {
            var patients = await _context.Patients.Where(p => p.Active && p.Ho_Id == HoId).ToListAsync();
            var data = (from s in _context.Surgeries.ToList()
                        join sr in _context.Surgery_Rooms.ToList()
                        on s.Surgery_Room_Id equals sr.Surgery_Room_Id
                        where s.Doctor_Id == id
                        && s.Surgery_Date >= DateTime.Now
                        select new DisplaySurguries
                        {
                            Id = s.Surgery_Number,
                            Floor = sr.Su_Room_Floor,
                            PatientName = patients.Find(p => p.Patient_Id == s.Patient_Id).Patient_Full_Name,
                            PhoneNumbers = _context.Patient_Phone_Numbers.Where(pn => pn.Patient_Id == s.Patient_Id).ToList(),
                            RoomNumber = sr.Su_Room_Number,
                            SurguryDate = s.Surgery_Date.ToString("dd/MM/yyyy hh:mm tt"),
                            SurgeryLength = s.Surgery_Time.ToString("c")
                        }).ToList();
            ViewBag.HoId = HoId;
            ViewBag.DocId = id;
            return View(data);
        }

        public async Task<IActionResult> DisplayEmptySurgeryRooms(int id, int HoId) //Docotor(id)
        {
            ViewBag.DocId = id;
            ViewBag.HoId = HoId;
            var EmptySurgeryRooms =await _context.Surgery_Rooms.Where(sr => sr.Surgery_Room_Ready == true && sr.Ho_Id == HoId ).ToListAsync();
            return View(EmptySurgeryRooms);
        }
        public async Task<IActionResult> DisplayPatients(int id,int DocId, int HoId) //Surgery_Room(id)
        {
            ViewBag.SrId = id;
            ViewBag.HoId = HoId;
            ViewBag.DocId = DocId;
            var patients =await _context.Patients.Where(p => p.Ho_Id == HoId && p.Active).ToListAsync();
            return View(patients);
        }
        public IActionResult Create(int DocId,int SrId,int PatId, int HoId , string ErrorMessage = "")
        {
            ViewBag.SrId = SrId;
            ViewBag.HoId = HoId;
            ViewBag.DocId = DocId;
            ViewBag.PatId = PatId;
            ViewBag.ErrorMessage = ErrorMessage;
            ViewBag.Times = new List<SelectListItem>();
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreatePost(int HoId , int PatId , int SrId , int DocId ,int hour,int minute, DateTime date , TimeSpan time , string name)
        {
            ViewBag.SrId = SrId;
            ViewBag.HoId = HoId;
            ViewBag.DocId = DocId;
            ViewBag.PatId = PatId;

            if (date <= DateTime.Now)
                return RedirectToAction("Create", new { DocId , SrId ,  PatId , HoId , ErrorMessage = "Past" });

            DateTime d = date.Date.Add(time);
            TimeSpan t = TimeSpan.FromHours(hour) + TimeSpan.FromMinutes(minute);
            Surgery s = new Surgery
            {
                Doctor_Id = DocId,
                Patient_Id = PatId,
                Surgery_Date = d,
                Surgery_Room_Id = SrId,
                Surgery_Time = t,
                Surgery_Name = name
            };
            return RedirectToAction("AddSurgery", "Request", new { id = DocId, HoId = HoId, surgery = JsonConvert.SerializeObject(s) });
            _context.Add(s);
            await _context.SaveChangesAsync();
            #region send notification
            //==============================================================================================
            var doc = await _context.Doctors.FindAsync(DocId);
            var message = new MulticastMessage()
            {
                Notification = new Notification()
                {
                    Title = "تم تحديد موعد عمليتك",
                    Body = "عند الطبيب "+doc.Doctor_Full_Name,
                    //ImageUrl=
                },

            };
            await FCMService.SendNotificationToUserAsync(PatId, UserType.pat, message);
            //=========================================================================================
            #endregion

            return RedirectToAction("Master", "Doctor", new { id = DocId, HoId = HoId });
        }
        #endregion
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var surgery = await _context.Surgeries.FindAsync(id);
            if (surgery == null)
            {
                return NotFound();
            }
            return View(surgery);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id,Surgery surgery)
        {
            if (id != surgery.Surgery_Number)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(surgery);
                    await _context.SaveChangesAsync();
                    #region send notification
                    //==============================================================================================
                    var message = new MulticastMessage()
                    {
                        Notification = new Notification()
                        {
                            Title = "تفقد مواعيد العمليات",
                            Body = "جرى تعدل على عمليتك",
                            //ImageUrl=
                        },

                    };
                    await FCMService.SendNotificationToUserAsync(surgery.Patient_Id, UserType.pat, message);
                    //=========================================================================================
                    #endregion

                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!SurgeryExists(surgery.Surgery_Number))
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
            return View(surgery);
        }

        // GET: Surgery/Delete/5
        public async Task<IActionResult> Delete(int? id,int DocId,int HoId)
        {
            if (id == null)
            {
                return NotFound();
            }
            var surgery = await _context.Surgeries.FindAsync(id);
            if (surgery == null)
            {
                return NotFound();
            }
            _context.Surgeries.Remove(surgery);
            await _context.SaveChangesAsync();
            #region send notification
            //==============================================================================================
            var doc = await _context.Doctors.FirstOrDefaultAsync(d => d.Doctor_Id == surgery.Doctor_Id);
            var message = new MulticastMessage()
            {
                Notification = new Notification()
                {
                    Title = "ألغيت العملية",
                    Body = "تم إلغاء العملية عند الطبيب " + doc.Doctor_Full_Name,
                    //ImageUrl=
                },
                Data = new Dictionary<string, string>()
                                {
                                    { "route","/SurgeryForDoctor" },
                                }

            };
            await FCMService.SendNotificationToUserAsync((int)surgery.Patient_Id, UserType.pat, message);
            //=========================================================================================
            #endregion

            return RedirectToAction("DisplaySurgeries" , new { id = DocId , HoId});
        }
        private bool SurgeryExists(int id)
        {
            return _context.Surgeries.Any(e => e.Surgery_Number == id);
        }
        public async Task<IActionResult> GetTimes(DateTime date , int Sr_Id , int hour , int minute)
        { // "2022-12-10"
            
            if (date != default)
            {
                var su = await _context.Surgeries.Where(s => s.Surgery_Room_Id == Sr_Id).ToListAsync();
                List<TimeSpan> DateSurgery = new List<TimeSpan>();
                List<TimeSpan> time = new List<TimeSpan>();
                List<TimeSpan> Invalid = new List<TimeSpan>();
                TimeSpan temp;
                TimeSpan halfHour = TimeSpan.FromMinutes(30);
                Dictionary<string, string> d = new Dictionary<string, string>();
                var surgeries = su.Count != 0 ? su.Where(s => s.Surgery_Date.ToString("yyyy-MM-dd") == date.ToString("yyyy-MM-dd")).ToList() : new List<Surgery>();
                if (surgeries.Count == 0)
                {
                    for (TimeSpan i = TimeSpan.Zero; i < TimeSpan.FromDays(1); i += halfHour)
                    {
                        temp = TimeSpan.FromHours(i.Hours + hour) + TimeSpan.FromMinutes(i.Minutes + minute);
                        if (temp < TimeSpan.FromDays(1)&& i.Hours>=DateTime.Now.Hour)
                            d.Add(i.ToString("c"), i.Hours >= 12 ? i.Hours == 12 ? "12" + ":" + (i.Minutes == 0 ? "00" : "30") + " PM" : i.Hours - 12 + ":" + (i.Minutes == 0 ? "00" : "30") + " PM" : i.Hours == 0 ? "12" + ":" + (i.Minutes == 0 ? "00" : "30") + " AM" : i.Hours + ":" + (i.Minutes == 0 ? "00" : "30") + "AM");
                    }
                }
                else
                {
                    foreach (var item in surgeries)
                    {
                        TimeSpan t = TimeSpan.FromHours(item.Surgery_Date.Hour) + TimeSpan.FromMinutes(item.Surgery_Date.Minute);
                        TimeSpan t1 = TimeSpan.FromHours(item.Surgery_Time.Hours + item.Surgery_Date.Hour) + TimeSpan.FromMinutes(item.Surgery_Time.Minutes + item.Surgery_Date.Minute);
                        DateSurgery.Add(t);
                        time.Add(t1);
                    }
                    bool check = false;
                    for (int i = 0; i < surgeries.Count; i++)
                    {
                        for (TimeSpan j = TimeSpan.Zero; j < TimeSpan.FromDays(1); j += halfHour)
                        {
                            temp = TimeSpan.FromHours(j.Hours + hour) + TimeSpan.FromMinutes(j.Minutes + minute);
                            if ((j >= DateSurgery[i] && j <= time[i]) || (temp >= DateSurgery[i] && temp <= time[i]) || j.Hours <= DateTime.Now.Hour || temp > TimeSpan.FromDays(1))
                            {
                                Invalid.Add(j);
                            }
                            for (TimeSpan ti = j; ti < temp; ti += halfHour)
                            {
                                if (ti == DateSurgery[i])
                                    check = true;
                            }
                            if (check)
                            {
                                Invalid.Add(j);
                            }
                            check = false;
                        }

                    }

                    for (TimeSpan i = TimeSpan.Zero; i < TimeSpan.FromDays(1); i += halfHour)
                    {
                        if (!Invalid.Contains(i))
                        {
                            d.Add(i.ToString("c"), i.Hours >= 12 ? i.Hours == 12 ? "12" + ":" + (i.Minutes == 0 ? "00" : "30") + " PM " : (i.Hours - 12) + ":" + (i.Minutes == 0 ? "00" : "30") + " PM " : i.Hours == 0 ? "12" + ":" + (i.Minutes == 0 ? "00" : "30") + " AM " : i.Hours + ":" + (i.Minutes == 0 ? "00" : "30") + " AM ");
                        }
                    }

                }
                List<SelectListItem> TimeSelect = null;
                string message = "";
                if (d.Count == 0)
                {
                    message = "ليس هناك وقت متاح ي هذا اليوم";
                    return Json(new { TimeSelect , message });
                }
                 TimeSelect = d
                    .Select(n => new SelectListItem { Value = n.Key.ToString(), Text = n.Value }).ToList();
                return Json(new { TimeSelect, message });
            }
            return null;
        }
    }
}
