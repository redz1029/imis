using Base.Pagination;
using Base.Primitives;
using Base.Utilities;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Domain;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.OperationReviewProtocolModule
{
    public class OperationReviewProtocolService : IOperationReviewProtocolService
    {

        private readonly IOperationReviewProtocolRepository _repository;     
        private readonly UserManager<User> _userManager;
        private readonly string _ftpBasePath;

        public OperationReviewProtocolService(IOperationReviewProtocolRepository repository, UserManager<User> userManager)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _ftpBasePath = $"{FTPCredentials.FTPRootFolderPath}/sample";
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entities == null)
                return false;

            entities.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<List<ORPPgsDeliverableAccomplishmentDto>> GetDeliverableByIdAsync(long id, int month, int year, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetDeliverableByIdAsync(id, month, year, cancellationToken);

            if (entities == null || !entities.Any())
                return new List<ORPPgsDeliverableAccomplishmentDto>();

            return entities
                .Select(a => new ORPPgsDeliverableAccomplishmentDto(a))
                .ToList();
        }
    
        public async Task<ReportOperationReviewProtocolDto?> ReportGetByIdAsync(long operationReviewProtocolId, long pgsId, int month, int year, CancellationToken cancellationToken)
        {
            var orp = await _repository.ReportGetByIdAsync(operationReviewProtocolId, cancellationToken).ConfigureAwait(false);

            if (orp == null)
                return null;

            var accomplishments = await _repository.GetDeliverableByIdAsync(pgsId, month, year, cancellationToken).ConfigureAwait(false);

            var dto = new ReportOperationReviewProtocolDto(orp, accomplishments);

            if (!string.IsNullOrWhiteSpace(orp.MinutesAttachmentPath))
            {
                try
                {
                    var fileName = Path.GetFileName(orp.MinutesAttachmentPath);
                    var extension = Path.GetExtension(fileName).ToLowerInvariant();

                    var fileBytes = await FTPHelper
                        .DownloadAsync(_ftpBasePath, fileName, cancellationToken)
                        .ConfigureAwait(false);

                    if (extension == ".pdf")
                    {
                        dto.MinutesImages = PdfHelper.ConvertPdfToImages(fileBytes)
                        .Select(x => new MinutesImageDto
                        {
                            Image = x
                        })
                        .ToList();
                    }
                    else
                    {
                        dto.MinutesImages = new List<MinutesImageDto>
                        {
                            new MinutesImageDto
                            {
                                Image = fileBytes
                            }
                        };
                    }
                }
                catch
                {
                    dto.MinutesImages = new List<MinutesImageDto>();
                }
            }

            return dto;
        }
        public async Task<List<OperationReviewProtocolDto>?> GetAll(long? performanceGovernanceSystemId, CancellationToken cancellationToken)
        {
            var data = await _repository.GetAll(performanceGovernanceSystemId, cancellationToken).ConfigureAwait(false);

            return data?.Select(a => new OperationReviewProtocolDto(a)).ToList();
        }       
        public async Task<DtoPageList<OperationReviewProtocolDto, OperationReviewProtocol, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var operationReviewProtocolDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (operationReviewProtocolDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<OperationReviewProtocolDto, OperationReviewProtocol, long>.Create(operationReviewProtocolDto.Items, page, pageSize, operationReviewProtocolDto.TotalCount);
        }

        public async Task<OperationReviewProtocolDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            return entity == null ? null : new OperationReviewProtocolDto(entity);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is OperationReviewProtocolDto operationReviewProtocolDto)
            {
                var protocol = operationReviewProtocolDto.ToEntity();

                if (protocol.Id == 0)
                    _repository.Add(protocol);
                else
                    await _repository.UpdateAsync(protocol, protocol.Id, cancellationToken)
                        .ConfigureAwait(false);

                await _repository.SaveOrUpdateAsync(protocol, cancellationToken)
                    .ConfigureAwait(false);

            }
        }
    }
}
