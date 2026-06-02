namespace IMIS.Application.KraRoadmapCoreSupportProcessModule
{
    public class KraProcessGroupedDto
    {
        public int ProcessId { get; set; }
        public string? ProcessName { get; set; }
        public List<ReportKraDto> Kras { get; set; } = new();

        private (string? kraName, string? strategicObjective, string? kpiDesc, string? target, string? baseline) GetKpiProperty(ReportKraDto? kra, int overallIndex)
        {
            if (kra == null)
                return (null, null, null, null, null);

            int count = 0;
            if (kra.Kpis == null || kra.Kpis.Count == 0)
                return (kra.Name, kra.StrategicObjective, null, null, null);

            foreach (var kpi in kra.Kpis)
            {
                for (int i = 0; i < 5; i++)
                {
                    count++;
                    if (count == overallIndex)
                        return (kra.Name, kra.StrategicObjective, kpi.KpiDescription, kpi.Target, kpi.BaseLine);
                }
            }

            return (kra.Name, kra.StrategicObjective, null, null, null);
        }
      
        // =====================================================
        // SERVICE KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? ServiceKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Service);
        public string? Service_KraName1 => GetKpiProperty(ServiceKra!, 1).kraName;
        public string? Service_StrategicObjective1 => GetKpiProperty(ServiceKra!, 1).strategicObjective;       
        public int Service_Year1 => ServiceKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int Service_Year2 => ServiceKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int Service_Year3 => ServiceKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int Service_Year4 => ServiceKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int Service_Year5 => ServiceKra?.Years?.ElementAtOrDefault(4) ?? 0;

        // =====================================================
        // TRAINING KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? TrainingKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Training);
        public string? Training_KraName1 => GetKpiProperty(TrainingKra!, 1).kraName;
        public string? Training_StrategicObjective1 => GetKpiProperty(TrainingKra!, 1).strategicObjective;
        
        // =====================================================
        // RESEARCH KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? ResearchKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Research);
        public string? Research_KraName1 => GetKpiProperty(ResearchKra!, 1).kraName;
        public string? Research_StrategicObjective1 => GetKpiProperty(ResearchKra!, 1).strategicObjective;
       
        // =====================================================
        // LINKAGES KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? LinkagesKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Linkages);
        public string? Linkages_KraName1 => GetKpiProperty(LinkagesKra!, 1).kraName;
        public string? Linkages_StrategicObjective1 => GetKpiProperty(LinkagesKra!, 1).strategicObjective;       

        // =====================================================
        // SAFETY KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? safetyKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Safety);
        public string? safety_KraName1 => GetKpiProperty(safetyKra!, 1).kraName;
        public string? safety_StrategicObjective1 => GetKpiProperty(safetyKra!, 1).strategicObjective;
       
        // =====================================================
        // HUMAN RESOURCE KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? HumanResourceKra => Kras.FirstOrDefault(k => k.Id == KraStatus.HumanResource);
        public string? HumanResourceKra_KraName1 => GetKpiProperty(HumanResourceKra!, 1).kraName;
        public string? HumanResourceKra_StrategicObjective1 => GetKpiProperty(HumanResourceKra!, 1).strategicObjective;       
        public int HumanResourceKra_Year1 => HumanResourceKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int HumanResourceKra_Year2 => HumanResourceKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int HumanResourceKra_Year3 => HumanResourceKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int HumanResourceKra_Year4 => HumanResourceKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int HumanResourceKra_Year5 => HumanResourceKra?.Years?.ElementAtOrDefault(4) ?? 0;


        // =====================================================
        // INFRASTRUCTURE KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? InfrastructureKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Infrastructure);
        public string? Infrastructure_KraName1 => GetKpiProperty(InfrastructureKra!, 1).kraName;
        public string? Infrastructure_StrategicObjective1 => GetKpiProperty(InfrastructureKra!, 1).strategicObjective;
        
        // =====================================================
        // INFORMATION CAPITAL KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? InformationCapitalKra => Kras.FirstOrDefault(k => k.Id == KraStatus.InformationCapital);
        public string? InformationCapital_KraName1 => GetKpiProperty(InformationCapitalKra!, 1).kraName;
        public string? InformationCapital_StrategicObjective1 => GetKpiProperty(InformationCapitalKra!, 1).strategicObjective;
       
        // =====================================================
        // FINANCIAL STEWARDSHIP KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? FinacialStewardshipKra => Kras.FirstOrDefault(k => k.Id == KraStatus.FinacialStewardship);
        public string? FinacialStewardship_KraName1 => GetKpiProperty(FinacialStewardshipKra!, 1).kraName;
        public string? FinacialStewardship_StrategicObjective1 => GetKpiProperty(FinacialStewardshipKra!, 1).strategicObjective;
       
        // -------------------- Dynamic Lists per KRA --------------------
        public List<ReportKraDto.ReportKraRowDto> ServiceList =>
            ServiceKra?.BuildList(KraStatus.Service) ?? new List<ReportKraDto.ReportKraRowDto>();

        public List<ReportKraDto.ReportKraRowDto> ResearchList =>
            ResearchKra?.BuildList(KraStatus.Research) ?? new List<ReportKraDto.ReportKraRowDto>();

        public List<ReportKraDto.ReportKraRowDto> TrainingList =>
            TrainingKra?.BuildList(KraStatus.Training) ?? new List<ReportKraDto.ReportKraRowDto>();

        public List<ReportKraDto.ReportKraRowDto> LinkagesList =>
            LinkagesKra?.BuildList(KraStatus.Linkages) ?? new List<ReportKraDto.ReportKraRowDto>();

        public List<ReportKraDto.ReportKraRowDto> InfrastructureList =>
            InfrastructureKra?.BuildList(KraStatus.Infrastructure) ?? new List<ReportKraDto.ReportKraRowDto>();

        public List<ReportKraDto.ReportKraRowDto> FinancialStewardshipList =>
            FinacialStewardshipKra?.BuildList(KraStatus.FinacialStewardship) ?? new List<ReportKraDto.ReportKraRowDto>();

        public List<ReportKraDto.ReportKraRowDto> InformationCapitalList =>
            InformationCapitalKra?.BuildList(KraStatus.InformationCapital) ?? new List<ReportKraDto.ReportKraRowDto>();

        public List<ReportKraDto.ReportKraRowDto> HumanResourceList =>
            HumanResourceKra?.BuildList(KraStatus.HumanResource) ?? new List<ReportKraDto.ReportKraRowDto>();

        public List<ReportKraDto.ReportKraRowDto> SafetyList =>
            safetyKra?.BuildList(KraStatus.Safety) ?? new List<ReportKraDto.ReportKraRowDto>();

    }
}



