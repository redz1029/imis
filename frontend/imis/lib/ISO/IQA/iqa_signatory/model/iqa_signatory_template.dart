import 'package:json_annotation/json_annotation.dart';
part 'iqa_signatory_template.g.dart';

/// Mirrors IQASignatoryTemplateDto. Defines one step in the approval chain
/// for a given (AuditEntityType, OfficeId) — e.g. "QMR, order 1" for
/// AuditProgramme at Office 3.
@JsonSerializable(explicitToJson: true)
class IQASignatoryTemplate {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: false)
  final bool isDeleted;

  final String? rowVersion;

  /// "AuditProgramme" | "AuditPlan" | "AuditSchedule"
  @JsonKey(defaultValue: '')
  final String auditEntityType;

  /// Status/stage label this template applies to (e.g. "Pending").
  @JsonKey(defaultValue: '')
  final String status;

  /// e.g. "QMR", "Lead Auditor", "Department Head".
  @JsonKey(defaultValue: '')
  final String signatoryLabel;

  @JsonKey(defaultValue: 0)
  final int orderLevel;

  final String? defaultSignatoryId;
  final String? defaultSignatoryName;

  @JsonKey(defaultValue: true)
  final bool isActive;

  @JsonKey(defaultValue: 0)
  final int officeId;

  final String? officeName;

  final String? position;

  const IQASignatoryTemplate({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion,
    required this.auditEntityType,
    required this.status,
    required this.signatoryLabel,
    this.orderLevel = 0,
    this.defaultSignatoryId,
    this.defaultSignatoryName,
    this.isActive = true,
    required this.officeId,
    this.officeName,
    this.position,
  });

  factory IQASignatoryTemplate.fromJson(Map<String, dynamic> json) =>
      _$IQASignatoryTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$IQASignatoryTemplateToJson(this);

  IQASignatoryTemplate copyWith({
    int? id,
    String? rowVersion,
    String? auditEntityType,
    String? status,
    String? signatoryLabel,
    int? orderLevel,
    String? defaultSignatoryId,
    String? defaultSignatoryName,
    bool? isActive,
    int? officeId,
    String? officeName,
    String? position,
  }) {
    return IQASignatoryTemplate(
      id: id ?? this.id,
      isDeleted: isDeleted,
      rowVersion: rowVersion ?? this.rowVersion,
      auditEntityType: auditEntityType ?? this.auditEntityType,
      status: status ?? this.status,
      signatoryLabel: signatoryLabel ?? this.signatoryLabel,
      orderLevel: orderLevel ?? this.orderLevel,
      defaultSignatoryId: defaultSignatoryId ?? this.defaultSignatoryId,
      defaultSignatoryName: defaultSignatoryName ?? this.defaultSignatoryName,
      isActive: isActive ?? this.isActive,
      officeId: officeId ?? this.officeId,
      officeName: officeName ?? this.officeName,
      position: position ?? this.position,
    );
  }

  /// Parses a raw JSON array (e.g. the response body of the template list
  /// endpoint) into a list of IQASignatoryTemplate. Returns an empty list
  /// when [json] is not a List.
  static List<IQASignatoryTemplate> listFromJson(Object? json) {
    if (json is! List) return const [];
    return json
        .map((e) => IQASignatoryTemplate.fromJson(
              e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map),
            ))
        .toList();
  }
}