import 'package:json_annotation/json_annotation.dart';

part 'pending_approval_user.g.dart';

@JsonSerializable()
class PendingApprovalUser {
  @JsonKey(fromJson: _idFromJson)
  final String id;
  final String userName;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String position;
  @JsonKey(defaultValue: false)
  final bool lockoutEnabled;
  final DateTime? lockoutEnd;
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
    required this.lockoutEnd,
    required this.isPendingApproval,
  });

  factory PendingApprovalUser.fromJson(Map<String, dynamic> json) =>
      _$PendingApprovalUserFromJson(json);

  Map<String, dynamic> toJson() => _$PendingApprovalUserToJson(this);

  static String _idFromJson(dynamic id) => id?.toString() ?? '';

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get fullName =>
      '$firstName $middleName $lastName'.trim().replaceAll(RegExp(' +'), ' ');

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isPermanentlyLocked =>
      lockoutEnd != null && lockoutEnd!.year >= 9000;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isCurrentlyLocked =>
      lockoutEnabled &&
      lockoutEnd != null &&
      lockoutEnd!.isAfter(DateTime.now());
}

@JsonSerializable()
class PendingApprovalUserPage {
  @JsonKey(name: 'data', defaultValue: <PendingApprovalUser>[])
  final List<PendingApprovalUser> items;
  @JsonKey(defaultValue: 0)
  final int totalCount;
  @JsonKey(defaultValue: 1)
  final int totalPages;
  @JsonKey(defaultValue: 1)
  final int page;
  @JsonKey(defaultValue: 15)
  final int pageSize;

  PendingApprovalUserPage({
    required this.items,
    required this.totalCount,
    required this.totalPages,
    required this.page,
    required this.pageSize,
  });

  factory PendingApprovalUserPage.fromJson(Map<String, dynamic> json) =>
      _$PendingApprovalUserPageFromJson(json);

  Map<String, dynamic> toJson() => _$PendingApprovalUserPageToJson(this);
}
