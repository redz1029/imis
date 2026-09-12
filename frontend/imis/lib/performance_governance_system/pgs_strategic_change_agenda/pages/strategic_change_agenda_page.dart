import 'package:flutter/material.dart';

class StrategicChangeAgendaPage extends StatefulWidget {
  const StrategicChangeAgendaPage({super.key});

  @override
  State<StrategicChangeAgendaPage> createState() =>
      StrategicChangeAgendaPageState();
}

class StrategicChangeAgendaPageState extends State<StrategicChangeAgendaPage> {
  int _currentPage = 1;
  final int _pageSize = 15;
  int totalCount = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: []),
    );
  }

  Widget _builHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsetsGeometry.fromLTRB(20, isMobile ? 12 : 16, 20, 20),
      child: Row(children: [Container(padding: EdgeInsets.all(8))]),
    );
  }
}
