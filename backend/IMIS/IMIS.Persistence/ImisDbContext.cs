using Base.Abstractions;
using Base.Utilities;
using IMIS.Domain;
using IMIS.Persistence.SeedConfigurations;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace IMIS.Persistence
{
    public class ImisDbContext : AuditableDbContext
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
        public DbSet<PerfomanceGovernanceSystem> PerformanceGovernanceSystem { get; set; }
        public DbSet<PgsPeriod> PgsPeriod { get; set; }
        public DbSet<PgsReadinessRating> PgsReadiness { get; set; }
        public DbSet<UserOffices> UserOffices { get; set; }
        public DbSet<PgsSignatory> PgsSignatory { get; set; }
        public DbSet<PgsSignatoryTemplate> PgsSignatoryTemplate { get; set; }       
        public DbSet<OfficeType> OfficeType { get; set; }
        public DbSet<PgsSummaryNarrative> PgsSummaryNarrative { get; set; }
        public DbSet<PgsDeliverableAccomplishment> PgsDeliverableAccomplishment { get; set; }
        public DbSet<Announcement> Announcement { get; set; }
        public DbSet<BreakThroughScoring> BreakThroughScoring { get; set; }
        public DbSet<SWOTAnalysis> SWOTAnalysis { get; set; }
        public DbSet<KraRoadMapPeriod> KraRoadMapPeriod { get; set; }

        public ImisDbContext(DbContextOptions<ImisDbContext> options)
            : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            
            base.OnModelCreating(builder);
        
            builder.Entity<User>().ToTable("AspNetUsers");
           
            builder.Entity<AuditorOffices>(ao =>
            {                
                ao.HasKey(x => x.Id);
                
                ao.HasIndex(x => new { x.AuditorId, x.OfficeId, x.PgsPeriodId })
                  .IsUnique();
                
                ao.HasOne(x => x.Auditor)
                  .WithMany(a => a.AuditorOffices)
                  .HasForeignKey(x => x.AuditorId);

                ao.HasOne(x => x.Office)
                  .WithMany(o => o.AuditorOffices)
                  .HasForeignKey(x => x.OfficeId);             
            });

            builder.Entity<AuditorTeams>()
                .HasKey(at => at.Id);

            builder.Entity<AuditorTeams>()
                .HasIndex(at => new { at.AuditorId, at.TeamId })
                .IsUnique(); 

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

            builder.Entity<Office>()
               .HasOne(o => o.ParentOffice)
               .WithMany()
               .HasForeignKey(o => o.ParentOfficeId)
               .OnDelete(DeleteBehavior.NoAction);

            builder.Entity<PgsSignatoryTemplate>()
                .HasOne(p => p.Office)
                .WithMany(o => o.SignatoryTemplates)
                .HasForeignKey(p => p.OfficeId)
                .OnDelete(DeleteBehavior.NoAction);

            builder.Entity<AuditorOffices>()
                .HasOne(x => x.Office)
                .WithMany(o => o.AuditorOffices)
                .HasForeignKey(x => x.OfficeId)
                .OnDelete(DeleteBehavior.NoAction);

            builder.Entity<AuditableOffices>()
                .HasOne(x => x.Office)
                .WithMany(o => o.AuditableOffices)
                .HasForeignKey(x => x.OfficeId)
                .OnDelete(DeleteBehavior.NoAction);

            builder.Entity<UserOffices>()
                .HasOne<Office>()
                .WithMany(o => o.UserOffices)
                .HasForeignKey(x => x.OfficeId)
                .OnDelete(DeleteBehavior.NoAction);

            // Apply seed configurations
            builder.ApplyConfiguration(new RoleConfiguration());
            builder.ApplyConfiguration(new UserConfiguration());
            builder.ApplyConfiguration(new UserRoleConfiguration());
            builder.ApplyConfiguration(new OfficeTypeConfiguration());
            builder.ApplyConfiguration(new OfficeConfiguration());
            builder.ApplyConfiguration(new KeyResultAreaConfiguration());
            builder.ApplyConfiguration(new PgsSignatoryTemplateConfiguration());
            builder.ApplyConfiguration(new UserOfficeConfiguration());
            builder.ApplyConfiguration(new TeamConfiguration());
            builder.ApplyConfiguration(new AuditorConfiguration());
            builder.ApplyConfiguration(new PgsPeriodConfiguration());
            builder.ApplyConfiguration(new AuditorOfficeConfiguration());
            builder.ApplyConfiguration(new AuditorTeamsConfiguration());

            // Apply global query filter for soft deletion
            // This will ensure that all entities implementing ISoftDeletable are filtered by IsDeleted = false
            // Use IgnoreQueryFilters() if you want to bypass this filter in specific queries
            builder.ApplySoftDeleteQueryFilter();
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .ConfigureWarnings(warnings =>
                    warnings.Ignore(RelationalEventId.PendingModelChangesWarning));
        }
    }
}
