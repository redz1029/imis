﻿// <auto-generated />
using System;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    [DbContext(typeof(ImisDbContext))]
    [Migration("20250317021714_RemovePgsReadinessFromPgdDeliverables")]
    partial class RemovePgsReadinessFromPgdDeliverables
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "9.0.1")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("IMIS.Domain.AuditSchedule", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("AuditTitle")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("EndDate")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsActive")
                        .HasColumnType("bit");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.Property<DateTime>("StartDate")
                        .HasColumnType("datetime2");

                    b.HasKey("Id");

                    b.ToTable("AuditSchedules");
                });

            modelBuilder.Entity("IMIS.Domain.AuditScheduleDetails", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("AuditScheduleId")
                        .HasColumnType("int");

                    b.Property<DateTime>("EndDateTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("OfficeId")
                        .HasColumnType("int");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.Property<DateTime>("StartDateTime")
                        .HasColumnType("datetime2");

                    b.Property<int>("TeamId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("AuditScheduleId");

                    b.HasIndex("OfficeId");

                    b.HasIndex("TeamId");

                    b.ToTable("AuditScheduleDetails");
                });

            modelBuilder.Entity("IMIS.Domain.AuditableOffices", b =>
                {
                    b.Property<int>("AuditScheduleId")
                        .HasColumnType("int");

                    b.Property<int>("OfficeId")
                        .HasColumnType("int");

                    b.HasKey("AuditScheduleId", "OfficeId");

                    b.HasIndex("OfficeId");

                    b.ToTable("AuditableOffices");
                });

            modelBuilder.Entity("IMIS.Domain.Auditor", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<bool>("IsActive")
                        .HasColumnType("bit");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.HasKey("Id");

                    b.ToTable("Auditors");
                });

            modelBuilder.Entity("IMIS.Domain.AuditorOffices", b =>
                {
                    b.Property<int>("AuditorId")
                        .HasColumnType("int");

                    b.Property<int>("OfficeId")
                        .HasColumnType("int");

                    b.Property<bool>("IsOfficeHead")
                        .HasColumnType("bit");

                    b.HasKey("AuditorId", "OfficeId");

                    b.HasIndex("OfficeId");

                    b.ToTable("AuditorOffices");
                });

            modelBuilder.Entity("IMIS.Domain.AuditorTeams", b =>
                {
                    b.Property<int>("AuditorId")
                        .HasColumnType("int");

                    b.Property<int>("TeamId")
                        .HasColumnType("int");

                    b.Property<bool>("IsActive")
                        .HasColumnType("bit");

                    b.Property<bool>("IsTeamLeader")
                        .HasColumnType("bit");

                    b.HasKey("AuditorId", "TeamId");

                    b.HasIndex("TeamId");

                    b.ToTable("AuditorTeams");
                });

            modelBuilder.Entity("IMIS.Domain.KeyResultArea", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Remarks")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.HasKey("Id");

                    b.ToTable("KeyResultArea");
                });

            modelBuilder.Entity("IMIS.Domain.Office", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<bool>("IsActive")
                        .HasColumnType("bit");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.HasKey("Id");

                    b.ToTable("Offices");
                });

            modelBuilder.Entity("IMIS.Domain.PgsAuditDetails", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<long>("Id"));

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("OfficeId")
                        .HasColumnType("int");

                    b.Property<int>("PgsPeriodId")
                        .HasColumnType("int");

                    b.Property<long?>("PgsReadinessRatingId")
                        .HasColumnType("bigint");

                    b.Property<string>("Remarks")
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.HasKey("Id");

                    b.HasIndex("OfficeId");

                    b.HasIndex("PgsPeriodId");

                    b.HasIndex("PgsReadinessRatingId");

                    b.ToTable("PgsAuditDetails");
                });

            modelBuilder.Entity("IMIS.Domain.PgsDeliverable", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<long>("Id"));

                    b.Property<DateTime>("ByWhen")
                        .HasColumnType("datetime2");

                    b.Property<string>("DeliverableName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<bool>("IsDirect")
                        .HasColumnType("bit");

                    b.Property<int?>("KraId")
                        .HasColumnType("int");

                    b.Property<double>("PercentDeliverables")
                        .HasColumnType("float");

                    b.Property<long?>("PgsAuditDetailsId")
                        .HasColumnType("bigint");

                    b.Property<string>("Remarks")
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.Property<int>("Status")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("KraId");

                    b.HasIndex("PgsAuditDetailsId");

                    b.ToTable("Deliverable");
                });

            modelBuilder.Entity("IMIS.Domain.PgsPeriod", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateOnly>("EndDate")
                        .HasColumnType("date");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.Property<DateOnly>("StartDate")
                        .HasColumnType("date");

                    b.HasKey("Id");

                    b.ToTable("PgsPeriod");
                });

            modelBuilder.Entity("IMIS.Domain.PgsReadinessRating", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<long>("Id"));

                    b.Property<double>("CompetenceToDeliver")
                        .HasColumnType("float");

                    b.Property<double>("ConfidenceToDeliver")
                        .HasColumnType("float");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<double>("ResourceAvailability")
                        .HasColumnType("float");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.HasKey("Id");

                    b.ToTable("PgsReadiness");
                });

            modelBuilder.Entity("IMIS.Domain.Team", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<bool>("IsActive")
                        .HasColumnType("bit");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.HasKey("Id");

                    b.ToTable("Teams");
                });

            modelBuilder.Entity("IMIS.Domain.UserOffices", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<bool>("IsActive")
                        .HasColumnType("bit");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("OfficeId")
                        .HasColumnType("int");

                    b.Property<byte[]>("RowVersion")
                        .IsConcurrencyToken()
                        .ValueGeneratedOnAddOrUpdate()
                        .HasColumnType("rowversion");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("UserOffices");
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityRole", b =>
                {
                    b.Property<string>("Id")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("ConcurrencyStamp")
                        .IsConcurrencyToken()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Name")
                        .HasMaxLength(256)
                        .HasColumnType("nvarchar(256)");

                    b.Property<string>("NormalizedName")
                        .HasMaxLength(256)
                        .HasColumnType("nvarchar(256)");

                    b.HasKey("Id");

                    b.HasIndex("NormalizedName")
                        .IsUnique()
                        .HasDatabaseName("RoleNameIndex")
                        .HasFilter("[NormalizedName] IS NOT NULL");

                    b.ToTable("AspNetRoles", (string)null);

                    b.HasData(
                        new
                        {
                            Id = "56996e97-9e8a-4d22-a693-c865144e9b96",
                            ConcurrencyStamp = "44106d71-d006-4ee9-b594-0f7e83b536a7",
                            Name = "Administrator",
                            NormalizedName = "ADMINISTRATOR"
                        },
                        new
                        {
                            Id = "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                            ConcurrencyStamp = "e393c773-a17f-4ed2-9bec-19447190f2e1",
                            Name = "PGS Manager",
                            NormalizedName = "LDNA MANAGER"
                        },
                        new
                        {
                            Id = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                            ConcurrencyStamp = "c3e331a9-f932-4382-b27c-2ecf4091ee2a",
                            Name = "PGS User",
                            NormalizedName = "LDNA USER"
                        });
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityRoleClaim<string>", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("ClaimType")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("ClaimValue")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("RoleId")
                        .IsRequired()
                        .HasColumnType("nvarchar(450)");

                    b.HasKey("Id");

                    b.HasIndex("RoleId");

                    b.ToTable("AspNetRoleClaims", (string)null);
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUser", b =>
                {
                    b.Property<string>("Id")
                        .HasColumnType("nvarchar(450)");

                    b.Property<int>("AccessFailedCount")
                        .HasColumnType("int");

                    b.Property<string>("ConcurrencyStamp")
                        .IsConcurrencyToken()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Discriminator")
                        .IsRequired()
                        .HasMaxLength(13)
                        .HasColumnType("nvarchar(13)");

                    b.Property<string>("Email")
                        .HasMaxLength(256)
                        .HasColumnType("nvarchar(256)");

                    b.Property<bool>("EmailConfirmed")
                        .HasColumnType("bit");

                    b.Property<bool>("LockoutEnabled")
                        .HasColumnType("bit");

                    b.Property<DateTimeOffset?>("LockoutEnd")
                        .HasColumnType("datetimeoffset");

                    b.Property<string>("NormalizedEmail")
                        .HasMaxLength(256)
                        .HasColumnType("nvarchar(256)");

                    b.Property<string>("NormalizedUserName")
                        .HasMaxLength(256)
                        .HasColumnType("nvarchar(256)");

                    b.Property<string>("PasswordHash")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PhoneNumber")
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("PhoneNumberConfirmed")
                        .HasColumnType("bit");

                    b.Property<string>("SecurityStamp")
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("TwoFactorEnabled")
                        .HasColumnType("bit");

                    b.Property<string>("UserName")
                        .HasMaxLength(256)
                        .HasColumnType("nvarchar(256)");

                    b.HasKey("Id");

                    b.HasIndex("NormalizedEmail")
                        .HasDatabaseName("EmailIndex");

                    b.HasIndex("NormalizedUserName")
                        .IsUnique()
                        .HasDatabaseName("UserNameIndex")
                        .HasFilter("[NormalizedUserName] IS NOT NULL");

                    b.ToTable("AspNetUsers", (string)null);

                    b.HasDiscriminator().HasValue("IdentityUser");

                    b.UseTphMappingStrategy();

                    b.HasData(
                        new
                        {
                            Id = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                            AccessFailedCount = 0,
                            ConcurrencyStamp = "79b320dc-5f4f-415b-af05-ab51d6375edb",
                            Email = "marcrejohncastillano@gmail.com",
                            EmailConfirmed = false,
                            LockoutEnabled = false,
                            NormalizedEmail = "MARCREJOHNCASTILLANO@GMAIL.COM",
                            NormalizedUserName = "REDZ1029",
                            PasswordHash = "AQAAAAIAAYagAAAAEMIrKr1Ep+Z3PsGjRUFmKJDFSfJKhA+wQTirgaKNDzT8i5PzfTiDtZiZizqyg4kcIg==",
                            PhoneNumberConfirmed = false,
                            SecurityStamp = "ff285325-fd36-4c35-bceb-2aa7c3bc6b16",
                            TwoFactorEnabled = false,
                            UserName = "redz1029"
                        },
                        new
                        {
                            Id = "176bcfeb-f12a-4d42-b790-5d2312660801",
                            AccessFailedCount = 0,
                            ConcurrencyStamp = "98e87f03-fc95-4b96-bc50-b6817aecaefe",
                            Email = "alondealexa2021@gmail.com",
                            EmailConfirmed = false,
                            LockoutEnabled = false,
                            NormalizedEmail = "ALONDEALEXA2021@GMAIL.COM",
                            NormalizedUserName = "ALYXX1988",
                            PasswordHash = "AQAAAAIAAYagAAAAEApMXUMhgG3kX02dQTXWgtUyayh/jSAnhpQzQpNnmRP6WFxk+WiDOM78NqfITPSTVA==",
                            PhoneNumberConfirmed = false,
                            SecurityStamp = "bb78a744-2e30-42fa-9c33-992d4efd4a1d",
                            TwoFactorEnabled = false,
                            UserName = "alyxx1988"
                        },
                        new
                        {
                            Id = "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                            AccessFailedCount = 0,
                            ConcurrencyStamp = "87707c99-028c-4d19-9dc1-b8e9214f5962",
                            Email = "CrossVampireNe0@gmail.com",
                            EmailConfirmed = false,
                            LockoutEnabled = false,
                            NormalizedEmail = "CROSSVAMPIRENE0@GMAIL.COM",
                            NormalizedUserName = "DARKWIZWIZ",
                            PasswordHash = "AQAAAAIAAYagAAAAEO4uHLy8DDZvZojm6H2MYBbr1+KKuvL4MgcCvBwwtLGZFz+d3A0mgi7Rpz9/bBxgMA==",
                            PhoneNumberConfirmed = false,
                            SecurityStamp = "feab78b6-e25c-49b8-a0e9-9eb1971b3acc",
                            TwoFactorEnabled = false,
                            UserName = "darkwizwiz"
                        });
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUserClaim<string>", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("ClaimType")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("ClaimValue")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasColumnType("nvarchar(450)");

                    b.HasKey("Id");

                    b.HasIndex("UserId");

                    b.ToTable("AspNetUserClaims", (string)null);
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUserLogin<string>", b =>
                {
                    b.Property<string>("LoginProvider")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("ProviderKey")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("ProviderDisplayName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasColumnType("nvarchar(450)");

                    b.HasKey("LoginProvider", "ProviderKey");

                    b.HasIndex("UserId");

                    b.ToTable("AspNetUserLogins", (string)null);
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUserRole<string>", b =>
                {
                    b.Property<string>("UserId")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("RoleId")
                        .HasColumnType("nvarchar(450)");

                    b.HasKey("UserId", "RoleId");

                    b.HasIndex("RoleId");

                    b.ToTable("AspNetUserRoles", (string)null);

                    b.HasData(
                        new
                        {
                            UserId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                            RoleId = "56996e97-9e8a-4d22-a693-c865144e9b96"
                        },
                        new
                        {
                            UserId = "176bcfeb-f12a-4d42-b790-5d2312660801",
                            RoleId = "56996e97-9e8a-4d22-a693-c865144e9b96"
                        },
                        new
                        {
                            UserId = "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                            RoleId = "56996e97-9e8a-4d22-a693-c865144e9b96"
                        });
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUserToken<string>", b =>
                {
                    b.Property<string>("UserId")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("LoginProvider")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("Name")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("Value")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("UserId", "LoginProvider", "Name");

                    b.ToTable("AspNetUserTokens", (string)null);
                });

            modelBuilder.Entity("IMIS.Domain.User", b =>
                {
                    b.HasBaseType("Microsoft.AspNetCore.Identity.IdentityUser");

                    b.Property<string>("FirstName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("LastName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("MiddleName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Position")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Prefix")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Suffix")
                        .HasColumnType("nvarchar(max)");

                    b.ToTable("AspNetUsers", (string)null);

                    b.HasDiscriminator().HasValue("User");
                });

            modelBuilder.Entity("IMIS.Domain.AuditScheduleDetails", b =>
                {
                    b.HasOne("IMIS.Domain.AuditSchedule", "AuditSchedule")
                        .WithMany("AuditSchduleDetails")
                        .HasForeignKey("AuditScheduleId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("IMIS.Domain.Office", "Office")
                        .WithMany()
                        .HasForeignKey("OfficeId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("IMIS.Domain.Team", "Team")
                        .WithMany()
                        .HasForeignKey("TeamId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("AuditSchedule");

                    b.Navigation("Office");

                    b.Navigation("Team");
                });

            modelBuilder.Entity("IMIS.Domain.AuditableOffices", b =>
                {
                    b.HasOne("IMIS.Domain.AuditSchedule", "AuditSchedule")
                        .WithMany("AuditableOffices")
                        .HasForeignKey("AuditScheduleId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("IMIS.Domain.Office", "Office")
                        .WithMany("AuditableOffices")
                        .HasForeignKey("OfficeId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("AuditSchedule");

                    b.Navigation("Office");
                });

            modelBuilder.Entity("IMIS.Domain.AuditorOffices", b =>
                {
                    b.HasOne("IMIS.Domain.Auditor", "Auditor")
                        .WithMany("AuditorOffices")
                        .HasForeignKey("AuditorId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("IMIS.Domain.Office", "Office")
                        .WithMany("AuditorOffices")
                        .HasForeignKey("OfficeId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Auditor");

                    b.Navigation("Office");
                });

            modelBuilder.Entity("IMIS.Domain.AuditorTeams", b =>
                {
                    b.HasOne("IMIS.Domain.Auditor", "Auditor")
                        .WithMany("AuditorTeams")
                        .HasForeignKey("AuditorId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("IMIS.Domain.Team", "Team")
                        .WithMany("AuditorTeams")
                        .HasForeignKey("TeamId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Auditor");

                    b.Navigation("Team");
                });

            modelBuilder.Entity("IMIS.Domain.PgsAuditDetails", b =>
                {
                    b.HasOne("IMIS.Domain.Office", "Office")
                        .WithMany()
                        .HasForeignKey("OfficeId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("IMIS.Domain.PgsPeriod", "PgsPeriod")
                        .WithMany()
                        .HasForeignKey("PgsPeriodId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("IMIS.Domain.PgsReadinessRating", "PgsReadinessRating")
                        .WithMany()
                        .HasForeignKey("PgsReadinessRatingId");

                    b.Navigation("Office");

                    b.Navigation("PgsPeriod");

                    b.Navigation("PgsReadinessRating");
                });

            modelBuilder.Entity("IMIS.Domain.PgsDeliverable", b =>
                {
                    b.HasOne("IMIS.Domain.KeyResultArea", "Kra")
                        .WithMany()
                        .HasForeignKey("KraId");

                    b.HasOne("IMIS.Domain.PgsAuditDetails", null)
                        .WithMany("PgsDeliverables")
                        .HasForeignKey("PgsAuditDetailsId");

                    b.Navigation("Kra");
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityRoleClaim<string>", b =>
                {
                    b.HasOne("Microsoft.AspNetCore.Identity.IdentityRole", null)
                        .WithMany()
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUserClaim<string>", b =>
                {
                    b.HasOne("Microsoft.AspNetCore.Identity.IdentityUser", null)
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUserLogin<string>", b =>
                {
                    b.HasOne("Microsoft.AspNetCore.Identity.IdentityUser", null)
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUserRole<string>", b =>
                {
                    b.HasOne("Microsoft.AspNetCore.Identity.IdentityRole", null)
                        .WithMany()
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Microsoft.AspNetCore.Identity.IdentityUser", null)
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("Microsoft.AspNetCore.Identity.IdentityUserToken<string>", b =>
                {
                    b.HasOne("Microsoft.AspNetCore.Identity.IdentityUser", null)
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("IMIS.Domain.AuditSchedule", b =>
                {
                    b.Navigation("AuditSchduleDetails");

                    b.Navigation("AuditableOffices");
                });

            modelBuilder.Entity("IMIS.Domain.Auditor", b =>
                {
                    b.Navigation("AuditorOffices");

                    b.Navigation("AuditorTeams");
                });

            modelBuilder.Entity("IMIS.Domain.Office", b =>
                {
                    b.Navigation("AuditableOffices");

                    b.Navigation("AuditorOffices");
                });

            modelBuilder.Entity("IMIS.Domain.PgsAuditDetails", b =>
                {
                    b.Navigation("PgsDeliverables");
                });

            modelBuilder.Entity("IMIS.Domain.Team", b =>
                {
                    b.Navigation("AuditorTeams");
                });
#pragma warning restore 612, 618
        }
    }
}
