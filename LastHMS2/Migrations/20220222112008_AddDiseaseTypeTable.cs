using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class AddDiseaseTypeTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Work_Days");

            migrationBuilder.AddColumn<int>(
                name: "Disease_Type_Id",
                table: "Diseases",
                type: "int",
                nullable: false);

            migrationBuilder.CreateTable(
                name: "Diseases_Types",
                columns: table => new
                {
                    Disease_Type_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Disease_Type_Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Diseases_Types", x => x.Disease_Type_Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Diseases_Disease_Type_Id",
                table: "Diseases",
                column: "Disease_Type_Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Diseases_Diseases_Types_Disease_Type_Id",
                table: "Diseases",
                column: "Disease_Type_Id",
                principalTable: "Diseases_Types",
                principalColumn: "Disease_Type_Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Diseases_Diseases_Types_Disease_Type_Id",
                table: "Diseases");

            migrationBuilder.DropTable(
                name: "Diseases_Types");

            migrationBuilder.DropIndex(
                name: "IX_Diseases_Disease_Type_Id",
                table: "Diseases");

            migrationBuilder.DropColumn(
                name: "Disease_Type_Id",
                table: "Diseases");

            migrationBuilder.CreateTable(
                name: "Work_Days",
                columns: table => new
                {
                    Doctor_Id = table.Column<int>(type: "int", nullable: false),
                    Day = table.Column<DateTime>(type: "datetime2", nullable: false),
                    End_Hour = table.Column<TimeSpan>(type: "time", nullable: false),
                    Start_Hour = table.Column<TimeSpan>(type: "time", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Work_Days", x => new { x.Doctor_Id, x.Day });
                    table.ForeignKey(
                        name: "FK_Work_Days_Doctors_Doctor_Id",
                        column: x => x.Doctor_Id,
                        principalTable: "Doctors",
                        principalColumn: "Doctor_Id",
                        onDelete: ReferentialAction.Cascade);
                });
        }
    }
}
