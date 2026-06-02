using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryModule
{
    public interface IPgsSignatoryRepository : IRepository<PgsSignatory, long>
    { 
    }
}
  