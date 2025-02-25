import 'package:flutter/material.dart';
import 'package:imis/change_password/pages/change_password.dart';
import '/home_page.dart';
import '/register/pages/registration_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPageLoaded = false;
  bool _isPasswordVisible = false;
  bool _isLoginButtonDisabled = false; // Disable button while logging in
  bool _isLoading = false; // Track the loading state

  static const String loginUrl = 'https://localhost:7273/login';

  // Function to handle login request
  Future<void> _login(String username, String password) async {
    setState(() {
      _isLoading = true; // Show loading indicator inside button
      _isLoginButtonDisabled = true; // Disable the button during login
    });

    // Simulate a delay (e.g., 2 seconds) before sending the request
    await Future.delayed(Duration(seconds: 3));

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

        // Store login status in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        setState(() {
          _isLoginButtonDisabled = true;
          _isPageLoaded = true;
        });

        // Navigate to HomePage after login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _passwordController.clear();
        _showErrorDialog(
            context, 'Invalid username or password. Please try again.');
      }
    } catch (e) {
      _showErrorDialog(context,
          'An error occurred. Please check your internet connection and try again.');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
        _isLoginButtonDisabled =
            false; // Re-enable the button after login attempt
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is already logged in on page load
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      setState(() {
        _isPageLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF1A67A3),
          centerTitle: true,
          title: Text(
            "Integrated Management Information System",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color.fromARGB(255, 230, 225, 225),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isPageLoaded) CircularProgressIndicator(),
              if (_isPageLoaded) _buildLoginModal(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginModal() {
    return Container(
      width: 350,
      height: 325,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5.0),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 3.0),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              labelStyle: TextStyle(color: Colors.blue[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.5),
                borderSide: BorderSide(color: Colors.blue[800]!, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.5),
                borderSide: BorderSide(color: Colors.blue[800]!, width: 1.2),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
            ),
            onSubmitted: (_) => _triggerLogin(),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(color: Colors.blue[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.5),
                borderSide: BorderSide(color: Colors.blue[800]!, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.5),
                borderSide: BorderSide(color: Colors.blue[800]!, width: 1.2),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blue[800],
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            onSubmitted: (_) => _triggerLogin(),
          ),
          SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: _isLoginButtonDisabled ? null : _triggerLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 143.0),
            ),
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Log In",
                    style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
          SizedBox(height: 10.0),
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
            child: Text("Create New Account",
                style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
          SizedBox(height: 9.0),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.blue[800], fontSize: 15),
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  // Trigger login action when enter is pressed
  void _triggerLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Validate input fields
    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog(context, 'Please fill in both fields.');
      return;
    }

    // Proceed with login if validation is successful
    _login(username, password);
  }

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
