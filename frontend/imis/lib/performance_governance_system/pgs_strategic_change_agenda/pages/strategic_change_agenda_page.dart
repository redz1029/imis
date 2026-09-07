// import 'package:flutter/material.dart';
// import 'package:imis/constant/constant.dart';
// import 'package:imis/dashboard/strategic_change_agenda.dart';

// class StrategicChangeAgendaPage extends StatefulWidget {
//   const StrategicChangeAgendaPage({super.key});

//   @override
//   State<StrategicChangeAgendaPage> createState() =>
//       StrategicChangeAgendaPageState();
// }

// class StrategicChangeAgendaPageState extends State<StrategicChangeAgendaPage> {
//   bool _isLoading = false;
//   List<StrategicChangeAgenda> filteredList = [];
//   int _currentPage = 1;
//   final int _pageSize = 15;
//   int _totalCount = 0;

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final isMobile = width < 600;

//     return Scaffold(
//       backgroundColor: Color(0xFFF5F6FA),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildPageHeader(isMobile),
//           gap4px,
//           Expanded(
//             child: Padding(
//               padding: EdgeInsetsGeometry.fromLTRB(12, 0, 12, 12),
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 10,
//                       color: Colors.black.withValues(alpha: .05),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (!isMobile)
//                       Container(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(color: Colors.grey.shade300),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: Text(
//                                 '#',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Text(
//                                 'Period',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 2,
//                               child: Text(
//                                 'Actions',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     SizedBox(height: 5),
//                     Expanded(
//                       child:
//                           _isLoading
//                               ? Center(
//                                 child: CircularProgressIndicator(
//                                   color: primaryColor,
//                                 ),
//                               )
//                               : filteredList.isEmpty
//                               ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.arrow_right,
//                                       size: 50,
//                                       color: Colors.grey.shade400,
//                                     ),
//                                     SizedBox(height: 10),
//                                     Text(
//                                       "No strategic change agenda available",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                               : ListView.separated(
//                                 itemCount: filteredList.length,
//                                 separatorBuilder:
//                                     (_, __) => Divider(
//                                       height: 1,
//                                       color: Colors.grey.withValues(alpha: .2),
//                                     ),
//                                 itemBuilder: (context, index) {
//                                   final strategic = filteredList[index];
//                                   final itemNumber =
//                                       ((_currentPage - 1) * _pageSize) +
//                                       index +
//                                       1;
//                                   if (!isMobile) {
//                                     return Container(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 4,
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               "$itemNumber",
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(child: Text("")),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPageHeader(bool isMobile) {
//     final width = MediaQuery.of(context).size.width;
//     final isSmall = width < 900;
//     final isXSmall = width < 700;
//     return Container(
//       width: double.infinity,
//       color: Colors.white,
//       padding: EdgeInsets.fromLTRB(20, isXSmall ? 12 : 16, 20, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(isXSmall ? 6 : 8),
//                 decoration: BoxDecoration(
//                   color: primaryColor.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.sync_alt,
//                   color: primaryColor,
//                   size: isXSmall ? 18 : 22,
//                 ),
//               ),
//               SizedBox(width: isXSmall ? 8 : 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Strategic Change Agenda",
//                       style: TextStyle(
//                         fontSize:
//                             isXSmall
//                                 ? 12
//                                 : isSmall
//                                 ? 14
//                                 : 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1A1D23),
//                       ),
//                     ),
//                     Text(
//                       "${filteredList.length} strategic change agenda${filteredList.length != 1 ? 's' : ''} found",
//                       style: TextStyle(
//                         fontSize: isXSmall ? 10 : 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }
