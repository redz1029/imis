import 'package:flutter/material.dart';
import 'package:imis/change_password/pages/change_password.dart';
import '/home_page.dart';
import '/register/pages/registration_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // API endpoint
  static const String loginUrl = 'https://localhost:44333/login'; 

  // Function to handle login request
  Future<void> _login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
      
        jsonDecode(response.body);
        _usernameController.clear();
        _passwordController.clear();
 
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
       
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid username or password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle connection or other errors
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Integrated Management Information System",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: () {
                _showLoginModal(context);
              },
              child: Row(
                children: [
                  Icon(Icons.login, color: Colors.white),
                  SizedBox(width: 10.0),
                  Text(
                    "Open Login Modal",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Main content goes here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0, 
          child: Padding(
            padding: const EdgeInsets.all(10.0), 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Close button at the top-right corner
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                  ),
                ),

              
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 16.0),

                // Username Field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.blue[800]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),  
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], 
                  ),
                ),
                SizedBox(height: 12.0),

                // Password Field               
                TextField(                
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",            
                    labelStyle: TextStyle(color: Colors.blue[800]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 24.0),

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    // Validate input fields
                    if (username.isEmpty || password.isEmpty) {
                      _showErrorDialog(context, 'Please fill in both fields.');
                      return;
                    }

                    // Proceed with login if validation is successful
                    _login(username, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],  // Facebook-style blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),  // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 40.0),
                  ),
                  child: Text("Log In", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                SizedBox(height: 16.0),

                // Forgot Password Link
                TextButton(
                  onPressed: () {

                    //Click to display the Change password!!
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );

                    // Handle forgot password action
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blue[800], fontSize: 16),
                  ),
                ),
                SizedBox(height: 16.0),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 43, 196, 107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 40.0),
                  ),
                  child: Text("Create New Account", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                SizedBox(height: 16.0),            
              ],
            ),
          ),
        );
      },
    );
  }

  // Error Dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the error dialog
            },
            child: Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
