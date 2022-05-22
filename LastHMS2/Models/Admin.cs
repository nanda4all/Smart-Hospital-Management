using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    [Keyless]
    public class Admin
    {
        [Required]
        [StringLength(30, MinimumLength = 2)]
        [Display(Name = "Email")]
        public string Admin_Email { get; set; }
        [Required]
        [Display(Name = "Password")]
        [StringLength(25, MinimumLength = 8, ErrorMessage = "Must Be Between 8 and 25 Characters ")]
        public string Admin_Password { get; set; }
    }
}
