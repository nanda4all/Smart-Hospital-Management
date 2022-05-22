using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Requests
{
    public class Request
    {
        [Key]
        public int Request_Id { get; set; }
        [StringLength(200)]
        [Display(Name = "Type")]
        public string Request_Type { get; set; } // Select or hidden
        [Display(Name = "Description")]
        public string Request_Description { get; set; } // Select or hidden
        [Required]
        [Display(Name = "Date")]
        public DateTime Request_Date { get; set; }
        public bool Accept { get; set; }
        public int? Patient_Id { get; set; } //Foreign Key
        public int? Doctor_Id { get; set; } //Foreign Key
        public int? Employee_Id { get; set; } //Foreign Key
        public string Request_Data { get; set; }
    }
}
