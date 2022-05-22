using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class Edit_2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Examination_Records");

            migrationBuilder.AddColumn<string>(
                name: "ExaminationRecord",
                table: "Previews",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Canceled",
                table: "Patients",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ExaminationRecord",
                table: "Previews");

            migrationBuilder.DropColumn(
                name: "Canceled",
                table: "Patients");

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

            migrationBuilder.CreateIndex(
                name: "IX_Examination_Records_Medical_Detail_Id",
                table: "Examination_Records",
                column: "Medical_Detail_Id");
        }
    }
}
