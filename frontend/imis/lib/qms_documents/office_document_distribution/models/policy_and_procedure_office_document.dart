import 'package:imis/qms_documents/office_document_distribution/models/office_document_distribution.dart';
import 'package:json_annotation/json_annotation.dart';
part 'policy_and_procedure_office_document.g.dart';

@JsonSerializable(explicitToJson: true)
class PolicyAndProcedureOfficeDocument {
  int? id;
  bool isDeleted;
  String? rowVersion;
  int? policyAndProcedureId;
  DateTime? postingDate;
  bool? isControlledCopy;
  bool? isMasterCopy;
  List<OfficeDocumentDistribution>? officeDocumentDistributionList;

  PolicyAndProcedureOfficeDocument({
    this.id,
    required this.isDeleted,
    this.rowVersion,
    this.policyAndProcedureId,
    this.postingDate,
    this.isControlledCopy,
    this.isMasterCopy,
    this.officeDocumentDistributionList,
  });

  factory PolicyAndProcedureOfficeDocument.fromJson(
    Map<String, dynamic> json,
  ) => _$PolicyAndProcedureOfficeDocumentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PolicyAndProcedureOfficeDocumentToJson(this);
}
