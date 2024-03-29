﻿using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    public class Medical_Test
    {
        [NotMapped]
        public IFormFile File { get; set; }
        [Key]
        public int Test_Id { get; set; }
        [Display(Name = "Test Date")]
        [Required]
        public DateTime Test_Date { get; set; }
        [Required]
        [Display(Name = "Test Result")]
        [StringLength(250)]
        public string Test_Result { get; set; } // needs to be an img // already did
        public int Test_Type_Id { get; set; } // Foreign Key
        [Required]
        public int Medical_Detail_Id { get; set; } // Foreign Key // cascade cascade
    }
}
