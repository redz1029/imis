﻿using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using static IMIS.Application.PgsModule.PgsAuditDetailsDto;

namespace IMIS.Application.PgsKraModule
{
 
    public interface IKeyResultAreaService : IService
    {     
        public Task<DtoPageList<KeyResultAreaDto, KeyResultArea, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<KeyResultAreaDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<KeyResultAreaDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<KeyResultAreaDto> SaveOrUpdateAsync(KeyResultAreaDto KraDto, CancellationToken cancellationToken);
        Task<List<KeyResultAreaDto>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
    }
}

