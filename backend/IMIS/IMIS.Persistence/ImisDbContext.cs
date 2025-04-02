using System.Reflection.Emit;
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
        public DbSet<AuditorTeams> AuditorTeams { get; set; }
        public DbSet<AuditSchedule> AuditSchedules { get; set; }
        public DbSet<AuditScheduleDetails> AuditScheduleDetails { get; set; }
        public DbSet<AuditableOffices> AuditableOffices { get; set; }
        public DbSet<PgsDeliverable> Deliverable { get; set; }
        public DbSet<KeyResultArea> KeyResultArea { get; set; }
        public DbSet<PerfomanceGovernanceSystem> PgsAuditDetails { get; set; }
        public DbSet<PgsPeriod> PgsPeriod { get; set; }
        public DbSet<PgsReadinessRating> PgsReadiness { get; set; }
        public DbSet<UserOffices> UserOffices { get; set; }
        public ImisDbContext(DbContextOptions<ImisDbContext> options)
            : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            
            base.OnModelCreating(builder);
        
            builder.Entity<User>().ToTable("AspNetUsers");         

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
                .HasOne(t => t.Team)
                .WithMany(at => at.AuditorTeams)
                .HasForeignKey(at => at.TeamId);

            builder.Entity<AuditorTeams>()
                .HasOne(a => a.Auditor)
                .WithMany(at => at.AuditorTeams)
                .HasForeignKey(at => at.AuditorId);

            builder.Entity<AuditableOffices>()
                .HasKey(ao => new { ao.AuditScheduleId, ao.OfficeId });

            builder.Entity<AuditableOffices>()
                .HasOne(ao => ao.AuditSchedule)
                .WithMany(a => a.AuditableOffices)
                .HasForeignKey(a => a.AuditScheduleId);

            builder.Entity<AuditableOffices>()
                .HasOne(ao => ao.Office)
                .WithMany(o => o.AuditableOffices)
                .HasForeignKey(ao => ao.OfficeId);
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
