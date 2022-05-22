
using LastHMS2.Class_Attriputes;
using LastHMS2.Requests;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    public class Doctor
    {
        [NotMapped]
        [Display(Name = "Location")]
        public string Doctor_Location { get; set; }
        [NotMapped]
        [Display(Name = "Name in English ")]
        public string Doctor_EmailName { get; set; }
        [Key]  
        public int Doctor_Id { get; set; }
        [Required]
        [StringLength(30, MinimumLength = 2, ErrorMessage = "First Name Must Be Between 2 and 30 characters ..")]
        [Display(Name = "First Name")]
        public string Doctor_First_Name { get; set; }
        [Required]
        [StringLength(30, MinimumLength = 2, ErrorMessage = "First Name Must Be Between 2 and 30 characters ..")]
        [Display(Name = "Middle Name")]
        public string Doctor_Middle_Name { get; set; }
        [Required]
        [StringLength(30, MinimumLength = 2, ErrorMessage = "First Name Must Be Between 2 and 30 characters ..")]
        [Display(Name = "Last Name")]
        public string Doctor_Last_Name { get; set; }
        [Display(Name = "Full Name")]
        public string Doctor_Full_Name { get { return Doctor_First_Name + " " + Doctor_Middle_Name + " " + Doctor_Last_Name; } }
        [Required] 
        [StringLength(25)]
        [Display(Name = "National Number")]

        public string Doctor_National_Number { get; set; }// Unique   // Remeber that he is a doctor !!!!!!!!!
        [StringLength(6)]
        [Display(Name = "Gender")]
        public string Doctor_Gender { get; set; }
        [Required]
        [StringLength(100)]
        [Display(Name = "Email")]
        public string Doctor_Email { get; set; }
        [Required]
        [Display(Name = "Password")]
        [StringLength(25, MinimumLength = 8, ErrorMessage = "Must Be Between 8 and 25 Characters ")]
        public string Doctor_Password { get; set; }
        [Range(0, 25)]
        [Display(Name = "Family Members")]

        public int? Doctor_Family_Members { get; set; }
        [Display(Name = "Qualifications")]
        // max
        public string Doctor_Qualifications { get; set; }
        [StringLength(10)]
        [Display(Name = "Social Status")]
        public string Doctor_Social_Status { get; set; } // single selected
        [Display(Name = "Birth Date")]
        public DateTime Doctor_Birth_Date { get; set; }
        [Display(Name = "Age")]
        public int? Doctor_Age { get { return DateTime.Now.Year - Doctor_Birth_Date.Year; } }
       
        [Required]
        [Display(Name = "Hire Date")]
        public DateTime Doctor_Hire_Date { get; set; } = DateTime.Now;
        [Display(Name = "Is Active")]
        public bool Active { get; set; } = true;
        public int? Doctor_Birth_Place { get; set; } // Foreign Key mn al City
        public int? Area_Id { get; set; } // ForeignKey;
        public int? Department_Id { get; set; } // Foreign Key // set null 

        [ForeignKey("Doctor_Id")]
        public virtual List<Doctor_Phone_Numbers> Doctor_Phone_Numbers { get; set; } = new List<Doctor_Phone_Numbers>();
        [ForeignKey("Doctor_Id")]
        public virtual List<Preview> Doctor_Previews { get; set; } = new List<Preview>();
        [ForeignKey("Doctor_Id")]
        public virtual List<Surgery> Doctor_Surgeries { get; set; } = new List<Surgery>();
        [ForeignKey("Doctor_Id")]
        public virtual List<Work_Days> Work_Days { get; set; } = new List<Work_Days>();
        [ForeignKey("Doctor_Id")]
        public virtual List<Request> Doctor_Requests { get; set; } = new List<Request>();





    }
}
