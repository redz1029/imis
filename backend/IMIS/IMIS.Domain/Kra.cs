﻿using Base.Primitives;

namespace IMIS.Domain
{
    public class Kra : Entity<int>
    {
        public required string Name { get; set; }     
        public required string Remarks { get; set; } 

    }
}
