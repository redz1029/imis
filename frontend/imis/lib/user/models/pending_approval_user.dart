import 'package:json_annotation/json_annotation.dart';

part 'pending_approval_user.g.dart';

@JsonSerializable()
class PendingApprovalUser {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String userName;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String firstName;
  @JsonKey(defaultValue: '')
  final String middleName;
  @JsonKey(defaultValue: '')
  final String lastName;
  @JsonKey(defaultValue: '')
  final String position;
  @JsonKey(defaultValue: false)
  final bool lockoutEnabled;
  @JsonKey(defaultValue: false)
  final bool isLockedOut;
  final DateTime? lockoutEnd;
  final String? office;
  @JsonKey(defaultValue: false)
  final bool isPendingApproval;

  PendingApprovalUser({
    required this.id,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.position,
    required this.lockoutEnabled,
    required this.isLockedOut,
    required this.lockoutEnd,
    this.office,
    required this.isPendingApproval,
  });

  factory PendingApprovalUser.fromJson(Map<String, dynamic> json) =>
      _$PendingApprovalUserFromJson(json);

  Map<String, dynamic> toJson() => _$PendingApprovalUserToJson(this);

  String get fullName =>
      '$firstName $middleName $lastName'.trim().replaceAll(RegExp(' +'), ' ');

  bool get isPermanentlyLocked =>
      lockoutEnd != null && lockoutEnd!.year >= 9000;
}
