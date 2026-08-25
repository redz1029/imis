using Docnet.Core;
using Docnet.Core.Models;
using System.Drawing;
using System.Drawing.Imaging;

namespace IMIS.Infrastructure.Reports
{
    public static class PdfHelper
    {
        public static List<byte[]> ConvertPdfToImages(byte[] pdfBytes)
        {
            if (pdfBytes == null || pdfBytes.Length == 0)
                return new List<byte[]>();

            var images = new List<byte[]>();

            using var docReader = DocLib.Instance;

            using var doc = docReader.GetDocReader(
                pdfBytes,
                null,
                new PageDimensions(1080, 1920)
            );

            int pageCount = doc.GetPageCount();

            for (int i = 0; i < pageCount; i++)
            {
                using var page = doc.GetPageReader(i);

                int width = page.GetPageWidth();
                int height = page.GetPageHeight();

                var rawBytes = page.GetImage();

                using var bitmap = new Bitmap(width, height, PixelFormat.Format32bppArgb);

                var bmpData = bitmap.LockBits(
                    new Rectangle(0, 0, width, height),
                    ImageLockMode.WriteOnly,
                    PixelFormat.Format32bppArgb);

                System.Runtime.InteropServices.Marshal.Copy(
                    rawBytes,
                    0,
                    bmpData.Scan0,
                    rawBytes.Length);

                bitmap.UnlockBits(bmpData);

                using var ms = new MemoryStream();
                bitmap.Save(ms, ImageFormat.Png);

                images.Add(ms.ToArray());
            }

            return images;
        }
    }
}