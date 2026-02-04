import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<String> office = [];
  String firstName = "firstName";
  final dio = Dio();
  int _currentImageIndex = 0;
  late Timer imageTimer;
  final List<String> rotatingImages = [
    'assets/image3.png',
    'assets/image4.png',
  ];
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Widget _buildWelcome() {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 185, 123, 121),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_getGreeting()}, ${firstName.trim().split(' ')[0].toLowerCase().replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase())}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [                 
                      Text(
                        "${_getGreeting()}, ${firstName.trim().split(' ')[0].toLowerCase().replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase())}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
