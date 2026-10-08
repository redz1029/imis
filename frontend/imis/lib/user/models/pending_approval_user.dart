import 'package:json_annotation/json_annotation.dart';

part 'pending_approval_user.g.dart';

@JsonSerializable()
class PendingApprovalUser {
  final String id;
  final String userName;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String position;
  final bool lockoutEnabled;
  final bool isLockedOut;
  final DateTime? lockoutEnd;
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
    required this.isPendingApproval,
  });

  factory PendingApprovalUser.fromJson(Map<String, dynamic> json) {
    String s(String k) => (json[k] as String?)?.trim() ?? '';
    final rawEnd = json['lockoutEnd'] as String?;

    return PendingApprovalUser(
      id: json['id']?.toString() ?? '',
      userName: s('userName'),
      email: s('email'),
      firstName: s('firstName'),
      middleName: s('middleName'),
      lastName: s('lastName'),
      position: s('position'),
      lockoutEnabled: json['lockoutEnabled'] as bool? ?? false,
      isLockedOut: json['isLockedOut'] as bool? ?? false,
      lockoutEnd:
          (rawEnd == null || rawEnd.isEmpty) ? null : DateTime.tryParse(rawEnd),
      isPendingApproval: json['isPendingApproval'] as bool? ?? false,
    );
  }

  String get fullName =>
      '$firstName $middleName $lastName'.trim().replaceAll(RegExp(' +'), ' ');

  bool get isPermanentlyLocked =>
      lockoutEnd != null && lockoutEnd!.year >= 9000;
}
