using LastHMS2.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Extra_Tables
{
    public class City
    {
        [Key]
        public int City_Id { get; set; }
        [StringLength(100)]
        [Required]
        public string City_Name { get; set; }
        [ForeignKey("City_Id")]
        public virtual List<Area> Areas { get; set; } = new List<Area>();
        [ForeignKey("Doctor_Birth_Place")]
        public virtual List<Doctor> Doctors { get; set; } = new List<Doctor>();
        [ForeignKey("Patient_Birth_Place")]
        public virtual List<Patient> Patients { get; set; } = new List<Patient>();
        [ForeignKey("Employee_Birth_Place")]
        public virtual List<Employee> Employees { get; set; } = new List<Employee>();
    }
}
