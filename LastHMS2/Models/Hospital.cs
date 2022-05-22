
using LastHMS2.Class_Attriputes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    public class Hospital
    {
        [Display(Name = "Location")]
        [NotMapped]
        public string Hospital_Location { get; set; }
        [NotMapped]
        public int Ho_Mgr_Id { get; set; }
        [Key]
        public int Ho_Id { get; set; }
        [Required]
        [StringLength(50)]
        [Display(Name = "Hospital Name ")]
        public string Ho_Name { get; set; }
        [Required]
        [Display(Name = "Subscribtion Date")]
        public DateTime Ho_Subscribtion_Date { get; set; }
        [Display(Name = "Is Active")]
        public bool Active { get; set; } = true;
        [Required]
        public int Area_Id { get; set; } // foreignKey

        [ForeignKey("Mgr_Id")] // NoAction // unique // type<int?>
        public virtual Employee Manager { get; set; }

        [ForeignKey("Ho_Id")]
        public virtual List<Hospital_Phone_Numbers> Hospital_Phone_Numbers { get; set; } = new List<Hospital_Phone_Numbers>();

        [ForeignKey("Ho_Id")]
        public virtual List<Patient> Ho_Patients { get; set; } = new List<Patient>();
        [ForeignKey("Ho_Id")]
        public virtual List<Employee> Ho_Employees { get; set; } = new List<Employee>();
        [ForeignKey("Ho_Id")]
        public virtual List<Room> Hospital_Rooms { get; set; } = new List<Room>();
        [ForeignKey("Ho_Id")]
        public virtual List<Surgery_Room> Hospital_Surgery_Rooms { get; set; } = new List<Surgery_Room>();
        [ForeignKey("Ho_Id")]
        public virtual List<Department> Hospital_Departments { get; set; } = new List<Department>();

    }
}
