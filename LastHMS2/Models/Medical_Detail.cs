using LastHMS2.Break_Tables;
using LastHMS2.Extra_Tables;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Models
{
    
    public class Medical_Detail
    {
        [NotMapped]
        public int Pa_Id { get; set; }
        [Key]
        public int Medical_Details_Id { get; set; }

        [StringLength(3)]
        [Display(Name = "Blood Type")]
        public string MD_Patient_Blood_Type { get; set; }
        [Display(Name = "Treatment Plans and Daily Supplements")]
        public string MD_Patient_Treatment_Plans_And_Daily_Supplements { get; set; }
     

        [Display(Name = "Special Needs")]
        public string MD_Patient_Special_Needs { get; set; }
     
        [ForeignKey("Patient_Id")] // cascade
        public virtual Patient Patient { get; set; }

        [ForeignKey("Medical_Detail_Id")]
        public virtual List<External_Records> External_Records { get; set; } = new List<External_Records>();
        [ForeignKey("Medical_Detail_Id")]
        public virtual List<Medical_Allergy> Medical_Allergies { get; set; } = new List<Medical_Allergy>();
        [ForeignKey("Medical_Detail_Id")]
        public virtual List<Medical_Disease> Medical_Diseases { get; set; } = new List<Medical_Disease>();   
        [ForeignKey("Medical_Detail_Id")]
        public virtual List<Ray> Medical_Rays { get; set; } = new List<Ray>();

         [ForeignKey("Medical_Detail_Id")]
         public virtual List<Medical_Test> Medical_Tests { get; set; } = new List<Medical_Test>();


    }
}
