#pragma checksum "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "be8226578d1fd3bd255bd4dd5d033eb0caf2b4b0"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Medical_Detail_ShowMedicalDetailsForDoctor), @"mvc.1.0.view", @"/Views/Medical_Detail/ShowMedicalDetailsForDoctor.cshtml")]
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
#line 1 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\_ViewImports.cshtml"
using LastHMS2;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\_ViewImports.cshtml"
using LastHMS2.Models;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"be8226578d1fd3bd255bd4dd5d033eb0caf2b4b0", @"/Views/Medical_Detail/ShowMedicalDetailsForDoctor.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"61ac8c6333f29274d2ec4a26eacc5975733ebead", @"/Views/_ViewImports.cshtml")]
    public class Views_Medical_Detail_ShowMedicalDetailsForDoctor : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<LastHMS2.Models.Medical_Detail>
    {
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_0 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("asp-controller", "Doctor", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_1 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("asp-action", "Master", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
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
        private global::Microsoft.AspNetCore.Mvc.TagHelpers.AnchorTagHelper __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n");
#nullable restore
#line 3 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
  
    ViewData["Title"] = "ShowMedicalDetailsForPatient";

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n<h1>ShowMedicalDetailsForPatient</h1>\r\n<div class=\"FullPage\">\r\n    <div class=\"div1\">\r\n        <div class=\"details\">\r\n            <label>زمرة الدم : </label>\r\n            <input type=\"text\"");
            BeginWriteAttribute("value", " value=\"", 296, "\"", 332, 1);
#nullable restore
#line 12 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
WriteAttributeValue("", 304, Model.MD_Patient_Blood_Type, 304, 28, false);

#line default
#line hidden
#nullable disable
            EndWriteAttribute();
            WriteLiteral(">\r\n        </div>\r\n        <div class=\"details\">\r\n            <label>الإحتياجات الخاصة :</label>\r\n            <textarea rows=\"2\" cols=\"20\" placeholder=\"الإحتياجات الخاصة\">");
#nullable restore
#line 16 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
                                                                    Write(Model.MD_Patient_Special_Needs);

#line default
#line hidden
#nullable disable
            WriteLiteral("</textarea>\r\n        </div>\r\n        <div class=\"details\">\r\n            <label>الخطة العلاجية :</label>\r\n            <textarea rows=\"2\" cols=\"20\" placeholder=\"الخطة العلاجية\">");
#nullable restore
#line 20 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
                                                                 Write(Model.MD_Patient_Treatment_Plans_And_Daily_Supplements);

#line default
#line hidden
#nullable disable
            WriteLiteral("</textarea>\r\n        </div>\r\n    </div>\r\n");
            WriteLiteral("    <div class=\"div3\">\r\n        <table>\r\n\r\n            <tr>\r\n                <th>الحساسيات</th>\r\n            </tr>\r\n\r\n");
#nullable restore
#line 37 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
             foreach (var item in ViewBag.allergies as List<LastHMS2.Extra_Tables.Allergy>)
            {

#line default
#line hidden
#nullable disable
            WriteLiteral("                <tr>\r\n                    ");
#nullable restore
#line 40 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
               Write(item.Allergy_Name);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </tr>\r\n");
#nullable restore
#line 42 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
            }

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </table>\r\n    </div>\r\n\r\n    <div class=\"div4\">\r\n        <table>\r\n            <tr>\r\n                <th>الأمراض المزمنة</th>\r\n                <td>إسم المرض</td>\r\n            </tr>\r\n");
#nullable restore
#line 53 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
             foreach (var item in ViewBag.chronic_diseases as List<LastHMS2.Extra_Tables.Disease>)
            {

#line default
#line hidden
#nullable disable
            WriteLiteral("                <tr>\r\n                    ");
#nullable restore
#line 56 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
               Write(item.Disease_Name);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </tr>\r\n");
#nullable restore
#line 58 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
            }

#line default
#line hidden
#nullable disable
            WriteLiteral("        </table>\r\n    </div>\r\n\r\n    <div class=\"div5\">\r\n        <table>\r\n            <tr>\r\n                <th>الأمراض العائلية</th>\r\n                <td>إسم المرض</td>\r\n            </tr>\r\n");
#nullable restore
#line 68 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
             foreach (var item in ViewBag.family_diseases as List<LastHMS2.Extra_Tables.Disease>)
            {

#line default
#line hidden
#nullable disable
            WriteLiteral("                <tr>\r\n                    ");
#nullable restore
#line 71 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
               Write(item.Disease_Name);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </tr>\r\n");
#nullable restore
#line 73 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
            }

#line default
#line hidden
#nullable disable
            WriteLiteral("        </table>\r\n    </div>\r\n\r\n    <div class=\"btn_div\">\r\n        <button>الملفات الخارجية</button>\r\n        <button>الأشعة</button>\r\n        <button>اتحاليل</button>\r\n    </div>\r\n</div>\r\n");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("a", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "be8226578d1fd3bd255bd4dd5d033eb0caf2b4b09148", async() => {
                WriteLiteral("Back To Master Page");
            }
            );
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.AnchorTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper);
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.Controller = (string)__tagHelperAttribute_0.Value;
            __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_0);
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.Action = (string)__tagHelperAttribute_1.Value;
            __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_1);
            if (__Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues == null)
            {
                throw new InvalidOperationException(InvalidTagHelperIndexerAssignment("asp-route-id", "Microsoft.AspNetCore.Mvc.TagHelpers.AnchorTagHelper", "RouteValues"));
            }
            BeginWriteTagHelperAttribute();
#nullable restore
#line 83 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
                                                 WriteLiteral(ViewBag.DocId);

#line default
#line hidden
#nullable disable
            __tagHelperStringValueBuffer = EndWriteTagHelperAttribute();
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues["id"] = __tagHelperStringValueBuffer;
            __tagHelperExecutionContext.AddTagHelperAttribute("asp-route-id", __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues["id"], global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
            BeginWriteTagHelperAttribute();
#nullable restore
#line 83 "C:\Users\Huda\Desktop\Projects\LastHMS2\Views\Medical_Detail\ShowMedicalDetailsForDoctor.cshtml"
                                                                                 WriteLiteral(ViewBag.HoId);

#line default
#line hidden
#nullable disable
            __tagHelperStringValueBuffer = EndWriteTagHelperAttribute();
            __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues["HoId"] = __tagHelperStringValueBuffer;
            __tagHelperExecutionContext.AddTagHelperAttribute("asp-route-HoId", __Microsoft_AspNetCore_Mvc_TagHelpers_AnchorTagHelper.RouteValues["HoId"], global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
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
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<LastHMS2.Models.Medical_Detail> Html { get; private set; }
    }
}
#pragma warning restore 1591
