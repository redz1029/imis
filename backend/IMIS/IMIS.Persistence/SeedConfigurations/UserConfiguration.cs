using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

public class UserConfiguration : IEntityTypeConfiguration<IdentityUser>
{
    public void Configure(EntityTypeBuilder<IdentityUser> builder)
    {
        var hasher = new PasswordHasher<IdentityUser>();
        string defaultAdminUsername = "admin";
        string defaultAdminEmail = "admin@mail.com";

        builder.HasData(new IdentityUser
        {
            Id = "475e45a8-4dd9-425c-b405-b6598ef700fd", // Use a fixed GUID or generate one
            UserName = defaultAdminUsername,
            NormalizedUserName = defaultAdminUsername.ToUpper(),
            Email = defaultAdminEmail.ToUpper(),
            NormalizedEmail = defaultAdminEmail.ToUpper(),
            PasswordHash = hasher.HashPassword(null, "Abc123*@"), // Hash the default password
            ConcurrencyStamp = Guid.NewGuid().ToString() // For concurrency tracking
        });
    }
}
