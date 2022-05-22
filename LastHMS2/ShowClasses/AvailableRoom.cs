using LastHMS2.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.ShowClasses
{
    [Keyless]
    public class AvailableRoom
    {
        public Room Room { get; set; }
        public int EmptyBedCount { get; set; }
        public int ReservationsCount { get; set; }
    }
}
