import 'dart:async';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/dynamic_side_column.dart';
import 'package:table_calendar/table_calendar.dart';

class StandardUserDashboard extends StatefulWidget {
  const StandardUserDashboard({super.key});

  @override
  StandardUserDashboardtate createState() => StandardUserDashboardtate();
}

class StandardUserDashboardtate extends State<StandardUserDashboard> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<String> office = [];
  String firstName = "firstName";

  int _currentImageIndex = 0;
  late Timer imageTimer;
  final List<String> rotatingImages = [
    'assets/image3.png',
    'assets/image4.png',
  ];

  @override
  void initState() {
    super.initState();
    loadUserNames();

    imageTimer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % rotatingImages.length;
        });
      }
    });
    _loadUserName();
  }

  @override
  void dispose() {
    imageTimer.cancel();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();

    if (user != null) {
      setState(() {
        firstName = user.firstName ?? "firstName";
      });
    }
  }

  Future<void> loadUserNames() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    List<String>? officeName = await AuthUtil.fetchOfficeNames();

    if (user != null) {
      setState(() {
        office = officeName ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: mainBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [gap16px, _buildWelcome(), gap32px],
                ),
              ),
              SizedBox(width: 20),
              DynamicSideColumn1(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                currentImageIndex: _currentImageIndex,
                rotatingImages: rotatingImages,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gap16px,
              _buildWelcome(),
              gap16px,
              DynamicSideColumn1(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                currentImageIndex: _currentImageIndex,
                rotatingImages: rotatingImages,
              ),
            ],
          ),
        ],
      ),
    );
  }

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

  Widget _buildWelcome() {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 185, 123, 121),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_getGreeting()}, ${firstName.split(' ')[0]}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gap8px,
                  Text(
                    "Welcome to CPeMS - CRMC Performance Management System! Together, we track progress and build a culture of accountability and continuous improvement.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  gap16px,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/image1.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      gap12px,
                      Expanded(
                        child: Image.asset(
                          'assets/image2.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_getGreeting()}, ${firstName.split(' ')[0]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        gap8px,
                        Text(
                          "Welcome to CPeMS - CRMC Performance Management System! Together, we track progress and build a culture of accountability and continuous improvement.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gap16px,
                  Image.asset(
                    'assets/image1.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  gap12px,
                  Image.asset(
                    'assets/image2.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
    );
  }
}
