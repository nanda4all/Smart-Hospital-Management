using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class AlterTableHospital_Manager : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Hospitals_Doctors_Mgr_Id",
                table: "Hospitals");

            migrationBuilder.AddForeignKey(
                name: "FK_Hospitals_Employees_Mgr_Id",
                table: "Hospitals",
                column: "Mgr_Id",
                principalTable: "Employees",
                principalColumn: "Employee_Id",
                onDelete: ReferentialAction.NoAction);
            migrationBuilder.AlterColumn<int>(
               name: "Mgr_Id",
               table: "Hospitals",
               type: "int",
               nullable: true,
               oldNullable: false);
             
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Hospitals_Employees_Mgr_Id",
                table: "Hospitals");

            migrationBuilder.AddForeignKey(
                name: "FK_Hospitals_Doctors_Mgr_Id",
                table: "Hospitals",
                column: "Mgr_Id",
                principalTable: "Doctors",
                principalColumn: "Doctor_Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
