using LastHMS2.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Extra_Tables
{
    public class Test_Type
    {
        [Key]
        public int Test_Type_Id { get; set; }
        [Display(Name = "Test Type")]
        [StringLength(200)]
        [Required]
        public string Test_Type_Name { get; set; }
        [ForeignKey("Test_Type_Id")]
        public virtual List<Medical_Test> Medical_Tests { get; set; } = new List<Medical_Test>();
    }
}
