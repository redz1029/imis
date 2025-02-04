
using Base.Primitives;
using IMIS.Domain;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace IMIS.Application.PgsModule
{
    public class PgsDto : BaseDto<PGS, int>
    {
        public required string Year { get; set; }
        public required string KRA_1 { get; set; }
        public required bool Direct_1 { get; set; }
        public required bool Indirect_1 { get; set; }
        public required string Delivarables_1 { get; set; }
        public required string ByWhen_1 { get; set; }
        public required string Percent_Deliverables { get; set; }
        public required string Status { get; set; }

        [JsonConverter(typeof(Base64JsonConverter))]
        public byte[] RowVersion { get; set; }

        public override PGS ToEntity()
        {
            return new PGS()
            {
                Id = Id,
                Year = Year,
                KRA_1 = KRA_1,
                Direct_1 = Direct_1,
                Indirect_1 = Indirect_1,
                Delivarables_1 = Delivarables_1,
                ByWhen_1 = ByWhen_1,
                Percent_Deliverables = Percent_Deliverables,
                Status = Status,
                RowVersion = RowVersion 
            };
        }
    }

   
  public class Base64JsonConverter : JsonConverter<byte[]>
{
    public override byte[] Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        try
        {
            var base64String = reader.GetString();
            if (base64String == null)
                return null;

        
            return Convert.FromBase64String(base64String);
        }
        catch (FormatException ex)
        {
            throw new JsonException($"Invalid Base64 string format for RowVersion: {ex.Message}");
        }
    }

    public override void Write(Utf8JsonWriter writer, byte[] value, JsonSerializerOptions options)
    {
        writer.WriteStringValue(value == null ? null : Convert.ToBase64String(value));
    }
}

}

