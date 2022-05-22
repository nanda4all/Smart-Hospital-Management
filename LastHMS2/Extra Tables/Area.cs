using LastHMS2.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Extra_Tables
{
    public class Area
    {
        [Key]
        public int Area_Id { get; set; }
        [Required]
        [StringLength(50)]
        [Display(Name = "Area")]
        public string Area_Name { get; set; }
        public int City_Id { get; set; } // foreign Key
        [ForeignKey("Area_Id")]
        public virtual List<Hospital> Hospitals { get; set; } = new List<Hospital>();
        [ForeignKey("Area_Id")]
        public virtual List<Doctor> Doctors { get; set; } = new List<Doctor>();
        [ForeignKey("Area_Id")]
        public virtual List<Patient> Patients { get; set; } = new List<Patient>();
        [ForeignKey("Area_Id")]
        public virtual List<Employee> Employees { get; set; } = new List<Employee>();
    }
}
