import 'package:json_annotation/json_annotation.dart';

part 'user_registration.g.dart';

@JsonSerializable()
class UserRegistration {
  final String? id;
  final String? userName;
  final String? email;
  final String? password;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? prefix;
  final String? suffix;
  final String? position;
  String? accessToken;
  String? refreshToken;

  UserRegistration(
    this.id,
    this.userName,
    this.email,
    this.password,
    this.firstName,
    this.middleName,
    this.lastName,
    this.prefix,
    this.suffix,
    this.position,
    this.accessToken,
    this.refreshToken,
  );

  factory UserRegistration.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationToJson(this);
}
