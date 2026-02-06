import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/dashboard/admin_dashboard.dart';
import 'package:imis/dashboard/officer_dashboard.dart';
import 'package:imis/dashboard/standard_user_dashboard.dart';
import 'package:imis/user/models/user_office.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<HomePageState> homePageKey = GlobalKey();

class HomePage extends StatefulWidget {
  HomePage() : super(key: homePageKey);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isLoading = true;
  List<String>? _userRoles;

  @override
  void initState() {
    super.initState();
    _fetchUserRoles();
  }

  Future<void> _fetchUserRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedRole = prefs.getString('selectedRole');

    setState(() {
      _userRoles = selectedRole != null ? [selectedRole] : [];
      _isLoading = false;
    });
  }

  Future<void> refreshUserRoles() async {
    await _fetchUserRoles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_userRoles == null || _userRoles!.isEmpty) {
      return const Scaffold(backgroundColor: mainBgColor);
    }

    if (_userRoles!.contains("Administrator")) {
      return const AdminDashboard();
    }

    final officerRoles = [
      "Service Officer",
      "Training Officer",
      "Research Officer",
      "Information Officer",
      "Linkages Officer",
      "Facilities Officer",
      "Safety Officer",
      "HR Officer",
      "Finance Officer",
    ];

    if (_userRoles!.any((role) => officerRoles.contains(role))) {
      return const OfficerDashboard();
    }

    return const StandardUserDashboard();
  }
}
