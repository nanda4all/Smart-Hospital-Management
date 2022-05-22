using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    public class Bill
    {
        [Key]
        public int Bill_Id { get; set; }
        [Display(Name = "Examination")]
        [Column(TypeName = "money")]
        public decimal? Bill_Examination { get; set; } // Currency

        [Column(TypeName = "money")]
        [Display(Name = "Surgeries")]
        public decimal? Bill_Surgeries { get; set; }

        [Column(TypeName = "money")]
        [Display(Name = "Rays")]
        public decimal? Bill_Rays { get; set; }

        [Column(TypeName = "money")]
        [Display(Name = "Medical Test")]
        public decimal? Bill_Medical_Test { get; set; }

        [Column(TypeName = "money")]
        [Display(Name = "Room Service")]
        public decimal? Bill_Room_Service { get; set; }

        [Column(TypeName = "money")]
        [Display(Name = "Medication")]
        public decimal? Bill_Medication { get; set; }
        
        [Display(Name = "Bill Date")]
        public DateTime Bill_Date{ get; set; }
        [Display(Name = "Is Paid")]
        public bool Paid { get; set; } // bayed
        [Required]
        public int Patient_Id { get; set; } // Foreign Key //cascade
    }
}
