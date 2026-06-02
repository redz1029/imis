using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Application.KraRoadMapModule
{
    public class KraDeliverableItemDto
    {
        public long Id { get; set; }
        public string? KraDescription { get; set; }
        public string? DeliverableDescription { get; set; }
        public int Year { get; set; }
        public bool IsEnabler { get; set; }
        public bool IsDeleted { get; set; }
        public byte[]? RowVersion { get; set; }
    }
}
