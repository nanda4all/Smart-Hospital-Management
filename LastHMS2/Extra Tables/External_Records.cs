using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Extra_Tables
{
    public class External_Records
    {
        [NotMapped]
        public IFormFile File { get; set; }
        [Key]
        public int External_Records_Id { get; set; }
        [Required]
        [StringLength(250)]
        public string Details { get; set; }
        public int Medical_Detail_Id { get; set; } // foreign Key
    }
}
