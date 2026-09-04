import 'package:flutter/material.dart';

class ServiceHeadOfficePage extends StatefulWidget {
  const ServiceHeadOfficePage({super.key});

  @override
  State<ServiceHeadOfficePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ServiceHeadOfficePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Service Head Office",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
