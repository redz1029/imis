using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;


public class UserConfiguration : IEntityTypeConfiguration<IdentityUser>
{
    
    public void Configure(EntityTypeBuilder<IdentityUser> builder)
    {
 
        var hasher = new PasswordHasher<IdentityUser>();
        string defaultPassword = "Abc123*@";

        builder.HasData(
            new IdentityUser
            {
                Id = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",             
                UserName = "redz1029",
                NormalizedUserName = "REDZ1029",
                Email = "marcrejohncastillano@gmail.com",
                NormalizedEmail = "MARCREJOHNCASTILLANO@GMAIL.COM",
                PasswordHash = hasher.HashPassword(null, defaultPassword),
                ConcurrencyStamp = Guid.NewGuid().ToString(),
            },
            new IdentityUser
            {
                Id = "176bcfeb-f12a-4d42-b790-5d2312660801",                
                UserName = "alyxx1988",
                NormalizedUserName = "ALYXX1988",
                Email = "alondealexa2021@gmail.com",
                NormalizedEmail = "ALONDEALEXA2021@GMAIL.COM",
                PasswordHash = hasher.HashPassword(null, defaultPassword),
                ConcurrencyStamp = Guid.NewGuid().ToString(),
            },
            new IdentityUser
            {
                Id = "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",              
                UserName = "darkwizwiz",
                NormalizedUserName = "DARKWIZWIZ",
                Email = "CrossVampireNe0@gmail.com",
                NormalizedEmail = "CROSSVAMPIRENE0@GMAIL.COM",
                PasswordHash = hasher.HashPassword(null, defaultPassword),
                ConcurrencyStamp = Guid.NewGuid().ToString(),
            }
        );
    }
}
