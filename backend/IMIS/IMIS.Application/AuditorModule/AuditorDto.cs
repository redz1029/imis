using Base.Primitives;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Application.AuditorModule
{
    public class AuditorDto : BaseDto<Auditor, int>
    {
        public string Name {  get; set; }
        public bool IsActive { get; set; }
        [Timestamp]
        public virtual byte[]? RowVersion { get; init; }

        public AuditorDto() { }

        [SetsRequiredMembers]
        public AuditorDto(Auditor auditor)
        {
            if(auditor != null)
            {
                Id = auditor.Id;
                Name = auditor.Name;
                IsActive = auditor.IsActive;
                RowVersion = auditor.RowVersion;
            }
        }

        public override Auditor ToEntity()
        {
            return new Auditor() { Id = Id, Name = Name, IsActive = IsActive };
        }
    }
}
