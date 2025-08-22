using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;


public class UserConfiguration : IEntityTypeConfiguration<User>
{
    
    public void Configure(EntityTypeBuilder<User> builder)
    {
 
        var hasher = new PasswordHasher<IdentityUser>();
        string defaultPassword = "Abc123*@";

        builder.HasData(
            new User
            {
                Id = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",             
                UserName = "castillano.mrb",
                NormalizedUserName = "CASTILLANO.MRB",
                Email = "marcrejohncastillano@gmail.com",
                NormalizedEmail = "MARCREJOHNCASTILLANO@GMAIL.COM",
                PasswordHash = hasher.HashPassword(null, defaultPassword),
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                LastName = "Castillano",
                FirstName = "Marc Rejohn",
                MiddleName = "Ballares",
                PhoneNumber = "09959283775",
            },
            new User
            {
                Id = "176bcfeb-f12a-4d42-b790-5d2312660801",                
                UserName = "rama.emg",
                NormalizedUserName = "RAMA.EMG",
                Email = "earlmaerama@gmail.com",
                NormalizedEmail = "EARLMAERAMA@GMAIL.COM",
                PasswordHash = hasher.HashPassword(null, defaultPassword),
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                LastName = "Rama",
                FirstName = "Earlene Mae",
                MiddleName = "Gallos",
                PhoneNumber = "09128293036",
            },
            new User
            {
                Id = "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",              
                UserName = "pimentel.wb",
                NormalizedUserName = "PIMENTEL.WB",
                Email = "wilburpimentel09@gmail.com",
                NormalizedEmail = "WILBURPIMENTEL09@GMAIL.COM",
                PasswordHash = hasher.HashPassword(null, defaultPassword),
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                LastName = "Pimentel",
                FirstName = "Wilbur",
                MiddleName = "Belli",
                PhoneNumber = "09069043375",
            }
        );
    }
}
