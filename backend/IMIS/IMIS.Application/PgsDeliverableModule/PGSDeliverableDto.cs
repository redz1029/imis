using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace IMIS.Application.PgsModule
{
    public class PGSDeliverableDto : BaseDto<PgsDeliverable, long>
    {   
        public  KraDto? Kra { get; set; }
        public required bool IsDirect { get; set; }      
        public required string DeliverableName { get; set; }
        public required DateTime ByWhen { get; set; }
        public required double PercentDeliverables { get; set; }
        public required PgsStatus Status { get; set; }       
        public  PgsAuditDetailsDto? PgsAuditDetails { get; set; }
        public  string? Remarks { get; set; }
        [JsonConverter(typeof(Base64JsonConverter))]
        public byte[] RowVersion { get; set; }
        public override PgsDeliverable ToEntity()
        {
            return new PgsDeliverable()
            {
                Id = Id,               
                IsDirect = IsDirect,               
                DeliverableName = DeliverableName,
                ByWhen = ByWhen,
                PercentDeliverables = PercentDeliverables,
                Status = Status,
                RowVersion = RowVersion,                 
                Kra = Kra?.ToEntity(),
                PgsAuditDetails = PgsAuditDetails?.ToEntity(),
                Remarks = Remarks
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

