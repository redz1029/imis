using IMIS.Domain;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace IMIS.Persistence
{
    public class ImisDbContext : IdentityDbContext
    {
        public DbSet<Auditor> Auditors { get; set; }
        public DbSet<Office> Offices { get; set; }
        public DbSet<AuditorOffices> AuditorOffices { get; set; }
        public DbSet<Team> Teams { get; set; }
        public DbSet<AuditorTeams> AuditoTeams { get; set; }
        public DbSet<AuditSchedule> AuditSchedules { get; set; }
        public DbSet<AuditSchduleDetails> AuditSchduleDetails { get; set; }

        public ImisDbContext(DbContextOptions<ImisDbContext> options)
            : base(options)  // Pass the options to the base DbContext constructor
        {
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Entity<AuditorOffices>()
                .HasKey(ao => new { ao.AuditorId, ao.OfficeId });

            builder.Entity<AuditorOffices>()
                .HasOne(ao => ao.Auditor)
                .WithMany(a => a.AuditorOffices)
                .HasForeignKey(a => a.AuditorId);

            builder.Entity<AuditorOffices>()
               .HasOne(ao => ao.Office)
               .WithMany(a => a.AuditorOffices)
               .HasForeignKey(a => a.OfficeId);

            builder.Entity<AuditorTeams>()
                .HasKey(at => new { at.AuditorId, at.TeamId });

            builder.Entity<AuditorTeams>()
                .HasOne<Team>(t => t.Team)
                .WithMany(at => at.AuditorTeams)
                .HasForeignKey(at => at.TeamId);

            builder.Entity<AuditorTeams>()
                .HasOne<Auditor>(a => a.Auditor)
                .WithMany(at => at.AuditorTeams)
                .HasForeignKey(at => at.AuditorId);

            base.OnModelCreating(builder);

            // Apply seed configurations
            builder.ApplyConfiguration(new RoleConfiguration());
            builder.ApplyConfiguration(new UserConfiguration());
            builder.ApplyConfiguration(new UserRoleConfiguration());
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .ConfigureWarnings(warnings =>
                    warnings.Ignore(RelationalEventId.PendingModelChangesWarning));
        }

    }
}