using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    public class Preview
    {
        [Key]
        public int Preview_Id { get; set; }
        [Required]
        [Display(Name = "Preview Date")]
        public DateTime Preview_Date { get; set; }

        [Display(Name = "Is Taking Care of")]
        
        public bool Caring { get; set; }
        public string ExaminationRecord { get; set; }

        [Required]
        public int Patient_Id { get; set; } // Foreign Key // cascade
        [Required]
        public int? Doctor_Id { get; set; } // Foreign Key // Set null 


    }
}
