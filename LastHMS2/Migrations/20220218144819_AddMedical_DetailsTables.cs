using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class AddMedical_DetailsTables : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Allergies",
                columns: table => new
                {
                    Allergy_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Allergy_Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Allergies", x => x.Allergy_Id);
                });

            migrationBuilder.CreateTable(
                name: "Diseases",
                columns: table => new
                {
                    Disease_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Disease_Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Diseases", x => x.Disease_Id);
                });

            migrationBuilder.CreateTable(
                name: "Medical_Details",
                columns: table => new
                {
                    Medical_Details_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MD_Patient_Blood_Type = table.Column<string>(type: "nvarchar(3)", maxLength: 3, nullable: true),
                    MD_Patient_Treatment_Plans_And_Daily_Supplements = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    MD_Patient_Special_Needs = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Patient_Id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Medical_Details", x => x.Medical_Details_Id);
                    table.ForeignKey(
                        name: "FK_Medical_Details_Patients_Patient_Id",
                        column: x => x.Patient_Id,
                        principalTable: "Patients",
                        principalColumn: "Patient_Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Examination_Records",
                columns: table => new
                {
                    Examination_Records_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Details = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Medical_Detail_Id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Examination_Records", x => x.Examination_Records_Id);
                    table.ForeignKey(
                        name: "FK_Examination_Records_Medical_Details_Medical_Detail_Id",
                        column: x => x.Medical_Detail_Id,
                        principalTable: "Medical_Details",
                        principalColumn: "Medical_Details_Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "External_Records",
                columns: table => new
                {
                    External_Records_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Details = table.Column<byte[]>(type: "image", nullable: false),
                    Medical_Detail_Id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_External_Records", x => x.External_Records_Id);
                    table.ForeignKey(
                        name: "FK_External_Records_Medical_Details_Medical_Detail_Id",
                        column: x => x.Medical_Detail_Id,
                        principalTable: "Medical_Details",
                        principalColumn: "Medical_Details_Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Medical_Allergies",
                columns: table => new
                {
                    Allergy_Id = table.Column<int>(type: "int", nullable: false),
                    Medical_Detail_Id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Medical_Allergies", x => new { x.Allergy_Id, x.Medical_Detail_Id });
                    table.ForeignKey(
                        name: "FK_Medical_Allergies_Allergies_Allergy_Id",
                        column: x => x.Allergy_Id,
                        principalTable: "Allergies",
                        principalColumn: "Allergy_Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Medical_Allergies_Medical_Details_Medical_Detail_Id",
                        column: x => x.Medical_Detail_Id,
                        principalTable: "Medical_Details",
                        principalColumn: "Medical_Details_Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Medical_Diseases",
                columns: table => new
                {
                    Disease_Id = table.Column<int>(type: "int", nullable: false),
                    Medical_Detail_Id = table.Column<int>(type: "int", nullable: false),
                    Family_Health_History = table.Column<bool>(type: "bit", nullable: true),
                    Chronic_Diseases = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Medical_Diseases", x => new { x.Disease_Id, x.Medical_Detail_Id });
                    table.ForeignKey(
                        name: "FK_Medical_Diseases_Diseases_Disease_Id",
                        column: x => x.Disease_Id,
                        principalTable: "Diseases",
                        principalColumn: "Disease_Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Medical_Diseases_Medical_Details_Medical_Detail_Id",
                        column: x => x.Medical_Detail_Id,
                        principalTable: "Medical_Details",
                        principalColumn: "Medical_Details_Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Examination_Records_Medical_Detail_Id",
                table: "Examination_Records",
                column: "Medical_Detail_Id");

            migrationBuilder.CreateIndex(
                name: "IX_External_Records_Medical_Detail_Id",
                table: "External_Records",
                column: "Medical_Detail_Id");

            migrationBuilder.CreateIndex(
                name: "IX_Medical_Allergies_Medical_Detail_Id",
                table: "Medical_Allergies",
                column: "Medical_Detail_Id");

            migrationBuilder.CreateIndex(
                name: "IX_Medical_Details_Patient_Id",
                table: "Medical_Details",
                column: "Patient_Id");

            migrationBuilder.CreateIndex(
                name: "IX_Medical_Diseases_Medical_Detail_Id",
                table: "Medical_Diseases",
                column: "Medical_Detail_Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Examination_Records");

            migrationBuilder.DropTable(
                name: "External_Records");

            migrationBuilder.DropTable(
                name: "Medical_Allergies");

            migrationBuilder.DropTable(
                name: "Medical_Diseases");

            migrationBuilder.DropTable(
                name: "Allergies");

            migrationBuilder.DropTable(
                name: "Diseases");

            migrationBuilder.DropTable(
                name: "Medical_Details");
        }
    }
}
