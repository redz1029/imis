// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategic_change_agenda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrategicChangeAgenda _$StrategicChangeAgendaFromJson(
  Map<String, dynamic> json,
) => StrategicChangeAgenda(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  from: json['from'] as String?,
  to: json['to'] as String?,
  strategicChangeAgendaDeliverable:
      (json['strategicChangeAgendaDeliverable'] as List<dynamic>?)
          ?.map(
            (e) => StrategicChangeAgendaDeliverable.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$StrategicChangeAgendaToJson(
  StrategicChangeAgenda instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'from': instance.from,
  'to': instance.to,
  'strategicChangeAgendaDeliverable': instance.strategicChangeAgendaDeliverable,
};

StrategicChangeAgendaDeliverable _$StrategicChangeAgendaDeliverableFromJson(
  Map<String, dynamic> json,
) => StrategicChangeAgendaDeliverable(
  id: (json['id'] as num).toInt(),
  area: json['area'] as String?,
  items:
      (json['items'] as List<dynamic>)
          .map(
            (e) =>
                StrategicChangeAgendaItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$StrategicChangeAgendaDeliverableToJson(
  StrategicChangeAgendaDeliverable instance,
) => <String, dynamic>{
  'id': instance.id,
  'area': instance.area,
  'items': instance.items,
};

StrategicChangeAgendaItem _$StrategicChangeAgendaItemFromJson(
  Map<String, dynamic> json,
) => StrategicChangeAgendaItem(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  area: json['area'] as String?,
  year: (json['year'] as num).toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$StrategicChangeAgendaItemToJson(
  StrategicChangeAgendaItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'area': instance.area,
  'year': instance.year,
  'description': instance.description,
};
