import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';

class ApiEndpoint {
  static String baseUrl = 'https://localhost:44333'; // Local API URL

  late String login;
  late String register;
  late String changepassword;

  ApiEndpoint() {
    login = '$baseUrl/login';
    register = '$baseUrl/register';
    changepassword = '$baseUrl/changePassword'; 
  }

  
  Future<http.Client> createHttpClient() async {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true; 
    return IOClient(client);
  }

 
  Future<Map<String, dynamic>> LoginPage(String username, String password) async {
    final client = await createHttpClient();
    try {
      final response = await client.post(
        Uri.parse(login),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

    
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during login: $e');
    }
  }

  // Registration function
  Future<Map<String, dynamic>> registrationPage(String username, String email, String password) async {
    final client = await createHttpClient();

    try {
      final response = await client.post(
        Uri.parse(register), 
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );
    
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during registration: $e');
    }
  }

 
}

