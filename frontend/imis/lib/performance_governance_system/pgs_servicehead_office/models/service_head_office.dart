import 'package:json_annotation/json_annotation.dart';
part 'service_head_office.g.dart';

@JsonSerializable()
class ServiceHeadOffice {
  int id;
  String userId;
  String? userFullName;
  int officeId;
  String? officeName;
  String? rowVersion;
  bool? isDeleted;

  ServiceHeadOffice(
    this.id,
    this.userId,
    this.officeId,
    this.isDeleted, {
    this.userFullName,
    this.officeName,
    this.rowVersion,
  });

  factory ServiceHeadOffice.fromJson(Map<String, dynamic> json) =>
      _$ServiceHeadOfficeFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceHeadOfficeToJson(this);
}
