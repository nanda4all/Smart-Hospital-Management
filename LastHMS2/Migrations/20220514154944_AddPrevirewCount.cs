using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class AddPrevirewCount : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "PreviewCount",
                table: "Patients",
                type: "int",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PreviewCount",
                table: "Patients");
        }
    }
}
