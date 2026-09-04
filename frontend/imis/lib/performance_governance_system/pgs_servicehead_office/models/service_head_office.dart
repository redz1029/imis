import 'package:json_annotation/json_annotation.dart';
part 'service_head_office.g.dart';

@JsonSerializable()
class ServiceHeadOffice {
  int id;
  String userId;
  String officeId;
  String? rowVersion;
  String? isDeleted;

  ServiceHeadOffice(this.id, this.userId, this.officeId);

  factory ServiceHeadOffice.fromJson(Map<String, dynamic> json) =>
      _$ServiceHeadOfficeFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceHeadOfficeToJson(this);
}
