import 'package:json_annotation/json_annotation.dart';
part 'pap_signatory.g.dart';

@JsonSerializable(includeIfNull: false)
class PapSignatory {
  int? id;
  bool? isDeleted;
  String? rowVersion;
  int? papId;
  int? papSignatoryTemplateId;
  String? signatoryId;
  String? signatoryName;
  DateTime? dateSigned;
  String? label;
  String? status;
  int? orderLevel;
  bool? isNextStatus;

  PapSignatory({
    this.id,
    this.isDeleted = false,
    this.rowVersion,
    this.papId,
    this.papSignatoryTemplateId,
    this.signatoryId,
    this.signatoryName,
    this.dateSigned,
    this.label,
    this.status,
    this.orderLevel,
    this.isNextStatus,
  });

  factory PapSignatory.fromJson(Map<String, dynamic> json) =>
      _$PapSignatoryFromJson(json);
  Map<String, dynamic> toJson() => _$PapSignatoryToJson(this);
}
