using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableScoreHistoryModule
{
    public interface IPgsDeliverableScoreHistoryRepository : IRepository<PgsDeliverableScoreHistory, long>
    {
        Task<IEnumerable<PgsDeliverableScoreHistory>> GetAll(CancellationToken cancellationToken);
        new Task<PgsDeliverableScoreHistory> SaveOrUpdateAsync(PgsDeliverableScoreHistory pgsDeliverableScoreHistory, CancellationToken cancellationToken);
    }
}
