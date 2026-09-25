using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ISATStrategyContributionModule
{
    public class ISATStrategyContributionDto : BaseDto<ISATStrategyContribution, long>
    {
        public long ISATId { get; set; }
        public long? PgsDeliverableId { get; set; }
        public string? PgsDeliverableName { get; set; }
        public DateTime? PostingDate { get; set; }

        public ISATStrategyContributionDto()
        {
        }

        [SetsRequiredMembers]
        public ISATStrategyContributionDto(ISATStrategyContribution ISATStrategyContribution)
        {
            this.Id = ISATStrategyContribution.Id;
            this.ISATId = ISATStrategyContribution.ISATId;
            this.PgsDeliverableId = ISATStrategyContribution.PgsDeliverableId;
            this.PostingDate = ISATStrategyContribution.PostingDate;
            this.PgsDeliverableName = ISATStrategyContribution.PgsDeliverable?.DeliverableName;

        }
        public override ISATStrategyContribution ToEntity()
        {
            return new ISATStrategyContribution()
            {
                Id = Id,
                ISATId = ISATId,
                PgsDeliverableId = PgsDeliverableId,
                PostingDate = PostingDate,            
            };
        }
    }
}
