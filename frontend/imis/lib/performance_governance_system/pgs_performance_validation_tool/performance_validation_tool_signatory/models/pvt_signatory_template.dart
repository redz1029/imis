import 'package:json_annotation/json_annotation.dart';
part 'pvt_signatory_template.g.dart';

@JsonSerializable()
class PvtSignatoryTemplate {
  int? id;
  bool isDeleted;
  String? status;
  int orderLevel;
  String defaultSignatoryId;
  bool isActive;
  String? rowVersion;
  String? signatoryLabel;
  int? officeId;

  PvtSignatoryTemplate(
    this.id,
    this.isDeleted,
    this.orderLevel,
    this.defaultSignatoryId,
    this.isActive, {
    required this.status,
    this.rowVersion,
    required this.signatoryLabel,
    required this.officeId,
  });

  factory PvtSignatoryTemplate.fromJson(Map<String, dynamic> json) =>
      _$PvtSignatoryTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$PvtSignatoryTemplateToJson(this);
}
