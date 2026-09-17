using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditeeModule
{
    public class AuditeeDto : BaseDto<Auditee, int>
    {
        public required string Name { get; set; }
        public required string UserId { get; set; }
        public string? UserEmail { get; set; }
        public string? FullName { get; set; }

        public AuditeeDto() { }   

        [SetsRequiredMembers]
        public AuditeeDto(Auditee entity)
        {
            if (entity != null)
            {
                Id = entity.Id;
                Name = entity.Name;
                UserId = entity.UserId;

                if (entity.User != null)
                {
                    UserEmail = entity.User.Email;
                    FullName = $"{entity.User.Prefix} {entity.User.FirstName} {entity.User.LastName} {entity.User.Suffix}".Trim();
                }
            }
        }

        public override Auditee ToEntity()
        {
            return new Auditee
            {
                Id = (int)Id,
                Name = Name,
                UserId = UserId,
                User = null! // Handled by EF Core tracking during persistence
            };
        }
    }
}