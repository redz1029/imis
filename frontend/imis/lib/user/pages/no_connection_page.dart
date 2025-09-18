// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/no_connection.png', width: 300),
            const SizedBox(height: 20),
            const Text(
              "No Internet",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "It looks like you're not connected to the internet \nPlease check your connection and try again.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Retry connection
                (context as Element).reassemble();
              },
              child: const Text("RETRY", style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
