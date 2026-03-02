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

        private decimal GetPercent(ReportKraDto? kra, int overallIndex)
        {
            if (kra == null || kra.Kpis == null || kra.Kpis.Count == 0)
                return 0;

            int count = 0;
            foreach (var kpi in kra.Kpis)
            {
                for (int i = 0; i < 5; i++)
                {
                    count++;
                    if (count == overallIndex)
                        return kpi.PercentAccomplished?.ElementAtOrDefault(i) ?? 0;
                }
            }

            return 0;
        }

        // =====================================================
        // SERVICE KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? ServiceKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Service);
        public string? Service_KraName1 => GetKpiProperty(ServiceKra!, 1).kraName;
        public string? Service_StrategicObjective1 => GetKpiProperty(ServiceKra!, 1).strategicObjective;
        public string? Service_KpiDescription1 => GetKpiProperty(ServiceKra!, 1).kpiDesc;
        public string? Service_Target1 => GetKpiProperty(ServiceKra!, 1).target;
        public string? Service_BaseLine1 => GetKpiProperty(ServiceKra!, 1).baseline;
        public decimal Service_PercentAccomplished1 => GetPercent(ServiceKra!, 1);
        public decimal Service_PercentAccomplished2 => GetPercent(ServiceKra!, 2);
        public decimal Service_PercentAccomplished3 => GetPercent(ServiceKra!, 3);
        public decimal Service_PercentAccomplished4 => GetPercent(ServiceKra!, 4);
        public decimal Service_PercentAccomplished5 => GetPercent(ServiceKra!, 5);
        public string? Service_KraName2 => GetKpiProperty(ServiceKra!, 6).kraName;
        public string? Service_StrategicObjective2 => GetKpiProperty(ServiceKra!, 6).strategicObjective;
        public string? Service_KpiDescription2 => GetKpiProperty(ServiceKra!, 6).kpiDesc;
        public string? Service_Target2 => GetKpiProperty(ServiceKra!, 6).target;
        public string? Service_BaseLine2 => GetKpiProperty(ServiceKra!, 6).baseline;
        public decimal Service_PercentAccomplished6 => GetPercent(ServiceKra!, 6);
        public decimal Service_PercentAccomplished7 => GetPercent(ServiceKra!, 7);
        public decimal Service_PercentAccomplished8 => GetPercent(ServiceKra!, 8);
        public decimal Service_PercentAccomplished9 => GetPercent(ServiceKra!, 9);
        public decimal Service_PercentAccomplished10 => GetPercent(ServiceKra!, 10);
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
        public string? Training_KpiDescription1 => GetKpiProperty(TrainingKra!, 1).kpiDesc;
        public string? Training_Target1 => GetKpiProperty(TrainingKra!, 1).target;
        public string? Training_BaseLine1 => GetKpiProperty(TrainingKra!, 1).baseline;
        public decimal Training_PercentAccomplished1 => GetPercent(TrainingKra!, 1);
        public decimal Training_PercentAccomplished2 => GetPercent(TrainingKra!, 2);
        public decimal Training_PercentAccomplished3 => GetPercent(TrainingKra!, 3);
        public decimal Training_PercentAccomplished4 => GetPercent(TrainingKra!, 4);
        public decimal Training_PercentAccomplished5 => GetPercent(TrainingKra!, 5);
        public string? Training_KraName2 => GetKpiProperty(TrainingKra!, 6).kraName;
        public string? Training_StrategicObjective2 => GetKpiProperty(TrainingKra!, 6).strategicObjective;
        public string? Training_KpiDescription2 => GetKpiProperty(TrainingKra!, 6).kpiDesc;
        public string? Training_Target2 => GetKpiProperty(TrainingKra!, 6).target;
        public string? Training_BaseLine2 => GetKpiProperty(TrainingKra!, 6).baseline;
        public decimal Training_PercentAccomplished6 => GetPercent(TrainingKra!, 6);
        public decimal Training_PercentAccomplished7 => GetPercent(TrainingKra!, 7);
        public decimal Training_PercentAccomplished8 => GetPercent(TrainingKra!, 8);
        public decimal Training_PercentAccomplished9 => GetPercent(TrainingKra!, 9);
        public decimal Training_PercentAccomplished10 => GetPercent(TrainingKra!, 10);
        public int Training_Year1 => TrainingKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int Training_Year2 => TrainingKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int Training_Year3 => TrainingKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int Training_Year4 => TrainingKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int Training_Year5 => TrainingKra?.Years?.ElementAtOrDefault(4) ?? 0;

        // =====================================================
        // RESEARCH KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? ResearchKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Research);
        public string? Research_KraName1 => GetKpiProperty(ResearchKra!, 1).kraName;
        public string? Research_StrategicObjective1 => GetKpiProperty(ResearchKra!, 1).strategicObjective;
        public string? Research_KpiDescription1 => GetKpiProperty(ResearchKra!, 1).kpiDesc;
        public string? Research_Target1 => GetKpiProperty(ResearchKra!, 1).target;
        public string? Research_BaseLine1 => GetKpiProperty(ResearchKra!, 1).baseline;
        public decimal Research_PercentAccomplished1 => GetPercent(ResearchKra!, 1);
        public decimal Research_PercentAccomplished2 => GetPercent(ResearchKra!, 2);
        public decimal Research_PercentAccomplished3 => GetPercent(ResearchKra!, 3);
        public decimal Research_PercentAccomplished4 => GetPercent(ResearchKra!, 4);
        public decimal Research_PercentAccomplished5 => GetPercent(ResearchKra!, 5);
        public string? Research_KraName2 => GetKpiProperty(ResearchKra!, 6).kraName;
        public string? Research_StrategicObjective2 => GetKpiProperty(ResearchKra!, 6).strategicObjective;
        public string? Research_KpiDescription2 => GetKpiProperty(ResearchKra!, 6).kpiDesc;
        public string? Research_Target2 => GetKpiProperty(ResearchKra!, 6).target;
        public string? Research_BaseLine2 => GetKpiProperty(ResearchKra!, 6).baseline;
        public decimal Research_PercentAccomplished6 => GetPercent(ResearchKra!, 6);
        public decimal Research_PercentAccomplished7 => GetPercent(ResearchKra!, 7);
        public decimal Research_PercentAccomplished8 => GetPercent(ResearchKra!, 8);
        public decimal Research_PercentAccomplished9 => GetPercent(ResearchKra!, 9);
        public decimal Research_PercentAccomplished10 => GetPercent(ResearchKra!, 10);
        public int Research_Year1 => ResearchKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int Research_Year2 => ResearchKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int Research_Year3 => ResearchKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int Research_Year4 => ResearchKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int Research_Year5 => ResearchKra?.Years?.ElementAtOrDefault(4) ?? 0;


        // =====================================================
        // LINKAGES KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? LinkagesKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Linkages);
        public string? Linkages_KraName1 => GetKpiProperty(LinkagesKra!, 1).kraName;
        public string? Linkages_StrategicObjective1 => GetKpiProperty(LinkagesKra!, 1).strategicObjective;
        public string? Linkages_KpiDescription1 => GetKpiProperty(LinkagesKra!, 1).kpiDesc;
        public string? Linkages_Target1 => GetKpiProperty(LinkagesKra!, 1).target;
        public string? Linkages_BaseLine1 => GetKpiProperty(LinkagesKra!, 1).baseline;
        public decimal Linkages_PercentAccomplished1 => GetPercent(LinkagesKra!, 1);
        public decimal Linkages_PercentAccomplished2 => GetPercent(LinkagesKra!, 2);
        public decimal Linkages_PercentAccomplished3 => GetPercent(LinkagesKra!, 3);
        public decimal Linkages_PercentAccomplished4 => GetPercent(LinkagesKra!, 4);
        public decimal Linkages_PercentAccomplished5 => GetPercent(LinkagesKra!, 5);
        public string? Linkages_KraName2 => GetKpiProperty(LinkagesKra!, 6).kraName;
        public string? Linkages_StrategicObjective2 => GetKpiProperty(LinkagesKra!, 6).strategicObjective;
        public string? Linkages_KpiDescription2 => GetKpiProperty(LinkagesKra!, 6).kpiDesc;
        public string? Linkages_Target2 => GetKpiProperty(LinkagesKra!, 6).target;
        public string? Linkages_BaseLine2 => GetKpiProperty(LinkagesKra!, 6).baseline;
        public decimal Linkages_PercentAccomplished6 => GetPercent(LinkagesKra!, 6);
        public decimal Linkages_PercentAccomplished7 => GetPercent(LinkagesKra!, 7);
        public decimal Linkages_PercentAccomplished8 => GetPercent(LinkagesKra!, 8);
        public decimal Linkages_PercentAccomplished9 => GetPercent(LinkagesKra!, 9);
        public decimal Linkages_PercentAccomplished10 => GetPercent(LinkagesKra!, 10);
        public int Linkages_Year1 => LinkagesKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int Linkages_Year2 => LinkagesKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int Linkages_Year3 => LinkagesKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int Linkages_Year4 => LinkagesKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int Linkages_Year5 => LinkagesKra?.Years?.ElementAtOrDefault(4) ?? 0;


        // =====================================================
        // SAFETY KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? safetyKra => Kras.FirstOrDefault(k => k.Id == KraStatus.Safety);
        public string? safety_KraName1 => GetKpiProperty(safetyKra!, 1).kraName;
        public string? safety_StrategicObjective1 => GetKpiProperty(safetyKra!, 1).strategicObjective;
        public string? safety_KpiDescription1 => GetKpiProperty(safetyKra!, 1).kpiDesc;
        public string? safety_Target1 => GetKpiProperty(safetyKra!, 1).target;
        public string? safety_BaseLine1 => GetKpiProperty(safetyKra!, 1).baseline;
        public decimal safety_PercentAccomplished1 => GetPercent(safetyKra!, 1);
        public decimal safety_PercentAccomplished2 => GetPercent(safetyKra!, 2);
        public decimal safety_PercentAccomplished3 => GetPercent(safetyKra!, 3);
        public decimal safety_PercentAccomplished4 => GetPercent(safetyKra!, 4);
        public decimal safety_PercentAccomplished5 => GetPercent(safetyKra!, 5);
        public string? safety_KraName2 => GetKpiProperty(safetyKra!, 6).kraName;
        public string? safety_StrategicObjective2 => GetKpiProperty(safetyKra!, 6).strategicObjective;
        public string? safety_KpiDescription2 => GetKpiProperty(safetyKra!, 6).kpiDesc;
        public string? safety_Target2 => GetKpiProperty(safetyKra!, 6).target;
        public string? safety_BaseLine2 => GetKpiProperty(safetyKra!, 6).baseline;
        public decimal safety_PercentAccomplished6 => GetPercent(safetyKra!, 6);
        public decimal safety_PercentAccomplished7 => GetPercent(safetyKra!, 7);
        public decimal safety_PercentAccomplished8 => GetPercent(safetyKra!, 8);
        public decimal safety_PercentAccomplished9 => GetPercent(safetyKra!, 9);
        public decimal safety_PercentAccomplished10 => GetPercent(safetyKra!, 10);
        public int safety_Year1 => safetyKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int safety_Year2 => safetyKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int safety_Year3 => safetyKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int safety_Year4 => safetyKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int safety_Year5 => safetyKra?.Years?.ElementAtOrDefault(4) ?? 0;


        // =====================================================
        // HUMAN RESOURCE KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? HumanResourceKra => Kras.FirstOrDefault(k => k.Id == KraStatus.HumanResource);
        public string? HumanResourceKra_KraName1 => GetKpiProperty(HumanResourceKra!, 1).kraName;
        public string? HumanResourceKra_StrategicObjective1 => GetKpiProperty(HumanResourceKra!, 1).strategicObjective;
        public string? HumanResourceKra_KpiDescription1 => GetKpiProperty(HumanResourceKra!, 1).kpiDesc;
        public string? HumanResourceKra_Target1 => GetKpiProperty(HumanResourceKra!, 1).target;
        public string? HumanResourceKra_BaseLine1 => GetKpiProperty(HumanResourceKra!, 1).baseline;
        public decimal HumanResourceKra_PercentAccomplished1 => GetPercent(HumanResourceKra!, 1);
        public decimal HumanResourceKra_PercentAccomplished2 => GetPercent(HumanResourceKra!, 2);
        public decimal HumanResourceKra_PercentAccomplished3 => GetPercent(HumanResourceKra!, 3);
        public decimal HumanResourceKra_PercentAccomplished4 => GetPercent(HumanResourceKra!, 4);
        public decimal HumanResourceKra_PercentAccomplished5 => GetPercent(HumanResourceKra!, 5);
        public string? HumanResourceKra_KraName2 => GetKpiProperty(HumanResourceKra!, 6).kraName;
        public string? HumanResourceKra_StrategicObjective2 => GetKpiProperty(HumanResourceKra!, 6).strategicObjective;
        public string? HumanResourceKra_KpiDescription2 => GetKpiProperty(HumanResourceKra!, 6).kpiDesc;
        public string? HumanResourceKra_Target2 => GetKpiProperty(HumanResourceKra!, 6).target;
        public string? HumanResourceKra_BaseLine2 => GetKpiProperty(HumanResourceKra!, 6).baseline;
        public decimal HumanResourceKra_PercentAccomplished6 => GetPercent(HumanResourceKra!, 6);
        public decimal HumanResourceKra_PercentAccomplished7 => GetPercent(HumanResourceKra!, 7);
        public decimal HumanResourceKra_PercentAccomplished8 => GetPercent(HumanResourceKra!, 8);
        public decimal HumanResourceKra_PercentAccomplished9 => GetPercent(HumanResourceKra!, 9);
        public decimal HumanResourceKra_PercentAccomplished10 => GetPercent(HumanResourceKra!, 10);
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
        public string? Infrastructure_KpiDescription1 => GetKpiProperty(InfrastructureKra!, 1).kpiDesc;
        public string? Infrastructure_Target1 => GetKpiProperty(InfrastructureKra!, 1).target;
        public string? Infrastructure_BaseLine1 => GetKpiProperty(InfrastructureKra!, 1).baseline;
        public decimal Infrastructure_PercentAccomplished1 => GetPercent(InfrastructureKra!, 1);
        public decimal Infrastructure_PercentAccomplished2 => GetPercent(InfrastructureKra!, 2);
        public decimal Infrastructure_PercentAccomplished3 => GetPercent(InfrastructureKra!, 3);
        public decimal Infrastructure_PercentAccomplished4 => GetPercent(InfrastructureKra!, 4);
        public decimal Infrastructure_PercentAccomplished5 => GetPercent(InfrastructureKra!, 5);
        public string? Infrastructure_KraName2 => GetKpiProperty(InfrastructureKra!, 6).kraName;
        public string? Infrastructure_StrategicObjective2 => GetKpiProperty(InfrastructureKra!, 6).strategicObjective;
        public string? Infrastructure_KpiDescription2 => GetKpiProperty(InfrastructureKra!, 6).kpiDesc;
        public string? Infrastructure_Target2 => GetKpiProperty(InfrastructureKra!, 6).target;
        public string? Infrastructure_BaseLine2 => GetKpiProperty(InfrastructureKra!, 6).baseline;
        public decimal Infrastructure_PercentAccomplished6 => GetPercent(InfrastructureKra!, 6);
        public decimal Infrastructure_PercentAccomplished7 => GetPercent(InfrastructureKra!, 7);
        public decimal Infrastructure_PercentAccomplished8 => GetPercent(InfrastructureKra!, 8);
        public decimal Infrastructure_PercentAccomplished9 => GetPercent(InfrastructureKra!, 9);
        public decimal Infrastructure_PercentAccomplished10 => GetPercent(InfrastructureKra!, 10);
        public int Infrastructure_Year1 => InfrastructureKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int Infrastructure_Year2 => InfrastructureKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int Infrastructure_Year3 => InfrastructureKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int Infrastructure_Year4 => InfrastructureKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int Infrastructure_Year5 => InfrastructureKra?.Years?.ElementAtOrDefault(4) ?? 0;


        // =====================================================
        // INFORMATION CAPITAL KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? InformationCapitalKra => Kras.FirstOrDefault(k => k.Id == KraStatus.InformationCapital);
        public string? InformationCapital_KraName1 => GetKpiProperty(InformationCapitalKra!, 1).kraName;
        public string? InformationCapital_StrategicObjective1 => GetKpiProperty(InformationCapitalKra!, 1).strategicObjective;
        public string? InformationCapital_KpiDescription1 => GetKpiProperty(InformationCapitalKra!, 1).kpiDesc;
        public string? InformationCapital_Target1 => GetKpiProperty(InformationCapitalKra!, 1).target;
        public string? InformationCapital_BaseLine1 => GetKpiProperty(InformationCapitalKra!, 1).baseline;
        public decimal InformationCapital_PercentAccomplished1 => GetPercent(InformationCapitalKra!, 1);
        public decimal InformationCapital_PercentAccomplished2 => GetPercent(InformationCapitalKra!, 2);
        public decimal InformationCapital_PercentAccomplished3 => GetPercent(InformationCapitalKra!, 3);
        public decimal InformationCapital_PercentAccomplished4 => GetPercent(InformationCapitalKra!, 4);
        public decimal InformationCapital_PercentAccomplished5 => GetPercent(InformationCapitalKra!, 5);
        public string? InformationCapital_KraName2 => GetKpiProperty(InformationCapitalKra!, 6).kraName;
        public string? InformationCapital_StrategicObjective2 => GetKpiProperty(InformationCapitalKra!, 6).strategicObjective;
        public string? InformationCapital_KpiDescription2 => GetKpiProperty(InformationCapitalKra!, 6).kpiDesc;
        public string? InformationCapital_Target2 => GetKpiProperty(InformationCapitalKra!, 6).target;
        public string? InformationCapital_BaseLine2 => GetKpiProperty(InformationCapitalKra!, 6).baseline;
        public decimal InformationCapital_PercentAccomplished6 => GetPercent(InformationCapitalKra!, 6);
        public decimal InformationCapital_PercentAccomplished7 => GetPercent(InformationCapitalKra!, 7);
        public decimal InformationCapital_PercentAccomplished8 => GetPercent(InformationCapitalKra!, 8);
        public decimal InformationCapital_PercentAccomplished9 => GetPercent(InformationCapitalKra!, 9);
        public decimal InformationCapital_PercentAccomplished10 => GetPercent(InformationCapitalKra!, 10);
        public int InformationCapital_Year1 => InformationCapitalKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int InformationCapital_Year2 => InformationCapitalKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int InformationCapital_Year3 => InformationCapitalKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int InformationCapital_Year4 => InformationCapitalKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int InformationCapital_Year5 => InformationCapitalKra?.Years?.ElementAtOrDefault(4) ?? 0;


        // =====================================================
        // FINANCIAL STEWARDSHIP KRA (first 10 KPI values)
        // =====================================================
        private ReportKraDto? FinacialStewardshipKra => Kras.FirstOrDefault(k => k.Id == KraStatus.FinacialStewardship);
        public string? FinacialStewardship_KraName1 => GetKpiProperty(FinacialStewardshipKra!, 1).kraName;
        public string? FinacialStewardship_StrategicObjective1 => GetKpiProperty(FinacialStewardshipKra!, 1).strategicObjective;
        public string? FinacialStewardship_KpiDescription1 => GetKpiProperty(FinacialStewardshipKra!, 1).kpiDesc;
        public string? FinacialStewardship_Target1 => GetKpiProperty(FinacialStewardshipKra!, 1).target;
        public string? FinacialStewardship_BaseLine1 => GetKpiProperty(FinacialStewardshipKra!, 1).baseline;
        public decimal FinacialStewardship_PercentAccomplished1 => GetPercent(FinacialStewardshipKra!, 1);
        public decimal FinacialStewardship_PercentAccomplished2 => GetPercent(FinacialStewardshipKra!, 2);
        public decimal FinacialStewardship_PercentAccomplished3 => GetPercent(FinacialStewardshipKra!, 3);
        public decimal FinacialStewardship_PercentAccomplished4 => GetPercent(FinacialStewardshipKra!, 4);
        public decimal FinacialStewardship_PercentAccomplished5 => GetPercent(FinacialStewardshipKra!, 5);
        public string? FinacialStewardship_KraName2 => GetKpiProperty(FinacialStewardshipKra!, 6).kraName;
        public string? FinacialStewardship_StrategicObjective2 => GetKpiProperty(FinacialStewardshipKra!, 6).strategicObjective;
        public string? FinacialStewardship_KpiDescription2 => GetKpiProperty(FinacialStewardshipKra!, 6).kpiDesc;
        public string? FinacialStewardship_Target2 => GetKpiProperty(FinacialStewardshipKra!, 6).target;
        public string? FinacialStewardship_BaseLine2 => GetKpiProperty(FinacialStewardshipKra!, 6).baseline;
        public decimal FinacialStewardship_PercentAccomplished6 => GetPercent(FinacialStewardshipKra!, 6);
        public decimal FinacialStewardship_PercentAccomplished7 => GetPercent(FinacialStewardshipKra!, 7);
        public decimal FinacialStewardship_PercentAccomplished8 => GetPercent(FinacialStewardshipKra!, 8);
        public decimal FinacialStewardship_PercentAccomplished9 => GetPercent(FinacialStewardshipKra!, 9);
        public decimal FinacialStewardship_PercentAccomplished10 => GetPercent(FinacialStewardshipKra!, 10);
        public int FinacialStewardship_Year1 => FinacialStewardshipKra?.Years?.ElementAtOrDefault(0) ?? 0;
        public int FinacialStewardship_Year2 => FinacialStewardshipKra?.Years?.ElementAtOrDefault(1) ?? 0;
        public int FinacialStewardship_Year3 => FinacialStewardshipKra?.Years?.ElementAtOrDefault(2) ?? 0;
        public int FinacialStewardship_Year4 => FinacialStewardshipKra?.Years?.ElementAtOrDefault(3) ?? 0;
        public int FinacialStewardship_Year5 => FinacialStewardshipKra?.Years?.ElementAtOrDefault(4) ?? 0;




    }
}















