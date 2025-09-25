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
  final String? position;
  final bool isOfficeHead;

  UserOffice(
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.userId,
    this.officeId,
    this.isActive,
    this.firstName,
    this.middleName,
    this.lastName,
    this.prefix,
    this.suffix,
    this.position,
    this.isOfficeHead,
  );

  factory UserOffice.fromJson(Map<String, dynamic> json) =>
      _$UserOfficeFromJson(json);

  Map<String, dynamic> toJson() => _$UserOfficeToJson(this);
}
