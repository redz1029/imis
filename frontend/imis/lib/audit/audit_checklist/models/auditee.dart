import 'package:json_annotation/json_annotation.dart';

part 'auditee.g.dart';

@JsonSerializable()
class Auditee {
  @JsonKey(defaultValue: 0)
  final int id;

  final String name;
  final String userId;
  final String? userEmail;
  final String? fullName;

  const Auditee({
    this.id = 0,
    required this.name,
    required this.userId,
    this.userEmail,
    this.fullName,
  });

  factory Auditee.fromJson(Map<String, dynamic> json) =>
      _$AuditeeFromJson(json);

  Map<String, dynamic> toJson() => _$AuditeeToJson(this);

  /// Best display label for suggestions — prefers the linked user's
  /// full name, falling back to the auditee's own recorded name.
  String get displayName =>
      (fullName != null && fullName!.trim().isNotEmpty) ? fullName! : name;
}