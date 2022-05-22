using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class ModifySpecializationRelations : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Doctors_Specializations_Doctor_Specialization_Id",
                table: "Doctors");

            migrationBuilder.DropIndex(
                name: "IX_Doctors_Doctor_Specialization_Id",
                table: "Doctors");

            migrationBuilder.DropColumn(
                name: "Doctor_Specialization_Id",
                table: "Doctors");

            migrationBuilder.DropColumn(
                name: "Department_Type",
                table: "Departments");

            migrationBuilder.AlterColumn<int>(
                name: "Department_Name",
                table: "Departments",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50);

            migrationBuilder.CreateIndex(
                name: "IX_Departments_Department_Name",
                table: "Departments",
                column: "Department_Name");

            migrationBuilder.AddForeignKey(
                name: "FK_Departments_Specializations_Department_Name",
                table: "Departments",
                column: "Department_Name",
                principalTable: "Specializations",
                principalColumn: "Specialization_Id",
                onDelete: ReferentialAction.NoAction);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Departments_Specializations_Department_Name",
                table: "Departments");

            migrationBuilder.DropIndex(
                name: "IX_Departments_Department_Name",
                table: "Departments");

            migrationBuilder.AddColumn<int>(
                name: "Doctor_Specialization_Id",
                table: "Doctors",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AlterColumn<string>(
                name: "Department_Name",
                table: "Departments",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<string>(
                name: "Department_Type",
                table: "Departments",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Doctors_Doctor_Specialization_Id",
                table: "Doctors",
                column: "Doctor_Specialization_Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Doctors_Specializations_Doctor_Specialization_Id",
                table: "Doctors",
                column: "Doctor_Specialization_Id",
                principalTable: "Specializations",
                principalColumn: "Specialization_Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
