using Microsoft.EntityFrameworkCore.Migrations;

namespace LastHMS2.Migrations
{
    public partial class AddAdminsTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Admins",
                columns: table => new
                {
                    Admin_Email = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    Admin_Password = table.Column<string>(type: "nvarchar(25)", maxLength: 25, nullable: false)
                },
                constraints: table =>
                {
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Admins");
        }
    }
}
