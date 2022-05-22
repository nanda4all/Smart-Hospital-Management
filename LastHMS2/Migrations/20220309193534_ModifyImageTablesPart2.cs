using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class ModifyImageTablesPart2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Ray_Result",
                table: "Rays",
                type: "nvarchar(250)",
                maxLength: 250,
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "Test_Result",
                table: "Medical_Tests",
                type: "nvarchar(250)",
                maxLength: 250,
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "Details",
                table: "External_Records",
                type: "nvarchar(250)",
                maxLength: 250,
                nullable: false);
        }
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Ray_Result",
                table: "Rays");

            migrationBuilder.DropColumn(
                name: "Test_Result",
                table: "Medical_Tests");

            migrationBuilder.DropColumn(
                name: "Details",
                table: "External_Records");
        }
    }
}
