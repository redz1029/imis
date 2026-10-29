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

/// A date AND its time of day, as the API stores it (wall-clock, no time
/// zone). [DateTimeConverter] keeps only the date, so anything read through it
/// comes back at midnight and loses the hour the user picked.
class WallClockDateTimeConverter implements JsonConverter<DateTime, String> {
  const WallClockDateTimeConverter();

  static final DateFormat _format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  @override
  DateTime fromJson(String json) {
    final parsed = DateTime.parse(json);
    // A stray "Z" must not shift the wall-clock time the user chose.
    return parsed.isUtc
        ? DateTime(
          parsed.year,
          parsed.month,
          parsed.day,
          parsed.hour,
          parsed.minute,
          parsed.second,
        )
        : parsed;
  }

  @override
  String toJson(DateTime object) => _format.format(object);
}

/// [WallClockDateTimeConverter] for a value that may be absent.
class NullableWallClockDateTimeConverter
    implements JsonConverter<DateTime?, String?> {
  const NullableWallClockDateTimeConverter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : const WallClockDateTimeConverter().fromJson(json);

  @override
  String? toJson(DateTime? object) =>
      object == null ? null : const WallClockDateTimeConverter().toJson(object);
}

class ReadableDateTimeConverter implements JsonConverter<DateTime, String> {
  const ReadableDateTimeConverter();

  static final DateFormat _formatter = DateFormat('MMM, dd, yyyy hh:mm a');

  @override
  DateTime fromJson(String json) => _formatter.parse(json);

  @override
  String toJson(DateTime object) => _formatter.format(object);
}

class LongDateOnlyConverter implements JsonConverter<DateTime, String> {
  const LongDateOnlyConverter();

  static final DateFormat _formatter = DateFormat('MMMM dd, yyyy');

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return _formatter.format(object);
  }
}

class IsoDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const IsoDateTimeConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;
    final parsed = DateTime.parse(json);

    final asUtc =
        parsed.isUtc
            ? parsed
            : DateTime.utc(
              parsed.year,
              parsed.month,
              parsed.day,
              parsed.hour,
              parsed.minute,
              parsed.second,
              parsed.millisecond,
              parsed.microsecond,
            );
    return asUtc.toLocal();
  }

  @override
  String? toJson(DateTime? date) => date?.toUtc().toIso8601String();
}
