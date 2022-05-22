using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class ModifyImageTablesPart1 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Medical_Details_Patients_Patient_Id",
                table: "Medical_Details");

            migrationBuilder.DropColumn(
                name: "Ray_Result",
                table: "Rays");

            migrationBuilder.DropColumn(
                name: "Test_Result",
                table: "Medical_Tests");

            migrationBuilder.DropColumn(
                name: "Details",
                table: "External_Records");

            migrationBuilder.AlterColumn<int>(
                name: "Patient_Id",
                table: "Medical_Details",
                type: "int",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Medical_Details_Patients_Patient_Id",
                table: "Medical_Details",
                column: "Patient_Id",
                principalTable: "Patients",
                principalColumn: "Patient_Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Medical_Details_Patients_Patient_Id",
                table: "Medical_Details");

            migrationBuilder.AddColumn<byte[]>(
                name: "Ray_Result",
                table: "Rays",
                type: "varbinary(max)",
                nullable: false,
                defaultValue: new byte[0]);

            migrationBuilder.AddColumn<byte[]>(
                name: "Test_Result",
                table: "Medical_Tests",
                type: "varbinary(max)",
                nullable: false,
                defaultValue: new byte[0]);

            migrationBuilder.AlterColumn<int>(
                name: "Patient_Id",
                table: "Medical_Details",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<byte[]>(
                name: "Details",
                table: "External_Records",
                type: "varbinary(max)",
                nullable: false,
                defaultValue: new byte[0]);

            migrationBuilder.AddForeignKey(
                name: "FK_Medical_Details_Patients_Patient_Id",
                table: "Medical_Details",
                column: "Patient_Id",
                principalTable: "Patients",
                principalColumn: "Patient_Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
