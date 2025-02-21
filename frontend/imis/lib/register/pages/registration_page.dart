import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imis/login/pages/login_page.dart';
import 'dart:convert';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showModal = true; // Initially show the modal
  String _modalMessage = '';

  Future<void> _registerUser() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _setModal("Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      _setModal("Passwords do not match.");
      return;
    }

    final apiUrl = 'https://localhost:44333/register'; // Replace with your API URL
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

      if (response.statusCode == 200) {
        _setModal("Registration successful!");

        // Navigate to LoginPage after registration success  
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
          );          
        });


      } else {
        _setModal("Registration failed. Please try again.");
      }
    } catch (e) {
     
      _setModal("An error occurred. Please check your internet connection and try again.");
    }
  }

  void _setModal(String message) {
    setState(() {
      _modalMessage = message;
      _showModal = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Account"),
        backgroundColor: Color.fromARGB(255, 230, 225, 225),
      ),
      backgroundColor: Color.fromARGB(255, 230, 225, 225),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_showModal)
                Center(
                  child: Container(
                    width: 370,
                    height: 430,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5.0),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _modalMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(color: Color.fromARGB(255, 44, 49, 56)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.5),
                              borderSide: BorderSide(color: Colors.blue[800]!, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.5),
                              borderSide: BorderSide(color: Colors.blue[800]!, width: 1.2),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Color.fromARGB(255, 44, 49, 56)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.5),
                              borderSide: BorderSide(color: Colors.blue[800]!, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.5),
                              borderSide: BorderSide(color: Colors.blue[800]!, width: 1.2),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Color.fromARGB(255, 44, 49, 56)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.5),
                              borderSide: BorderSide(color: Colors.blue[800]!, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.5),
                              borderSide: BorderSide(color: Colors.blue[800]!, width: 1.2),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: Color.fromARGB(255, 44, 49, 56)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.5),
                              borderSide: BorderSide(color: Colors.blue[800]!, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.5),
                              borderSide: BorderSide(color: Colors.blue[800]!, width: 1.2),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 143.0),
                          ),
                          child: Text("Register", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
