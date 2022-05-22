using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LastHMS2.Data;
using LastHMS2.Models;
using LastHMS2.ShowClasses;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Authorization;

namespace LastHMS2.Controllers
{
    public class DepartmentController : Controller
    {
        private readonly ApplicationDbContext _context;

        public DepartmentController(ApplicationDbContext context)
        {
            _context = context;
        }
        //***********************************************************
        //[Authorize(Roles = "IT")]
        public IActionResult HoDepartments(int? id , int EmpId) //IT.Ho_Id
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            if (id == null) return NotFound();
          //  var Departments = _context.Departments.Where(d => d.Ho_Id == id && d.Active).ToList();
            var departments = (from d in _context.Departments
                               join s in _context.Specializations
                               on d.Department_Name equals s.Specialization_Id
                               where d.Ho_Id == id && d.Active
                               select new Specialization_Dept
                               {
                                   Dept_Id = d.Department_Id,
                                   Spec_Name = s.Specialization_Name
                               }).ToList();
                              
            if (departments.Count == 0) return Ok("No Departments in this Hospital yet");
            ViewBag.HoId = id;
            ViewBag.EmpId = EmpId;
            return View(departments);
        }
        //***********************************************************
        // GET: Department/Create
        //[Authorize(Roles ="IT")]
        public IActionResult Create(int id , int EmpId)
        {
            var IT = _context.Employees.Find(EmpId);
            if (!IT.Active)
                return RedirectToAction("LogOut", "Employee");
            Department d = new Department
            {
                Ho_Id = id,
                Active = true
            };
            ViewBag.EmpId = EmpId;
            ViewBag.HoId = id;
            var specs= (from spec in _context.Specializations
                                       join dept in _context.Departments
                                       on spec.Specialization_Id equals dept.Department_Name
                                       where dept.Ho_Id == id
                                       select spec).ToList();
            var AllSpecs = _context.Specializations.ToList();

            foreach (var item in specs)
            {
                if (AllSpecs.Contains(item))
                {
                    AllSpecs.Remove(item);
                }
            }
            ViewBag.Specializations = AllSpecs;
            return View(d);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Department department , int EmpId)
        {
            if (ModelState.IsValid)
            {
                return RedirectToAction("AddDepartment" , "Request" , new { EmpId , department = JsonConvert.SerializeObject(department)});
                //_context.Add(department);
                //await _context.SaveChangesAsync();
                //return RedirectToAction("Master" , "Employee" , new { id = EmpId});
            }
    
            return View(department);
        }
        private bool DepartmentExists(int id)
        {
            return _context.Departments.Any(e => e.Department_Id == id);
        }
    }
}
