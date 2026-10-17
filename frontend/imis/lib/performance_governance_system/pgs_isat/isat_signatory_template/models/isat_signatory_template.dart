import 'package:json_annotation/json_annotation.dart';
part 'isat_signatory_template.g.dart';

@JsonSerializable()
class IsatSignatoryTemplate {
  int id;
  bool isDeleted;
  String? rowVersion;
  String? status;
  String signatoryLabel;
  String? defaultSignatoryId;
  bool? isActive;
  int officeId;
  String? position;
  int? orderLevel;

  IsatSignatoryTemplate(
    this.id,
    this.signatoryLabel,
    this.defaultSignatoryId,
    this.officeId,
    this.isDeleted, {
    this.isActive,
    this.status,
    this.position,
    this.rowVersion,
    this.orderLevel,
  });

  factory IsatSignatoryTemplate.fromJson(Map<String, dynamic> json) =>
      _$IsatSignatoryTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$IsatSignatoryTemplateToJson(this);
}
