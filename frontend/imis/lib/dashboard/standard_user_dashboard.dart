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
  final List<String> rotatingImages = ['assets/pic1.jpg', 'assets/pic2.jpg'];

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
                  children: [
                    Text("Analytical Overview", style: TextStyle(fontSize: 20)),
                    gap16px,
                    _buildStatssRow(),
                    gap32px,
                  ],
                ),
              ),
              SizedBox(width: 20),
              DynamicSideColumn(
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
              Text("Analytical Overview", style: TextStyle(fontSize: 20)),
              gap16px,
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        office.join(', '),
                        style: TextStyle(fontSize: 14, color: grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 16),
                    PopupMenuButton<String>(
                      color: mainBgColor,
                      onSelected: (String value) {
                        // Handle selection here
                      },
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Option 1',
                              child: Text('Option 1'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Option 2',
                              child: Text('Option 2'),
                            ),
                          ],
                      offset: Offset(0, 30),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: mainBgColor,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.filter_list, size: 16, color: grey),
                            SizedBox(width: 4),
                            Text("Filter by", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gap16px,
              _buildStatssRow(),

              gap16px,

              DynamicSideColumn(
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

  Widget _buildStatssRow() {
    return Container(
      width: double.infinity,
      height: 200, // fixed banner height
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 185, 123, 121),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // 📌 Left text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello, ${firstName.split(' ')[0]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Welcome to CPeMS! Together, we track progress and build \na culture of accountability and continuous improvement.",
                    style: TextStyle(
                      color: const Color.fromARGB(230, 255, 255, 255),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 350,
              child: Image.asset('assets/image1.png', fit: BoxFit.contain),
            ),
            SizedBox(
              height: 280,
              child: Image.asset('assets/image2.png', fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
