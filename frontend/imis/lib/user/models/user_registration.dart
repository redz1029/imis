import 'package:json_annotation/json_annotation.dart';

part 'user_registration.g.dart';

@JsonSerializable()
class UserRegistration {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String middleName;
  final String lastName;
  final String prefix;
  final String suffix;
  final String? position;

  UserRegistration(
    this.username,
    this.email,
    this.password,
    this.firstName,
    this.middleName,
    this.lastName,
    this.prefix,
    this.suffix,
    this.position,
  );

  factory UserRegistration.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationToJson(this);
}
