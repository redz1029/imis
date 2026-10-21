using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Application.StrategyReviewModule
{
    public class StrategyReviewOfficesDto
    {
        public long StrategyReviewId { get; set; }
        public long KraRoadMapId { get; set; }
        public string? StrategicObjective { get; set; }
        public List<string> OfficeNames { get; set; } = new();
    }
}
