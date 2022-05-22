using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class ModifyRaysAndMedical_TestRelations : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Medical_Tests_Patients_Patient_Id",
                table: "Medical_Tests");

            migrationBuilder.DropForeignKey(
                name: "FK_Rays_Patients_Patient_Id",
                table: "Rays");

            migrationBuilder.RenameColumn(
                name: "Patient_Id",
                table: "Rays",
                newName: "Medical_Detail_Id");

            migrationBuilder.RenameIndex(
                name: "IX_Rays_Patient_Id",
                table: "Rays",
                newName: "IX_Rays_Medical_Detail_Id");

            migrationBuilder.RenameColumn(
                name: "Patient_Id",
                table: "Medical_Tests",
                newName: "Medical_Detail_Id");

            migrationBuilder.RenameIndex(
                name: "IX_Medical_Tests_Patient_Id",
                table: "Medical_Tests",
                newName: "IX_Medical_Tests_Medical_Detail_Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Medical_Tests_Medical_Details_Medical_Detail_Id",
                table: "Medical_Tests",
                column: "Medical_Detail_Id",
                principalTable: "Medical_Details",
                principalColumn: "Medical_Details_Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Rays_Medical_Details_Medical_Detail_Id",
                table: "Rays",
                column: "Medical_Detail_Id",
                principalTable: "Medical_Details",
                principalColumn: "Medical_Details_Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Medical_Tests_Medical_Details_Medical_Detail_Id",
                table: "Medical_Tests");

            migrationBuilder.DropForeignKey(
                name: "FK_Rays_Medical_Details_Medical_Detail_Id",
                table: "Rays");

            migrationBuilder.RenameColumn(
                name: "Medical_Detail_Id",
                table: "Rays",
                newName: "Patient_Id");

            migrationBuilder.RenameIndex(
                name: "IX_Rays_Medical_Detail_Id",
                table: "Rays",
                newName: "IX_Rays_Patient_Id");

            migrationBuilder.RenameColumn(
                name: "Medical_Detail_Id",
                table: "Medical_Tests",
                newName: "Patient_Id");

            migrationBuilder.RenameIndex(
                name: "IX_Medical_Tests_Medical_Detail_Id",
                table: "Medical_Tests",
                newName: "IX_Medical_Tests_Patient_Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Medical_Tests_Patients_Patient_Id",
                table: "Medical_Tests",
                column: "Patient_Id",
                principalTable: "Patients",
                principalColumn: "Patient_Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Rays_Patients_Patient_Id",
                table: "Rays",
                column: "Patient_Id",
                principalTable: "Patients",
                principalColumn: "Patient_Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
