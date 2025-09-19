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
                MiddleName = "Bello",
                PhoneNumber = "09069043375",
            },
             new User
             {
                 Id = "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                 UserName = "Nolan",
                 NormalizedUserName = "NOLAN",
                 Email = "Nolan1234@gmail.com",
                 NormalizedEmail = "NOLAN1234@GMAIL.COM",
                 PasswordHash = hasher.HashPassword(null, defaultPassword),
                 ConcurrencyStamp = Guid.NewGuid().ToString(),
                 LastName = "Avanzado",
                 FirstName = "Nolan",
                 MiddleName = "",
                 PhoneNumber = "",                
             },
              new User
              {
                  Id = "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                  UserName = "Sheila",
                  NormalizedUserName = "SHEILA",
                  Email = "Sheila1234@gmail.com",
                  NormalizedEmail = "SHEILA1234@GMAIL.COM",
                  PasswordHash = hasher.HashPassword(null, defaultPassword),
                  ConcurrencyStamp = Guid.NewGuid().ToString(),
                  LastName = "Mangelen",
                  FirstName = "Sheila farish",
                  MiddleName = "K.",
                  PhoneNumber = "",
              },
               new User
               {
                   Id = "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                   UserName = "Johari",
                   NormalizedUserName = "JOHARI",
                   Email = "Johari1234@gmail.com",
                   NormalizedEmail = "JOHARI1234@GMAIL.COM",
                   PasswordHash = hasher.HashPassword(null, defaultPassword),
                   ConcurrencyStamp = Guid.NewGuid().ToString(),
                   LastName = "Casan",
                   FirstName = "Johari",
                   MiddleName = "P.",
                   PhoneNumber = "",
               },
                new User
                {
                    Id = "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                    UserName = "Linda",
                    NormalizedUserName = "LINDA",
                    Email = "Linda1234@gmail.com",
                    NormalizedEmail = "LINDA1234@GMAIL.COM",
                    PasswordHash = hasher.HashPassword(null, defaultPassword),
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                    LastName = "Garde",
                    FirstName = "Linda",
                    MiddleName = "P.",
                    PhoneNumber = "",
                },
                 new User
                 {
                     Id = "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                     UserName = "Java",
                     NormalizedUserName = "JAVA",
                     Email = "Java1234@gmail.com",
                     NormalizedEmail = "JAVA1234@GMAIL.COM",
                     PasswordHash = hasher.HashPassword(null, defaultPassword),
                     ConcurrencyStamp = Guid.NewGuid().ToString(),
                     LastName = "Java",
                     FirstName = "Sergio",
                     MiddleName = "C.",
                     PhoneNumber = "",
                 },
                  new User
                  {
                      Id = "a6866933-92a9-41e7-9100-8bee51ed0ada",
                      UserName = "John",
                      NormalizedUserName = "JOHN",
                      Email = "John1234@gmail.com",
                      NormalizedEmail = "JOHN1234@GMAIL.COM",
                      PasswordHash = hasher.HashPassword(null, defaultPassword),
                      ConcurrencyStamp = Guid.NewGuid().ToString(),
                      LastName = "Maliga",
                      FirstName = "John",
                      MiddleName = "O.",
                      PhoneNumber = "",
                  },
                   new User
                   {
                       Id = "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                       UserName = "Ibrahim",
                       NormalizedUserName = "IBRAHIM",
                       Email = "Ibrahim1234@gmail.com",
                       NormalizedEmail = "IBRAHIM1234@GMAIL.COM",
                       PasswordHash = hasher.HashPassword(null, defaultPassword),
                       ConcurrencyStamp = Guid.NewGuid().ToString(),
                       LastName = "Ibrahim",
                       FirstName = "Scheherazade",
                       MiddleName = "E.",
                       PhoneNumber = "",
                   },
                    new User
                    {
                        Id = "e1a3ac20-1d20-4f37-8826-242657a746c7",
                        UserName = "Dimaren",
                        NormalizedUserName = "DIMAREN",
                        Email = "Dimaren1234@gmail.com",
                        NormalizedEmail = "DIMAREN1234@GMAIL.COM",
                        PasswordHash = hasher.HashPassword(null, defaultPassword),
                        ConcurrencyStamp = Guid.NewGuid().ToString(),
                        LastName = "Dimaren",
                        FirstName = "Ishmael",
                        MiddleName = "R.",
                        PhoneNumber = "",
                    },
                     new User
                     {
                         Id = "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                         UserName = "Precious",
                         NormalizedUserName = "PRECIOUS",
                         Email = "Precious1234@gmail.com",
                         NormalizedEmail = "PRECIOUS1234@GMAIL.COM",
                         PasswordHash = hasher.HashPassword(null, defaultPassword),
                         ConcurrencyStamp = Guid.NewGuid().ToString(),
                         LastName = "Esquillo",
                         FirstName = "Precious Love",
                         MiddleName = "Y.",
                         PhoneNumber = "",
                     },
                     new User
                     {
                         Id = "18b4151f-bff9-4525-b787-7a7e009757c3",
                         UserName = "Singgon",
                         NormalizedUserName = "SINGGON",
                         Email = "Singgon1234@gmail.com",
                         NormalizedEmail = "SINGGON1234@GMAIL.COM",
                         PasswordHash = hasher.HashPassword(null, defaultPassword),
                         ConcurrencyStamp = Guid.NewGuid().ToString(),
                         LastName = "Singgon",
                         FirstName = "Bai Samirah",
                         MiddleName = "A.",
                         PhoneNumber = "",
                     }
        );
    }
}
