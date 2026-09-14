import 'package:json_annotation/json_annotation.dart';

part 'strategic_change_agenda.g.dart';

@JsonSerializable()
class StrategicChangeAgenda {
  final int id;
  final bool isDeleted;
  final String? rowVersion;
  final String? from;
  final String? to;

  @JsonKey(defaultValue: <StrategicChangeAgendaDeliverable>[])
  final List<StrategicChangeAgendaDeliverable> strategicChangeAgendaDeliverable;

  const StrategicChangeAgenda({
    required this.id,
    required this.isDeleted,
    this.rowVersion,
    this.from,
    this.to,
    required this.strategicChangeAgendaDeliverable,
  });

  factory StrategicChangeAgenda.fromJson(Map<String, dynamic> json) =>
      _$StrategicChangeAgendaFromJson(json);

  Map<String, dynamic> toJson() => _$StrategicChangeAgendaToJson(this);
}

@JsonSerializable()
class StrategicChangeAgendaDeliverable {
  final int id;
  final String? area;
  final List<StrategicChangeAgendaItem> items;

  const StrategicChangeAgendaDeliverable({
    required this.id,
    this.area,
    required this.items,
  });

  factory StrategicChangeAgendaDeliverable.fromJson(
    Map<String, dynamic> json,
  ) => _$StrategicChangeAgendaDeliverableFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StrategicChangeAgendaDeliverableToJson(this);
}

@JsonSerializable()
class StrategicChangeAgendaItem {
  final int id;
  final bool isDeleted;
  final String? rowVersion;
  final String? area;
  final int year;
  final String? description;

  const StrategicChangeAgendaItem({
    required this.id,
    required this.isDeleted,
    this.rowVersion,
    this.area,
    required this.year,
    this.description,
  });

  factory StrategicChangeAgendaItem.fromJson(Map<String, dynamic> json) =>
      _$StrategicChangeAgendaItemFromJson(json);

  Map<String, dynamic> toJson() => _$StrategicChangeAgendaItemToJson(this);
}
