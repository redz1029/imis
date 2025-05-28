using FastReport;
using FastReport.Export.PdfSimple;
using FastReport.Web;
using Microsoft.AspNetCore.Html;

namespace IMIS.Infrastructure.Reports
{
    public static class ReportUtil
    {
        public static async Task<byte[]> GeneratePdfReport(string reportName, CancellationToken cancellationToken)
        {
            var report = LoadReport(reportName);
            return await ExportPdf(report, cancellationToken)
                .ConfigureAwait(false);
        }

        public static async Task<byte[]> GeneratePdfReport<T>(string reportName, IEnumerable<T> data,
            string dataSourceName, CancellationToken cancellationToken)
        {
            var report = LoadReport(reportName);

            report.RegisterData(data, dataSourceName);

            return await ExportPdf(report, cancellationToken)
                .ConfigureAwait(false);
        }

        private static Report LoadReport(string reportName)
        {
            Report report = new();
            string directory = Directory.GetCurrentDirectory();
            report.Load(@$"{directory}\Reports\{reportName}.frx");
            return report;
        }

        private static async Task<byte[]> ExportPdf(Report report, CancellationToken cancellationToken)
        {
            //report.SetParameterValue("IsDirect", );
            report.Prepare();
            using (MemoryStream ms = new())
            {
                PDFSimpleExport pdf = new();
                pdf.Export(report, ms);
                await ms.FlushAsync(cancellationToken)
                    .ConfigureAwait(false);

                return ms.ToArray();
            };
        }

        public static async Task<HtmlString> GenerateWebReport<T>(string reportName, IEnumerable<T>? data = null, string? dataSouceName = null)
        {
            WebReport report = new()
            {
                Report = LoadReport(reportName),
                Mode = WebReportMode.Preview,
            };

            if (data != null)
                report.Report.RegisterData(data, dataSouceName);

            return await report.Render().ConfigureAwait(false);
        }
    }
}
