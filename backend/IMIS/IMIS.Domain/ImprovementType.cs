using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Base.Primitives;

namespace IMIS.Domain
{
    public class ImprovementType : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public ICollection<Auditor>? Auditors { get; set; }
    }
}
