import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class PgsReportPage extends StatefulWidget {
  const PgsReportPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PgsReportPageState createState() => _PgsReportPageState();
}

class _PgsReportPageState extends State<PgsReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(title: Text('Reports'), backgroundColor: mainBgColor),
    );
  }
}
