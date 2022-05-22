using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class AddMedical_TestAndRaysTables : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Ray_Types",
                columns: table => new
                {
                    Ray_Type_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ray_Type_Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ray_Types", x => x.Ray_Type_Id);
                });

            migrationBuilder.CreateTable(
                name: "Test_Types",
                columns: table => new
                {
                    Test_Type_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Test_Type_Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Test_Types", x => x.Test_Type_Id);
                });

            migrationBuilder.CreateTable(
                name: "Rays",
                columns: table => new
                {
                    Ray_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ray_Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Ray_Result = table.Column<byte[]>(type: "image", nullable: false),
                    Ray_Type_Id = table.Column<int>(type: "int", nullable: false),
                    Patient_Id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rays", x => x.Ray_Id);
                    table.ForeignKey(
                        name: "FK_Rays_Patients_Patient_Id",
                        column: x => x.Patient_Id,
                        principalTable: "Patients",
                        principalColumn: "Patient_Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Rays_Ray_Types_Ray_Type_Id",
                        column: x => x.Ray_Type_Id,
                        principalTable: "Ray_Types",
                        principalColumn: "Ray_Type_Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Medical_Tests",
                columns: table => new
                {
                    Test_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Test_Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Test_Result = table.Column<byte[]>(type: "image", nullable: false),
                    Test_Type_Id = table.Column<int>(type: "int", nullable: false),
                    Patient_Id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Medical_Tests", x => x.Test_Id);
                    table.ForeignKey(
                        name: "FK_Medical_Tests_Patients_Patient_Id",
                        column: x => x.Patient_Id,
                        principalTable: "Patients",
                        principalColumn: "Patient_Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Medical_Tests_Test_Types_Test_Type_Id",
                        column: x => x.Test_Type_Id,
                        principalTable: "Test_Types",
                        principalColumn: "Test_Type_Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Medical_Tests_Patient_Id",
                table: "Medical_Tests",
                column: "Patient_Id");

            migrationBuilder.CreateIndex(
                name: "IX_Medical_Tests_Test_Type_Id",
                table: "Medical_Tests",
                column: "Test_Type_Id");

            migrationBuilder.CreateIndex(
                name: "IX_Rays_Patient_Id",
                table: "Rays",
                column: "Patient_Id");

            migrationBuilder.CreateIndex(
                name: "IX_Rays_Ray_Type_Id",
                table: "Rays",
                column: "Ray_Type_Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Medical_Tests");

            migrationBuilder.DropTable(
                name: "Rays");

            migrationBuilder.DropTable(
                name: "Test_Types");

            migrationBuilder.DropTable(
                name: "Ray_Types");
        }
    }
}
