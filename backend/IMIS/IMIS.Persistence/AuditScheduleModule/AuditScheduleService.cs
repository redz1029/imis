using Base.Primitives;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.TeamModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditScheduleModule
{
    public class AuditScheduleService(IAuditScheduleRepository auditScheduleRepository, ITeamRepository teamRepository) : IAuditScheduleService
    {
        private readonly IAuditScheduleRepository _auditScheduleRepository = auditScheduleRepository;
        private readonly ITeamRepository _teamRepository = teamRepository;
        public async Task<AuditScheduleDto?> GenerateAuditScheduleDetail(int auditScheduleId, double noOfHoursPerAudit, CancellationToken cancellationToken)
        {
            var auditSchedule = await _auditScheduleRepository.GetByIdAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);
            if (auditSchedule != null)
            {
                TimeSpan workingDayStart = new(8, 0, 0);  // 8 AM
                TimeSpan workingDayEnd = new(17, 0, 0);   // 5 PM
                TimeSpan lunchBreakStart = new(12, 0, 0); // 12 PM
                TimeSpan lunchBreakEnd = new(13, 0, 0);   // 1 PM

                int noOfAuditableOffices = auditSchedule.AuditableOffices == null ? 0 : auditSchedule.AuditableOffices.Count();
                var teams = await _teamRepository.GetAllActiveAsync(cancellationToken).ConfigureAwait(false);
                int noOfTeams = teams.Count();

                int noOfOfficesToAuditPerTeam = Math.Abs(noOfAuditableOffices / noOfTeams);

                int noOfOfficesToSchedule = 0;
                double totalAuditHours = CalculateWorkingHours(auditSchedule.StartDate, auditSchedule.EndDate, workingDayStart, workingDayEnd, lunchBreakStart, lunchBreakEnd);

                double totalAvailableAuditorHours = noOfTeams * totalAuditHours;
                double totalRequiredAuditHours = noOfAuditableOffices * noOfHoursPerAudit;
                int noOfParallelAudits = (int)Math.Abs(totalRequiredAuditHours / totalAuditHours);

                int noOfParallelAuditsBeingScheduled = 0;
                List<AuditScheduleDetails> auditScheduleDetails = [];
                do
                {
                    // start the scheduling
                    DateTime initialAuditEndDate = auditSchedule.StartDate.AddHours(noOfHoursPerAudit);

                    while (noOfParallelAuditsBeingScheduled < noOfParallelAudits)
                    {
                        var auditDetail = new AuditScheduleDetails()
                        {
                            Id = 0,
                            AuditScheduleId = auditSchedule.Id,
                            AuditSchedule = auditSchedule,
                            StartDateTime = auditSchedule.StartDate,
                            EndDateTime = initialAuditEndDate,
                            TeamId = teams.Skip(noOfParallelAuditsBeingScheduled).Take(1).First().Id,
                            OfficeId = auditSchedule.AuditableOffices!.Skip(noOfParallelAuditsBeingScheduled).Take(1).First().OfficeId,
                        };

                        auditScheduleDetails.Add(auditDetail);

                        noOfParallelAuditsBeingScheduled++;
                        noOfOfficesToSchedule++;
                    }
                    
                } while (noOfOfficesToSchedule < noOfAuditableOffices);
                {
                    DateTime startDateTime = DateTime.Now;
                    DateTime endTimeOfPrevSched = auditScheduleDetails.Last().EndDateTime;

                    int noon = 12; // 12pm
                    int offDuty = 17; // 5pm

                    if(endTimeOfPrevSched.Hour != noon || endTimeOfPrevSched.Hour != offDuty)
                    {
                        startDateTime = auditScheduleDetails.Last().EndDateTime.AddHours(noOfHoursPerAudit);
                    } else
                    {
                        if (endTimeOfPrevSched.Hour == noon)
                        {
                            startDateTime = endTimeOfPrevSched.Date + lunchBreakEnd;
                        }

                        if(endTimeOfPrevSched.Hour == offDuty)
                        {
                            noOfParallelAuditsBeingScheduled = 0; // Reset here
                            startDateTime = endTimeOfPrevSched.AddDays(1) + workingDayStart;
                        }

                    }
                     
                    // TODO : checking of Conflicts
                    DateTime endDateTime = startDateTime.AddHours(noOfHoursPerAudit);
                    while (noOfParallelAuditsBeingScheduled < noOfParallelAudits)
                    {
                        var auditDetail = new AuditScheduleDetails()
                        {
                            Id = 0,
                            AuditScheduleId = auditSchedule.Id,
                            AuditSchedule = auditSchedule,
                            StartDateTime = startDateTime,
                            EndDateTime = endDateTime,
                            TeamId = teams.Skip(noOfParallelAuditsBeingScheduled).Take(1).First().Id,
                            OfficeId = auditSchedule.AuditableOffices!.Skip(noOfParallelAuditsBeingScheduled).Take(1).First().OfficeId,
                        };

                        auditScheduleDetails.Add(auditDetail);

                        noOfParallelAuditsBeingScheduled++;
                        noOfOfficesToSchedule++;
                    }
                }

                auditSchedule.AuditSchduleDetails = auditScheduleDetails;

                if(auditSchedule.Id == 0)
                    _auditScheduleRepository.Add(auditSchedule);

                await _auditScheduleRepository
                    .SaveOrUpdateAsync(auditSchedule, cancellationToken)
                    .ConfigureAwait(false);

                return new AuditScheduleDto()
                {
                    Id = auditSchedule.Id,
                    AuditTitle = auditSchedule.AuditTitle,
                    StartDate = auditSchedule.StartDate,
                    EndDate = auditSchedule.EndDate,
                    IsActive = auditSchedule.IsActive,
                    AuditSchduleDetails = auditSchedule.AuditSchduleDetails.Select(a => new AuditScheduleDetailDto()
                    {
                        Id = a.Id,
                        AuditScheduleId = a.AuditScheduleId,
                        OfficeId = a.OfficeId,
                        OfficeName = a.Office!.Name,
                        TeamId = a.TeamId,
                        TeamName = a.Team!.Name,
                        StartDateTime = a.StartDateTime,
                        EndDateTime = a.EndDateTime,
                    }).ToList(),
                };
            }
            return null;
        }

        private static double CalculateWorkingHours(DateTime startDate, DateTime endDate, 
            TimeSpan workingDayStart, TimeSpan workingDayEnd, TimeSpan lunchBreakStart, TimeSpan lunchBreakEnd)
        {
            double totalHours = 0;

            for (DateTime date = startDate; date < endDate; date = date.AddDays(1))
            {
                if (date.DayOfWeek == DayOfWeek.Saturday || date.DayOfWeek == DayOfWeek.Sunday)
                    continue; // Skip weekends

                DateTime dayStart = date.Date + workingDayStart;
                DateTime dayEnd = date.Date + workingDayEnd;

                DateTime currentStart = date > dayStart ? date : dayStart;
                DateTime currentEnd = date.AddDays(1) < dayEnd ? date.AddDays(1) : dayEnd;

                if (currentStart >= currentEnd)
                    continue;

                // Subtract lunch break
                if (currentStart < date.Date + lunchBreakEnd && currentEnd > date.Date + lunchBreakStart)
                {
                    DateTime lunchStart = date.Date + lunchBreakStart;
                    DateTime lunchEnd = date.Date + lunchBreakEnd;

                    if (currentStart < lunchStart)
                        totalHours += (lunchStart - currentStart).TotalHours;

                    if (currentEnd > lunchEnd)
                        totalHours += (currentEnd - lunchEnd).TotalHours;
                }
                else
                {
                    totalHours += (currentEnd - currentStart).TotalHours;
                }
            }

            // Handle the last day separately
            if (endDate.DayOfWeek != DayOfWeek.Saturday && endDate.DayOfWeek != DayOfWeek.Sunday)
            {
                DateTime lastDayStart = endDate.Date + workingDayStart;
                DateTime lastDayEnd = endDate.Date + workingDayEnd;

                DateTime currentStart = startDate > lastDayStart ? startDate : lastDayStart;
                DateTime currentEnd = endDate < lastDayEnd ? endDate : lastDayEnd;

                if (currentStart < currentEnd)
                {
                    // Subtract lunch break
                    if (currentStart < endDate.Date + lunchBreakEnd && currentEnd > endDate.Date + lunchBreakStart)
                    {
                        DateTime lunchStart = endDate.Date + lunchBreakStart;
                        DateTime lunchEnd = endDate.Date + lunchBreakEnd;

                        if (currentStart < lunchStart)
                            totalHours += (lunchStart - currentStart).TotalHours;

                        if (currentEnd > lunchEnd)
                            totalHours += (currentEnd - lunchEnd).TotalHours;
                    }
                    else
                    {
                        totalHours += (currentEnd - currentStart).TotalHours;
                    }
                }
            }

            return totalHours;
        }

        public async Task<List<AuditScheduleDto>?> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            var auditSchedules = await _auditScheduleRepository
                .GetAllActiveAsync(cancellationToken)
                .ConfigureAwait(false);

            return auditSchedules?.Select(a => 
                new AuditScheduleDto() 
                { 
                    Id = a.Id, 
                    AuditTitle = a.AuditTitle, 
                    StartDate = a.StartDate, 
                    EndDate = a.EndDate, 
                    IsActive = a.IsActive }
                ).ToList();
        }

        public async Task<List<AuditScheduleDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var auditSchedules = await _auditScheduleRepository
                .GetAllAsync(cancellationToken)
                .ConfigureAwait(false);

            return auditSchedules?.Select(a =>
                new AuditScheduleDto()
                {
                    Id = a.Id,
                    AuditTitle = a.AuditTitle,
                    StartDate = a.StartDate,
                    EndDate = a.EndDate,
                    IsActive = a.IsActive
                }
                ).ToList();
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var aDto = dto as AuditScheduleDto;
            var auditSchedule = aDto?.ToEntity();
            if (auditSchedule != null)
            {
                if(aDto!.Offices != null)
                {
                    // Assign offices
                    List<AuditableOffices> offices = [];
                    foreach(var officeDto in aDto!.Offices)
                    {
                        var office = new Office() 
                        { 
                            Id = officeDto.Id, 
                            Name = officeDto.Name, 
                            IsActive = officeDto.IsActive 
                        };

                        object value = _auditScheduleRepository.GetDbContext().Attach(office);
                        offices.Add(new AuditableOffices() 
                        { 
                            AuditSchedule = auditSchedule, 
                            AuditScheduleId = auditSchedule.Id, 
                            Office = office, 
                            OfficeId = office.Id 
                        });
                    }
                    auditSchedule.AuditableOffices = offices;
                }
                if(auditSchedule.Id == 0)
                {
                    _auditScheduleRepository.Add(auditSchedule);
                } else
                {
                    await _auditScheduleRepository.UpdateAsync(auditSchedule, auditSchedule.Id, cancellationToken).ConfigureAwait(false);
                }
                await _auditScheduleRepository.SaveOrUpdateAsync(auditSchedule, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}
