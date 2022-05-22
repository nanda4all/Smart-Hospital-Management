using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.ShowClasses
{
    public class HoDoctors
    {
        public int DoctorId { get; set; }
        public string DoctorFullName { get; set; }
        public string Specialization { get; set; }
        public List<string> PhoneNumbers { get; set; }
    }
}
