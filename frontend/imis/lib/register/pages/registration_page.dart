import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:imis/login/pages/login_page.dart';  // Import login page

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers to capture text field input
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Function to handle registration logic
  Future<void> _registerUser() async {
    final username = _usernameController.text;
    final email = _emailController.text;  
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Simple validation
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match.");
      return;
    }

    // Sending data to the backend (replace with your API URL)
    final apiUrl = 'https://localhost:44333/register';  // Use IP address or emulator local IP
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,       
          'password': password,
        }),
      );

      // Debugging: Print status code and body
      // print("Server Response: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      // Handle the response from the server
      if (response.statusCode == 200) {
        _showSuccess("Registration successful!");
      } else if (response.statusCode == 400) {
        _showError("Invalid data. Please check your input.");
      } else if (response.statusCode == 500) {
        _showError("Server error. Please try again later.");
      } else {
        _showError("Registration failed. Please try again.");
      }
    } catch (e) {
      // Handle network errors or exceptions
      print("Error: $e");
      _showError("An error occurred. Please check your internet connection and try again.");
    }
  }

  // Function to show error messages
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // Function to show success messages
  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Close the success dialog
              Navigator.pushReplacement(
                context,  
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),

              // Confirm Password Field
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),

              // Register Button
              ElevatedButton(
                onPressed: _registerUser, 
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
