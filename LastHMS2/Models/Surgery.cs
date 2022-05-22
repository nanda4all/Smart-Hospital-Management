using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    public class Surgery
    {
        [Key]
        public int Surgery_Number { get; set; }
        [Required]
        [Display(Name = "Name")]
        [StringLength(50)]
        public string Surgery_Name { get; set; }
        [Required]
        public DateTime Surgery_Date { get; set; }
        [Required]
        public TimeSpan Surgery_Time { get; set; } // in minutes  // No boundries to the time because the doctor is the one whose entering it 
        [Required]
        public int Surgery_Room_Id { get; set; } // Foreign Key // No Action
        [Required]
        public int? Doctor_Id { get; set; } // Foreign Key // he is the one that is entering it //set null
        [Required]
        public int Patient_Id { get; set; } // Foreign Key  // cascade
    }

}
