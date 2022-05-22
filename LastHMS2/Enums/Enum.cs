using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LastHMS2.Enums
{
    public enum WeekDays
    {
        الأحد,
        الاثنين,
        الثلاثاء,
        الأربعاء,
        الخميس,
        الجمعة,
        السبت,
    }
}


////***********************************************************
//public IActionResult WorkDays(int id)
//{
//    var doctorsWorkDays = _context.Work_Days.Where(wd => wd.Doctor_Id == id).ToList();
//    return View(doctorsWorkDays);
//}
////***********************************************************
