using Base.Primitives;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Domain
{
    public class IsoStandardAuditPlan : Entity<int>
    {
        public required int? IsoStandardId { get; set; }
        public IsoStandard? IsoStandard { get; set; }

        public required int? AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }

    }
}
