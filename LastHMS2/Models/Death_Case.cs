﻿using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    public class Death_Case
    {
        [Key]
        public int Death_Case_Number { get; set; }
        [Required]
        public string Death_Cause { get; set; }
        [Required]
        [Display(Name = "Death Date")]
        public DateTime Death_Date { get; set; }
        [Required]
        [ForeignKey("Patient_Id")] // unique // cascade
        public virtual Patient Dead_Patient { get; set; }
        [NotMapped]
        public IFormFile image { set; get; }
    }
}
