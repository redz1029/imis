using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class UserRoleConfiguration : IEntityTypeConfiguration<IdentityUserRole<string>>
{
    public void Configure(EntityTypeBuilder<IdentityUserRole<string>> builder)
    {
        builder.HasData(
            new IdentityUserRole<string>
            {
                UserId = "475e45a8-4dd9-425c-b405-b6598ef700fd", // UserId of the admin
                RoleId = "b5fdea0d-3825-4cba-82f1-e1f570c00edc"  // RoleId of the Administrator
            }
        );
    }
}
