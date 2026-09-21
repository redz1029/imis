import 'package:json_annotation/json_annotation.dart';

part 'audit_scope.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditScope {
  @JsonKey(defaultValue: 0)
  int id;
  bool? isDeleted;
  String? rowVersion;

  String auditee;

  AuditScope({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    required this.auditee,
  });

  factory AuditScope.fromJson(Map<String, dynamic> json) =>
      _$AuditScopeFromJson(json);

  Map<String, dynamic> toJson() => _$AuditScopeToJson(this);
}