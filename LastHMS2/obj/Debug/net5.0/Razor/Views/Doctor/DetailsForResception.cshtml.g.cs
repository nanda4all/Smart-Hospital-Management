#pragma checksum "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "78a65cbc87745e19fd88b86a02c2133f134d3b35"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Doctor_DetailsForResception), @"mvc.1.0.view", @"/Views/Doctor/DetailsForResception.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\_ViewImports.cshtml"
using LastHMS2;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\_ViewImports.cshtml"
using LastHMS2.Models;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"78a65cbc87745e19fd88b86a02c2133f134d3b35", @"/Views/Doctor/DetailsForResception.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"61ac8c6333f29274d2ec4a26eacc5975733ebead", @"/Views/_ViewImports.cshtml")]
    public class Views_Doctor_DetailsForResception : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<LastHMS2.Models.Doctor>
    {
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_0 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("href", new global::Microsoft.AspNetCore.Html.HtmlString("~/Medicio2/assets/vendor/bootstrap-icons/bootstrap-icons.css"), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_1 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("rel", new global::Microsoft.AspNetCore.Html.HtmlString("stylesheet"), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_2 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("href", new global::Microsoft.AspNetCore.Html.HtmlString("~/Medicio2/assets/vendor/bootstrap/css/bootstrap.min.css"), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_3 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("href", new global::Microsoft.AspNetCore.Html.HtmlString("~/Medicio2/create.css"), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_4 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("asp-controller", "Doctor", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_5 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("asp-action", "HoDoctors", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_6 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("style", new global::Microsoft.AspNetCore.Html.HtmlString("position: relative; left: 48%;"), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        #line hidden
        #pragma warning disable 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext __tagHelperExecutionContext;
        #pragma warning restore 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner __tagHelperRunner = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner();
        #pragma warning disable 0169
        private string __tagHelperStringValueBuffer;
        #pragma warning restore 0169
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __backed__tagHelperScopeManager = null;
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __tagHelperScopeManager
        {
            get
            {
                if (__backed__tagHelperScopeManager == null)
                {
                    __backed__tagHelperScopeManager = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager(StartTagHelperWritingScope, EndTagHelperWritingScope);
                }
                return __backed__tagHelperScopeManager;
            }
        }
        private global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper;
        private global::Microsoft.AspNetCore.Mvc.TagHelpers.AnchorTagHelper __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n");
#nullable restore
#line 3 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
  
    ViewData["Title"] = "DetailsForResception";

#line default
#line hidden
#nullable disable
            DefineSection("Styles", async() => {
                WriteLiteral("\r\n    ");
                __tagHelperExecutionContext = __tagHelperScopeManager.Begin("link", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.SelfClosing, "78a65cbc87745e19fd88b86a02c2133f134d3b356169", async() => {
                }
                );
                __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper>();
                __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper);
                __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_0);
                __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_1);
                await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
                if (!__tagHelperExecutionContext.Output.IsContentModified)
                {
                    await __tagHelperExecutionContext.SetOutputContentAsync();
                }
                Write(__tagHelperExecutionContext.Output);
                __tagHelperExecutionContext = __tagHelperScopeManager.End();
                WriteLiteral("\r\n    ");
                __tagHelperExecutionContext = __tagHelperScopeManager.Begin("link", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.SelfClosing, "78a65cbc87745e19fd88b86a02c2133f134d3b357347", async() => {
                }
                );
                __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper>();
                __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper);
                __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_2);
                __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_1);
                await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
                if (!__tagHelperExecutionContext.Output.IsContentModified)
                {
                    await __tagHelperExecutionContext.SetOutputContentAsync();
                }
                Write(__tagHelperExecutionContext.Output);
                __tagHelperExecutionContext = __tagHelperScopeManager.End();
                WriteLiteral("\r\n    ");
                __tagHelperExecutionContext = __tagHelperScopeManager.Begin("link", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.SelfClosing, "78a65cbc87745e19fd88b86a02c2133f134d3b358525", async() => {
                }
                );
                __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper>();
                __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper);
                __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_3);
                __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_1);
                await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
                if (!__tagHelperExecutionContext.Output.IsContentModified)
                {
                    await __tagHelperExecutionContext.SetOutputContentAsync();
                }
                Write(__tagHelperExecutionContext.Output);
                __tagHelperExecutionContext = __tagHelperScopeManager.End();
                WriteLiteral("\r\n    <style>\r\n        html {\r\n            height: 100vh;\r\n        }\r\n    </style>\r\n");
            }
            );
            WriteLiteral("\r\n<div class=\"All_div\">\r\n    <dl class=\"row\" style=\" direction: rtl; width: 80%; position: relative; left: 10%; background-color: white; border-radius: 20px; margin:5% 0; \">\r\n        <dt class=\"col-6\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 20 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayNameFor(model => model.Doctor_Full_Name));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dt>\r\n\r\n        <dd class=\"col-3\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 24 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayFor(model => model.Doctor_Full_Name));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dd>\r\n        <dt class=\"col-6\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 27 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayNameFor(model => model.Doctor_National_Number));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dt>\r\n        <dd class=\"col-3\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 30 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayFor(model => model.Doctor_National_Number));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dd>\r\n        <dt class=\"col-6\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 33 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayNameFor(model => model.Doctor_Gender));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dt>\r\n        <dd class=\"col-3\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 36 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayFor(model => model.Doctor_Gender));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dd>\r\n        <dt class=\"col-6\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 39 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayNameFor(model => model.Doctor_Social_Status));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dt>\r\n        <dd class=\"col-3\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 42 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayFor(model => model.Doctor_Social_Status));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dd>\r\n        <dt class=\"col-6\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 45 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayNameFor(model => model.Doctor_Birth_Date));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dt>\r\n        <dd class=\"col-3\" style=\" margin: 20px 0px; \">\r\n            ");
