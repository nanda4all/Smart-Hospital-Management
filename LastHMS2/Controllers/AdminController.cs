using LastHMS2.Data;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace LastHMS2.Controllers
{
    public class AdminController : Controller
    {
        private readonly ApplicationDbContext _context;

        public AdminController(ApplicationDbContext context)
        {
            _context = context;
        }
        //***********************************************************
        // in view onclick(إضافة مشفى) ==> /Hospital/Create
        public IActionResult Master()  // mahmood
        {
            return View(_context.Hospitals.Where(h=>h.Active).ToList());
        }
        public IActionResult LogIn()
        {
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LogIn(IFormCollection fr,string ReturnUrl)
        {
            var admin = _context.Admins.FirstOrDefault(d => d.Admin_Email == fr["email"].ToString() && d.Admin_Password == fr["password"].ToString());
            if (admin is not null)
            {
                //************* cookie Auth
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Name , admin.Admin_Email),
                    new Claim(ClaimTypes.Email,admin.Admin_Password),
                    new Claim(ClaimTypes.Role,"Admin")
                };
                var claimsIdentity = new ClaimsIdentity(claims, "LogIn");
                await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(claimsIdentity));
                if (ReturnUrl == null)
                {
                    return RedirectToAction("Master");
                }
                return RedirectToAction(ReturnUrl);
            }
            //*************
            return View();
        }
        public async Task<IActionResult> LogOut()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Index", "Home");
        }
        //***********************************************************       
    }
}
