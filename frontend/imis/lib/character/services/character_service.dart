import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class CharacterService {
  final Dio dio;

  CharacterService(this.dio);

  /// Save the given name to the backend database.
  /// Sends a POST to the character endpoint with a JSON body { name: ... }.
  static final Dio _internalDio = Dio();

  static Future<void> saveName(String name) async {
    // keep backward-compatible wrapper that saves name only
    await saveCharacter(name, '');
  }

  /// Fetches a name from the backend. If the endpoint returns a list,
  /// returns the first item's `name`. If it returns an object, returns its `name`.
  static Future<String?> getName() async {
    final character = await getCharacter();
    if (character == null) return null;
    return character['name']?.toString();
  }

  /// Clears the saved name on the backend by deleting the first item (if present).
  /// This method is defensive because different backends may return different shapes.
  /*
  static Future<void> clearName() async {
    final dio = Dio();
    final url = '${ApiEndpoint.baseUrl}/character';
    try {
      final resp = await AuthenticatedRequest.get(dio, url);
      final data = resp.data;
      int? id;
      if (data is List && data.isNotEmpty) {
        final first = data[0];
        if (first is Map && first['id'] != null) id = first['id'] as int;
      } else if (data is Map && data['id'] != null) {
        id = data['id'] as int;
      }
      if (id != null) {
        await AuthenticatedRequest.delete(dio, '$url/$id');
      } else {
        await AuthenticatedRequest.delete(dio, url);
      }
    } on DioException catch (_) {
      // swallow errors to avoid crashing the UI on clear
    }
  }
  */

  /// Fetches the first character item from the backend and returns it as a map.
  /// The returned map may contain keys like `id`, `name`, `remarks`, `rowVersion`, etc.
  static Future<Map<String, dynamic>?> getCharacter() async {
    final dio = Dio();
    final url = '${ApiEndpoint.baseUrl}/character';
    try {
      final resp = await AuthenticatedRequest.get(dio, url);
      final data = resp.data;
      if (data == null) return null;
      if (data is List && data.isNotEmpty) {
        final first = data[0];
        if (first is Map) return Map<String, dynamic>.from(first);
      } else if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  /// Fetches all character items from the backend and returns them as a list of maps.
  static Future<List<Map<String, dynamic>>> getCharacters() async {
    final dio = Dio();
    final url = '${ApiEndpoint.baseUrl}/character';
    try {
      final resp = await AuthenticatedRequest.get(dio, url);
      final data = resp.data;
      if (data == null) return <Map<String, dynamic>>[];
      if (data is List) {
        return data.whereType<Map>().map((m) => Map<String, dynamic>.from(m)).toList();
      } else if (data is Map) {
        return [Map<String, dynamic>.from(data)];
      }
      return <Map<String, dynamic>>[];
    } on DioException catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  /// Save or update a character. If `id` is provided and > 0, it will be included
  /// in the payload so the backend can update the existing record; otherwise `id` is 0.
  static Future<void> saveCharacter(String name, String remarks, {int? id}) async {
    final dio = _internalDio;
    final url = '${ApiEndpoint.baseUrl}/character';
    final Map<String, dynamic> requestData = {
      'id': id ?? 0,
      'name': name,
      'rowVersion': null,
      'remarks': remarks,
      'isdelete': false,
    };

    try {
      final resp = await AuthenticatedRequest.post(dio, url, data: requestData);
      if (resp.statusCode == null || resp.statusCode! >= 400) {
        final body = resp.data != null ? resp.data.toString() : resp.statusMessage;
        throw Exception('Failed to save character (${resp.statusCode}): $body');
      }
    } on DioException catch (e) {
      throw Exception('Failed to save character: ${e.message}');
    }
  }

  /// Deletes a character by id. If id is null, attempts to find the first item and delete it.
  static Future<void> deleteCharacter({int? id}) async {
    final dio = Dio();
    final url = '${ApiEndpoint.baseUrl}/character';
    try {
      int? targetId = id;
      if (targetId == null) {
        final resp = await AuthenticatedRequest.get(dio, url);
        final data = resp.data;
        if (data is List && data.isNotEmpty) {
          final first = data[0];
          if (first is Map && first['id'] != null) targetId = first['id'] as int;
        } else if (data is Map && data['id'] != null) {
          targetId = data['id'] as int;
        }
      }
      if (targetId != null) {
        await AuthenticatedRequest.delete(dio, '$url/$targetId');
      } else {
        // If no id, try deleting base endpoint (best-effort)
        await AuthenticatedRequest.delete(dio, url);
      }
    } on DioException catch (_) {
      // swallow errors to avoid crashing the UI on delete
    }
  }




}
  