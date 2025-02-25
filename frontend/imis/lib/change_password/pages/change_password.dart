import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:imis/login/pages/login_page.dart';

// ignore: use_key_in_widget_constructors
class ChangePasswordPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordModalState createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> changePassword(
      String username, String oldPassword, String newPassword) async {
    final String url = 'https://localhost:7273/changePassword';

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'currentPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Success"),
            content: Text('Password changed successfully!'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.blue[50],
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to change password. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: const Color.fromARGB(255, 230, 225, 225),
      ),
      backgroundColor: const Color.fromARGB(255, 230, 225, 225),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        child: Center(
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 44, 49, 56)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          borderSide:
                              BorderSide(color: Colors.blue[800]!, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          borderSide:
                              BorderSide(color: Colors.blue[800]!, width: 1.2),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onChanged: (value) => username = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your username' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Old Password",
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 44, 49, 56)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          borderSide:
                              BorderSide(color: Colors.blue[800]!, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          borderSide:
                              BorderSide(color: Colors.blue[800]!, width: 1.2),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onChanged: (value) => oldPassword = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your old password' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 44, 49, 56)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          borderSide:
                              BorderSide(color: Colors.blue[800]!, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          borderSide:
                              BorderSide(color: Colors.blue[800]!, width: 1.2),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onChanged: (value) => newPassword = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a new password' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm New Password",
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 44, 49, 56)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          borderSide:
                              BorderSide(color: Colors.blue[800]!, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          borderSide:
                              BorderSide(color: Colors.blue[800]!, width: 1.2),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onChanged: (value) => confirmPassword = value,
                      validator: (value) => value != newPassword
                          ? 'Passwords do not match'
                          : null,
                    ),
                    SizedBox(height: 10),
                    if (_isLoading)
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator())
                    else if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_errorMessage,
                            style: TextStyle(color: Colors.red)),
                      ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          changePassword(username, oldPassword, newPassword);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 100.0),
                      ),
                      child: Text('Change Password',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showChangePasswordModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ChangePasswordPage(),
  );
}
