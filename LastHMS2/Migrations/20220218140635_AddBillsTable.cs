﻿using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class AddBillsTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Bills",
                columns: table => new
                {
                    Bill_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Bill_Examination = table.Column<decimal?>(type: "money", nullable: true),
                    Bill_Surgeries = table.Column<decimal?>(type: "money", nullable: true),
                    Bill_Rays = table.Column<decimal?>(type: "money", nullable: true),
                    Bill_Medical_Test = table.Column<decimal?>(type: "money", nullable: true),
                    Bill_Room_Service = table.Column<decimal?>(type: "money", nullable: true),
                    Bill_Medication = table.Column<decimal?>(type: "money", nullable: true),
                    Bill_Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Paid = table.Column<bool>(type: "bit", nullable: true),
                    Patient_Id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bills", x => x.Bill_Id);
                    table.ForeignKey(
                        name: "FK_Bills_Patients_Patient_Id",
                        column: x => x.Patient_Id,
                        principalTable: "Patients",
                        principalColumn: "Patient_Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Bills_Patient_Id",
                table: "Bills",
                column: "Patient_Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Bills");
        }
    }
}
