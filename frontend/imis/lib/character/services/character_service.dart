import 'package:shared_preferences/shared_preferences.dart';

class CharacterService {
  CharacterService._();

  static const String _keyName = 'character_name';

  /// Saves the given [name]. If [name] is empty, the stored value is removed.
  static Future<bool> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return prefs.remove(_keyName);
    }
    return prefs.setString(_keyName, trimmed);
  }

  /// Returns the saved name or `null` if none.
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  /// Clears the saved name.
  static Future<bool> clearName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_keyName);
  }
}
