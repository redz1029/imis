import 'package:json_annotation/json_annotation.dart';
part 'pgs_signatory_template.g.dart';

@JsonSerializable()
class PgsSignatoryTemplate {
  int? id;
  bool isDeleted;
  String? status;
  int orderLevel;
  String defaultSignatoryId;
  bool isActive;
  String? rowVersion;
  String? signatoryLabel;

  PgsSignatoryTemplate(
    this.id,
    this.isDeleted,
    this.orderLevel,
    this.defaultSignatoryId,
    this.isActive, {
    required this.status,
    this.rowVersion,
    required this.signatoryLabel,
  });

  factory PgsSignatoryTemplate.fromJson(Map<String, dynamic> json) =>
      _$PgsSignatoryTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$PgsSignatoryTemplateToJson(this);
}
