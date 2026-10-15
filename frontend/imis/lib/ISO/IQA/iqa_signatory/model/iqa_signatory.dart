import 'package:json_annotation/json_annotation.dart';

part 'iqa_signatory.g.dart';

/// One signatory instance in the approval chain of a specific audit entity
/// (e.g. AuditProgramme #12). Created from an IQASignatoryTemplate; holds the
/// signing result once the signatory acts.
@JsonSerializable(explicitToJson: true)
class IQASignatory {
  @JsonKey(defaultValue: 0)
  final int id;

  /// "AuditProgramme" | "AuditPlan" | "AuditSchedule"
  @JsonKey(defaultValue: '')
  final String auditEntityType;

  @JsonKey(defaultValue: 0)
  final int auditEntityId;

  final String? signatoryId;
  final String? signatoryName;

  /// From the template: "QMR", "Lead Auditor", ...
  final String? signatoryLabel;
  final String? position;

  /// Signing order.
  final int? orderLevel;

  /// Null until this signatory has actually signed.
  final DateTime? dateSigned;
  final String? remarks;

  /// "Pending" | "Approved" | "Disapproved"
  final String? approvalStatus;

  const IQASignatory({
    this.id = 0,
    required this.auditEntityType,
    required this.auditEntityId,
    this.signatoryId,
    this.signatoryName,
    this.signatoryLabel,
    this.position,
    this.orderLevel,
    this.dateSigned,
    this.remarks,
    this.approvalStatus,
  });

  bool get isApproved => approvalStatus == 'Approved';
  bool get isDisapproved => approvalStatus == 'Disapproved';
  bool get isPending => !isApproved && !isDisapproved;

  factory IQASignatory.fromJson(Map<String, dynamic> json) =>
      _$IQASignatoryFromJson(json);

  Map<String, dynamic> toJson() => _$IQASignatoryToJson(this);

  IQASignatory copyWith({
    int? id,
    String? auditEntityType,
    int? auditEntityId,
    String? signatoryId,
    String? signatoryName,
    String? signatoryLabel,
    String? position,
    int? orderLevel,
    DateTime? dateSigned,
    String? remarks,
    String? approvalStatus,
  }) {
    return IQASignatory(
      id: id ?? this.id,
      auditEntityType: auditEntityType ?? this.auditEntityType,
      auditEntityId: auditEntityId ?? this.auditEntityId,
      signatoryId: signatoryId ?? this.signatoryId,
      signatoryName: signatoryName ?? this.signatoryName,
      signatoryLabel: signatoryLabel ?? this.signatoryLabel,
      position: position ?? this.position,
      orderLevel: orderLevel ?? this.orderLevel,
      dateSigned: dateSigned ?? this.dateSigned,
      remarks: remarks ?? this.remarks,
      approvalStatus: approvalStatus ?? this.approvalStatus,
    );
  }

  /// Parses a raw JSON array (as returned inside AuditProgrammeDto,
  /// AuditPlanDto, and AuditScheduleDto's "signatories" field) into a list
  /// of IQASignatory. Used by AuditPlan/AuditSchedules' own fromJson via a
  /// `@JsonKey(fromJson: ...)` hook, since json_serializable can't call
  /// IQASignatory.fromJson directly on a raw `List<dynamic>`.
  static List<IQASignatory> listFromJson(Object? json) {
    if (json is! List) return const [];
    return json
        .map((e) => IQASignatory.fromJson(
              e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map),
            ))
        .toList();
  }
}