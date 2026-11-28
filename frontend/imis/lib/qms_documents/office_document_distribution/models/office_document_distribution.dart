import 'package:json_annotation/json_annotation.dart';
part 'office_document_distribution.g.dart';

@JsonSerializable()
class OfficeDocumentDistribution {
  int? id;
  bool isDeleted;
  String? rowVersion;
  int? policyAndProcedureOfficeDocumentDistributionId;
  String? copyHolderUserId;
  int? officeId;
  DateTime? issuanceDate;
  String? issuanceRevision;
  DateTime? retrievalDate;
  String? retrievalRevision;

  OfficeDocumentDistribution({
    this.id,
    required this.isDeleted,
    this.rowVersion,
    this.policyAndProcedureOfficeDocumentDistributionId,
    this.copyHolderUserId,
    this.officeId,
    this.issuanceDate,
    this.issuanceRevision,
    this.retrievalDate,
    this.retrievalRevision,
  });

  factory OfficeDocumentDistribution.fromJson(Map<String, dynamic> json) =>
      _$OfficeDocumentDistributionFromJson(json);

  Map<String, dynamic> toJson() => _$OfficeDocumentDistributionToJson(this);
}
