using LastHMS2.Break_Tables;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Extra_Tables
{
    public class Disease
    {
        [Key]
        public int Disease_Id { get; set; }
        [Required]
        [StringLength(200)]
        public string Disease_Name{ get; set; }
        public int Disease_Type_Id { get; set; } // Foreign Key
        [ForeignKey("Disease_Id")]
        public virtual List<Medical_Disease> Medical_Diseases { get; set; } = new List<Medical_Disease>();
    }
}
