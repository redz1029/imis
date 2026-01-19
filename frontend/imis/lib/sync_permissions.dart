import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse(
    'https://localhost:7273/permissions',
  ); // Replace with your URL
  print('Refreshing permissions from backend...');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final buffer = StringBuffer();
      buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
      buffer.writeln('// Last synced: ${DateTime.now()}\n');
      buffer.writeln('class AppPermissions {');

      for (var permission in data) {
        // Formats "user_read" into "static const String userRead = 'user_read';"
        final variableName = _toCamelCase(permission.toString());
        buffer.writeln("  static const String $variableName = '$permission';");
      }

      buffer.writeln('}');

      // Write to your lib folder
      final file = File('lib/constant/permissions.dart');
      await file.create(recursive: true);
      await file.writeAsString(buffer.toString());

      print('✅ Success! Permissions synced to ${file.path}');
    } else {
      print('❌ Failed to fetch permissions: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error occurred: $e');
  }
}

String _toCamelCase(String text) {
  // 1. Split by underscores or by capital letters (using regex lookahead)
  // This turns "UserRead" or "user_read" into ["User", "Read"] or ["user", "read"]
  RegExp exp = RegExp(r'(?=[A-Z])|_');
  List<String> words = text.split(exp).where((w) => w.isNotEmpty).toList();

  return words
      .asMap()
      .entries
      .map((entry) {
        String word = entry.value.replaceAll('_', '').toLowerCase();

        // If it's the first word, keep it lowercase.
        // Otherwise, capitalize the first letter.
        if (entry.key == 0) {
          return word;
        }
        return word[0].toUpperCase() + word.substring(1);
      })
      .join('');
}
