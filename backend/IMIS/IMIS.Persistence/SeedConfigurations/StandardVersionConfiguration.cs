using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Persistence.SeedConfigurations
{
    public class StandardVersionConfiguration : IEntityTypeConfiguration<StandardVersion>
    {
        public void Configure(EntityTypeBuilder<StandardVersion> builder)
        {
            builder.HasData(
                new StandardVersion
                {
                    Id = 1,
                    VersionName = "ISO 9001:2015",
                    isActive = true
                }
            );
        }
    }
}
