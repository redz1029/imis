using Base.Primitives;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Domain
{
    public class Team : Entity<int>
    {
        public required string Name { get; set; }
        public required string IsActive { get; set; }
    }
}
