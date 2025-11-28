import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

Widget noPermissionScreen() {
  return Scaffold(
    backgroundColor: mainBgColor,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 80, color: grey),
          SizedBox(height: 20),
          Text(
            "You don’t have permission to view this page.",
            style: TextStyle(color: grey, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Please contact the admin.",
            style: TextStyle(color: grey, fontSize: 14),
          ),
        ],
      ),
    ),
  );
}
