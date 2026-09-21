import 'package:json_annotation/json_annotation.dart';

part 'audit_com_findings.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditComFindings {
  @JsonKey(defaultValue: 0)
  int id;
  bool? isDeleted;
  String? rowVersion;

  String commendableFindings;
  String area;
  int? areasId;

  AuditComFindings({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    required this.commendableFindings,
    required this.area,
    this.areasId,
  });

  factory AuditComFindings.fromJson(Map<String, dynamic> json) =>
      _$AuditComFindingsFromJson(json);

  Map<String, dynamic> toJson() => _$AuditComFindingsToJson(this);
}