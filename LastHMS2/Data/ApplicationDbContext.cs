
using LastHMS2.Break_Tables;
using LastHMS2.Class_Attriputes;
using LastHMS2.Extra_Tables;
using LastHMS2.Models;
using LastHMS2.Requests;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LastHMS2.ShowClasses;

namespace LastHMS2.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {

        }

        // Class Attriputes
        public DbSet<Patient_Phone_Numbers>  Patient_Phone_Numbers { get; set; }
        public DbSet<Hospital_Phone_Numbers>  Hospital_Phone_Numbers{ get; set; }
        public DbSet<Doctor_Phone_Numbers>  Doctor_Phone_Numbers{ get; set; }
        public DbSet<Employee_Phone_Numbers>  Employee_Phone_Numbers { get; set; }
        // Break Tables
        public DbSet<Medical_Allergy> Medical_Allergies { get; set; }
        public DbSet<Medical_Disease> Medical_Diseases { get; set; }

        //Extra Tables
        public DbSet<City> Cities { get; set; }
        public DbSet<Area> Areas { get; set; }
        public DbSet<Specialization> Specializations { get; set; }
        public DbSet<External_Records> External_Records { get; set; }
        public DbSet<Allergy> Allergies { get; set; }
        public DbSet<Disease> Diseases { get; set; }
        public DbSet<Test_Type> Test_Types { get; set; }
        public DbSet<Ray_Type> Ray_Types { get; set; }
        public DbSet<Disease_Type> Diseases_Types { get; set; }


      
        // Models
        public DbSet<Hospital> Hospitals { get; set; }
        public DbSet<Doctor> Doctors { get; set; }
        public DbSet<Employee> Employees { get; set; }
        public DbSet<Department> Departments { get; set; }
        public DbSet<Patient> Patients { get; set; }
        public DbSet<Work_Days> Work_Days { get; set; }
        public DbSet<Preview> Previews { get; set; }
        public DbSet<Bill> Bills { get; set; }
        public DbSet<Medical_Detail> Medical_Details { get; set; }
        public DbSet<Medical_Test> Medical_Tests { get; set; }
        public DbSet<Ray> Rays { get; set; }
        public DbSet<Room> Rooms { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<Surgery_Room> Surgery_Rooms { get; set; }
        public DbSet<Surgery> Surgeries { get; set; }
        public DbSet<Death_Case> Death_Cases { get; set; }
        public DbSet<Admin> Admins { get; set; }
        //Requests
        public DbSet<Request> Requests { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Patient_Phone_Numbers>().HasKey(o => new { o.Patient_Id, o.Patient_Phone_Number });
            modelBuilder.Entity<Doctor_Phone_Numbers>().HasKey(o => new { o.Doctor_Id, o.Doctor_Phone_Number });
            modelBuilder.Entity<Hospital_Phone_Numbers>().HasKey(o => new { o.Ho_Id, o.Hospital_Phone_Number });
            modelBuilder.Entity<Employee_Phone_Numbers>().HasKey(o => new { o.Employee_Id, o.Employee_Phone_Number });
            modelBuilder.Entity<Work_Days>().HasKey(w => new { w.Doctor_Id, w.Day });
            modelBuilder.Entity<Medical_Allergy>().HasKey(ma => new { ma.Allergy_Id, ma.Medical_Detail_Id });
            modelBuilder.Entity<Medical_Disease>().HasKey(md => new { md.Disease_Id, md.Medical_Detail_Id });
        }
    }
}
