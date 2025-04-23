import 'package:json_annotation/json_annotation.dart';

part 'user_office.g.dart';

@JsonSerializable()
class UserOffice {
  final int id;
  final bool isDeleted;
  final String? rowVersion;
  final String userId;
  final int officeId;
  final bool isActive;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? prefix;
  final String? suffix;
  final String position;

  UserOffice({
    required this.id,
    required this.isDeleted,
    required this.rowVersion,
    required this.userId,
    required this.officeId,
    required this.isActive,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.prefix,
    required this.suffix,
    required this.position,
  });

  factory UserOffice.fromJson(Map<String, dynamic> json) =>
      _$UserOfficeFromJson(json);

  Map<String, dynamic> toJson() => _$UserOfficeToJson(this);
}
