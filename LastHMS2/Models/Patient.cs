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
    public class Patient
    {
        [NotMapped]
        [Display(Name = "Location")]
        public string Patient_Location { get; set; }
        [NotMapped]
        [Display(Name = "Name in English ")]
        public string Patient_EmailName { get; set; }
        [Key]
        public int Patient_Id { get; set; }
        [Required]
        [StringLength(30, MinimumLength = 2, ErrorMessage = "First Name Must Be Between 2 and 30 characters ..")]
        [Display(Name = "First Name")]
        public string Patient_First_Name { get; set; }
        [Required]
        [StringLength(30, MinimumLength = 2, ErrorMessage = "Middle Name Must Be Between 2 and 30 characters ..")]
        [Display(Name = "Middle Name")]
        public string Patient_Middle_Name { get; set; }
        [Required]
        [StringLength(30, MinimumLength = 2, ErrorMessage = "Last Name Must Be Between 2 and 30 characters ..")]
        [Display(Name = "Last Name")]
        public string Patient_Last_Name { get; set; }
        [Display(Name = "Full Name")]
        public string Patient_Full_Name { get { return Patient_First_Name + " " + Patient_Middle_Name + " " + Patient_Last_Name; } }
        [Required]
        [StringLength(100)]
        [Display(Name = "Email")]
        public string Patient_Email { get; set; }
        [Required]
        [Display(Name = "Password")]
        [StringLength(25, MinimumLength = 8, ErrorMessage = "Must Be Between 8 and 25 Characters ")]
        public string Patient_Password { get; set; }
        [Required]
        [Display(Name ="(X,Y)")]
        [StringLength(61)]
        public string Patient_X_Y { get; set; }
        [Display(Name = "National Number")]
        [StringLength(25)]
        [Required]
        public string Patient_National_Number { get; set; }
        [StringLength(6)]
        [Display(Name = "Gender")]
        public string Patient_Gender { get; set; } // Male or Female
        [StringLength(10)]
        [Display(Name = "Social Status")]
        public string Patient_Social_Status { get; set; }  // Married or Single
        [Display(Name = "Birth Date")]
        [Required]
        public DateTime Patient_Birth_Date { get; set; }
      
        [Display(Name = "Age")]
        public int? Patient_Age { get { return DateTime.Now.Year - Patient_Birth_Date.Year; } }
        [Display(Name = "Is Active")]
        public bool Active { get; set; } = true;
        public bool Canceled { get; set; }
        public int? PreviewCount { get; set; }
        public int Area_Id { get; set; } // ForeignKey
        public int? Patient_Birth_Place { get; set; } // foreign key mn al city
        [Required]
        public int Ho_Id { get; set; } // Foreign key // cascade

        [ForeignKey("Patient_Id")]
        public virtual List<Patient_Phone_Numbers> Patient_Phone_Numbers { get; set; } = new List<Patient_Phone_Numbers>();

        [ForeignKey("Patient_Id")]
        public virtual List<Preview> Patient_Previews { get; set; } = new List<Preview>();
        [ForeignKey("Patient_Id")]
        public virtual List<Reservation> Patient_Reservations { get; set; } = new List<Reservation>();
        [ForeignKey("Patient_Id")]
        public virtual List<Bill> Patient_Bills { get; set; } = new List<Bill>();
        [ForeignKey("Patient_Id")]
        public virtual List<Surgery> Patient_Surgeries { get; set; } = new List<Surgery>();
        [ForeignKey("Patient_Id")]
        public virtual List<Request> Patient_Requests { get; set; } = new List<Request>();
    }
}
