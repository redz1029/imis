import 'package:json_annotation/json_annotation.dart';

part 'audit_plan_status.g.dart';

@JsonSerializable()
class AuditPlanStatus {
  @JsonKey(defaultValue: 0)
  final int id;
  final String code;
  final String name;
  @JsonKey(defaultValue: 0)
  final int sortOrder;
  @JsonKey(defaultValue: true)
  final bool isActive;
  @JsonKey(defaultValue: false)
  final bool isDeleted;
  final String? rowVersion;

  const AuditPlanStatus({
    this.id = 0,
    required this.code,
    required this.name,
    this.sortOrder = 0,
    this.isActive = true,
    this.isDeleted = false,
    this.rowVersion,
  });

  factory AuditPlanStatus.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanStatusFromJson(json);

  Map<String, dynamic> toJson() => _$AuditPlanStatusToJson(this);

  AuditPlanStatus copyWith({

    int? id,
    String? code,
    String? name,
    int? sortOrder,
    bool? isActive,
    bool? isDeleted,
    String? rowVersion,
  }) {
    return AuditPlanStatus(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      rowVersion: rowVersion ?? this.rowVersion,
    );
  }
}