#nullable restore
#line 48 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
       Write(Html.DisplayFor(model => model.Doctor_Birth_Date));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </dd>\r\n\r\n        <dt class=\"col-6\" style=\" margin: 20px 0px; \">\r\n            أرقام الهاتف\r\n        </dt>\r\n");
#nullable restore
#line 54 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
         if (ViewBag.PhoneNumbers.Count == 0)
        {

#line default
#line hidden
#nullable disable
            WriteLiteral("            <dd class=\"col-3\" style=\" margin: 20px 0px; \">لا يوجد رقم هاتف</dd>\r\n");
#nullable restore
#line 57 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
        }
        else
            

#line default
#line hidden
#nullable disable
#nullable restore
#line 59 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
             foreach (var item in ViewBag.PhoneNumbers as List<LastHMS2.Class_Attriputes.Doctor_Phone_Numbers>)
            {
                

#line default
#line hidden
#nullable disable
#nullable restore
#line 61 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
           Write(Html.DisplayFor(model => item.Doctor_Phone_Number));

#line default
#line hidden
#nullable disable
            WriteLiteral("                <br />\r\n");
#nullable restore
#line 63 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
            }

#line default
#line hidden
#nullable disable
            WriteLiteral("    </dl>\r\n</div>\r\n");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("a", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "78a65cbc87745e19fd88b86a02c2133f134d3b3515475", async() => {
                WriteLiteral("Back to List");
            }
            );
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.AnchorTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper);
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.Controller = (string)__tagHelperAttribute_4.Value;
            __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_4);
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.Action = (string)__tagHelperAttribute_5.Value;
            __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_5);
            if (__Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues == null)
            {
                throw new InvalidOperationException(InvalidTagHelperIndexerAssignment("asp-route-id", "Microsoft.AspNetCore.Mvc.TagHelpers.AnchorTagHelper", "RouteValues"));
            }
            BeginWriteTagHelperAttribute();
#nullable restore
#line 66 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
                                                    WriteLiteral(ViewBag.HoId);

#line default
#line hidden
#nullable disable
            __tagHelperStringValueBuffer = EndWriteTagHelperAttribute();
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues["id"] = __tagHelperStringValueBuffer;
            __tagHelperExecutionContext.AddTagHelperAttribute("asp-route-id", __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues["id"], global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
            BeginWriteTagHelperAttribute();
#nullable restore
#line 66 "C:\Users\Huda\Desktop\Projects\Smart-Hospital-Management\LastHMS2\Views\Doctor\DetailsForResception.cshtml"
                                                                                    WriteLiteral(ViewBag.EmpId);

#line default
#line hidden
#nullable disable
            __tagHelperStringValueBuffer = EndWriteTagHelperAttribute();
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues["EmpId"] = __tagHelperStringValueBuffer;
            __tagHelperExecutionContext.AddTagHelperAttribute("asp-route-EmpId", __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues["EmpId"], global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
            __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_6);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            WriteLiteral("\r\n");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<LastHMS2.Models.Doctor> Html { get; private set; }
    }
}
#pragma warning restore 1591
