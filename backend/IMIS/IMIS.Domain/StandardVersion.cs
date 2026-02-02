using Base.Primitives;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Domain
{
    public class StandardVersion : Entity<int>
    {
        public required string VersionName { get; set; }

        public required bool isActive { get; set; }

        public List<IsoStandard>? IsoStandards { get; set; }
    }
}
