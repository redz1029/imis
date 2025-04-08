import 'package:imis/performance_governance_system/office/models/office.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String firstName;
  String middleName;
  String lastName;
  String position;
  Office office;
  String accessToken;
  String refreshToken;

  User(
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.position,
    this.office,
    this.accessToken,
    this.refreshToken,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
