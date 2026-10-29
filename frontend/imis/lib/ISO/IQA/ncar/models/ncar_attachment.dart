import 'dart:convert';
import 'dart:typed_data';

/// A picture attached to an NCAR as proof the nonconformity was resolved.
/// It is printed on the second page of the NCAR form.
class NcarAttachment {
  final int id;
  final int ncarId;
  final String fileName;
  final String? caption;
  final int orderNumber;
  final Uint8List bytes;

  const NcarAttachment({
    required this.id,
    required this.ncarId,
    required this.fileName,
    required this.bytes,
    this.caption,
    this.orderNumber = 0,
  });

  factory NcarAttachment.fromJson(Map<String, dynamic> json) {
    final raw = (json['contentBase64'] ?? json['ContentBase64'] ?? '')
        .toString();
    final caption = (json['caption'] ?? json['Caption'])?.toString().trim();
    return NcarAttachment(
      id: ((json['id'] ?? json['Id'] ?? 0) as num).toInt(),
      ncarId:
          ((json['nonconformingActionReportId'] ??
                      json['NonconformingActionReportId'] ??
                      0)
                  as num)
              .toInt(),
      fileName: (json['fileName'] ?? json['FileName'] ?? '').toString(),
      caption: (caption == null || caption.isEmpty) ? null : caption,
      orderNumber: ((json['orderNumber'] ?? json['OrderNumber'] ?? 0) as num)
          .toInt(),
      bytes: raw.isEmpty ? Uint8List(0) : base64Decode(raw),
    );
  }
}
