using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.ShowClasses
{
    [Keyless]
    public class BusyRooms
    {
        public string RoomNumber { get; set; }
        public DateTime StartDate { get; set; }
        public string PatientName { get; set; }
    }
}
