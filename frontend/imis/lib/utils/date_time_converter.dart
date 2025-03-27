import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  static final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  DateTime fromJson(String json) => dateFormat.parse(json);

  @override
  String toJson(DateTime object) => dateFormat.format(object);
}
