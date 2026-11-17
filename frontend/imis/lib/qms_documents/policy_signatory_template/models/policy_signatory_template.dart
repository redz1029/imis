import 'package:json_annotation/json_annotation.dart';
part 'policy_signatory_template.g.dart';

@JsonSerializable()
class PolicySignatoryTemplate {
  int? id;
  bool isDeleted;
  String? status;
  int orderLevel;
  String defaultSignatoryId;
  bool isActive;
  String? rowVersion;
  String? signatoryLabel;
  int? officeId;

  PolicySignatoryTemplate(
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

  factory PolicySignatoryTemplate.fromJson(Map<String, dynamic> json) =>
      _$PolicySignatoryTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$PolicySignatoryTemplateToJson(this);
}
