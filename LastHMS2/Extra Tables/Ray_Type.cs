using LastHMS2.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Extra_Tables
{
    public class Ray_Type
    {
        [Key]
        public int Ray_Type_Id { get; set; }
        [Required]
        [Display(Name = "Ray Type")]
        [StringLength(200)]
        public string Ray_Type_Name { get; set; }
        [ForeignKey("Ray_Type_Id")]
        public virtual List<Ray> Rays { get; set; } = new List<Ray>();
    }
}
