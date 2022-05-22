using LastHMS2.Data;
using LastHMS2.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Timing_Operations
{
    public static class Operations
    {
        private static DbContextOptions<ApplicationDbContext> opt = new DbContextOptionsBuilder<ApplicationDbContext>()
               .UseSqlServer("Server=DESKTOP-QQQJ0LR\\SQLEXPRESS;Database=LastHMS2;trusted_connection=yes;").Options;

        private  static readonly ApplicationDbContext context = new ApplicationDbContext(opt);
        public static async void EmptySurgeryRooms()
        {
            int munite = (DateTime.Now.Hour * 60) + DateTime.Now.Minute;
            var surgeries = await context.Surgeries.Where(s => s.Surgery_Date.Day == DateTime.Now.Day).ToListAsync();
            foreach (var item in surgeries)
            {
                int x = (item.Surgery_Date.Hour + item.Surgery_Time.Hours) *60+ item.Surgery_Date.Minute+ item.Surgery_Time.Minutes + 30;
                if (x==munite)
                {
                    context.Surgery_Rooms.Find(item.Surgery_Room_Id).Surgery_Room_Ready = true;
                    context.SaveChanges();
                }
            }
           
        }

        public async static Task AlterPreviews()
        {
            var patients = context.Patients.ToList();
            foreach (var item in patients)
            {
                item.Canceled = false;
                item.PreviewCount = 0;
            }
            context.UpdateRange(patients);
            await context.SaveChangesAsync();
        }

        public async static Task DeleteAcceptedRequests()
        {
            var requests = context.Requests.Where(r => r.Accept == true);
            context.RemoveRange(requests);
            await context.SaveChangesAsync();
        }
    }
}
//(item.Surgery_Date.Hour+item.Surgery_Time.Hours)*60 +30 == munite