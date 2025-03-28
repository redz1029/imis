
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // ignore: depend_on_referenced_packages
// // import 'package:pdf/pdf.dart';
// // // ignore: depend_on_referenced_packages
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: PdfGeneratorScreen(),
//   ));
// }

// // ignore: use_key_in_widget_constructors
// class PdfGeneratorScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(   
//       body: Column(
//         children: [
//           _buildHeader(), // Displays "COTABATO REGIONAL AND MEDICAL CENTER"       
//           Expanded(child: _buildDisplayTable()), // Displays the table
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => generatePdf(),
//             child: Text("Generate PDF"),
//           ),
//         ],
//       ),
//     );
//   }
 

// Widget _buildHeader() {
//   return Padding(
//     padding: EdgeInsets.all(15),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center, 
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Logo on the left side
//         Image.asset('lib/assets/CRMC.png', height: 90), 
        
//         SizedBox(width: 10), 
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center, 
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'COTABATO REGIONAL AND MEDICAL CENTER',
//               textAlign: TextAlign.center, 
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             SizedBox(height: 5),
//             Text(
//               '2025',
//               textAlign: TextAlign.center, 
//               style: TextStyle(fontSize: 15),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

//   Widget _buildDisplayTable() {
//     return Padding(
//      padding: EdgeInsets.symmetric(horizontal: 120, vertical: 5),
//       child: Table(
//         border: TableBorder.all(),
//         columnWidths: {
//           0: FlexColumnWidth(1.5),
//           1: FlexColumnWidth(0.5),
//           2: FlexColumnWidth(0.5),
//           3: FlexColumnWidth(3),
//           4: FlexColumnWidth(1),
//           5: FlexColumnWidth(1),
//         },
//         children: [
//           // Table Header
//           TableRow(
//             decoration: BoxDecoration(color: Colors.redAccent.shade100),
//             children: [
          
//               _buildHeaderCell('Surgery', Colors.white, fontSize: 18, padding: EdgeInsets.all(15)), 
//               _buildHeaderCell('', Colors.white, padding: EdgeInsets.all(15)),
//               _buildHeaderCell('', Colors.white, padding: EdgeInsets.all(15)),
//               _buildHeaderCell('Strategic Contributions', Colors.white, fontSize: 18, padding: EdgeInsets.all(15)),
//               _buildHeaderCell('30%', Colors.white, fontSize: 18, padding: EdgeInsets.all(15)), 
//               _buildHeaderCell('', Colors.white, padding: EdgeInsets.all(15)),              
//             ],
//           ),
//           // Sub Header
//           TableRow(
//             decoration: BoxDecoration(color: Colors.white),
//             children: [            
//               _buildHeaderCell('KRA', Colors.black, padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//               _buildHeaderCell('DIRECT', Colors.black, padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//               _buildHeaderCell('INDIRECT', Colors.black, padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//               _buildHeaderCell('DELIVERABLES', Colors.black, padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//               _buildHeaderCell('BY WHEN', Colors.black, padding:EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//               _buildHeaderCell('STATUS', Colors.black, padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//             ],
//           ),
//           // Sample Data
//           _buildDataRow('PATIENT CARE', '', '', 'Admit 20 patients per month', 'March 2020', ''),
//           _buildDataRow('RESEARCH', '', '', 'Submit 1 case report to Elsevier', 'May 2022', ''),
//           _buildDataRow('LINKAGES', '', '', 'Community Screening Services', 'Aug 2022', ''),
//           _buildDataRow('HR', '', '', '4-6 Residents Hired', 'Dec 2022', ''),
//         ],
//       ),
//     );
//   }

// TableRow _buildDataRow(String kra, String direct, String indirect, String deliverables, String byWhen, String status) {
//   return TableRow(
//     decoration: BoxDecoration(color: Colors.white), 
//     children: [      
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//         color: Colors.white, 
//         child: Text(
//           kra,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,       
//           ),
//         ),
//       ),    
//       _buildCell(direct),
//       _buildCell(indirect),
//       _buildCell(deliverables),
//       _buildCell(byWhen),
//       _buildCell(status),
//     ],
//   );
// }

// Widget _buildHeaderCell(String text, color, {double fontSize = 14, required EdgeInsets padding}) {
//   return Container(
//     padding: padding, // Different padding per row
//     child: Text(
//       text,
//       style: TextStyle(
//         color: color,
//         fontSize: fontSize,
//         fontWeight: FontWeight.bold,
//       ),
//       textAlign: TextAlign.center,
//     ),
//   );
// }

//    Widget _buildCell(String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 13, horizontal: 8),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 14), // Regular Text
//       ),
//     );
//   }

  
  


// Future<Uint8List> loadLogo() async {
//   final ByteData data = await rootBundle.load('lib/assets/CRMC.png');
//   return data.buffer.asUint8List();
// }

// Future<void> generatePdf() async {
//   final pdf = pw.Document();

//   // Load the image bytes
//   final Uint8List logoBytes = await loadLogo();

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4.landscape,
//       build: (pw.Context context) {
//         return pw.Column(
//           children: [                 
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.center,
//               children: [
//                 // Logo
//                 pw.Image(
//                   pw.MemoryImage(logoBytes), 
//                   height: 70, 
//                 ),
//                 pw.SizedBox(width: 10),

//                 // Title
//                 pw.Column(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Text("COTABATO REGIONAL AND MEDICAL CENTER",
//                         style: pw.TextStyle(
//                             fontSize: 15, fontWeight: pw.FontWeight.bold)),
//                     pw.SizedBox(height: 10),
//                     pw.Text("2025", style: pw.TextStyle(fontSize: 14)),
//                   ],
//                 ),
//               ],
//             ),
            
//             pw.SizedBox(height: 50),

//             // ✅ Table Content
//             _buildPdfTable(),
//           ],
//         );
//       },
//     ),
//   );

//     // Show Print Preview
//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
//   }

//   pw.Widget _buildPdfTable() {
//     return pw.Table(
//       border: pw.TableBorder.all(),
//       columnWidths: {
//         0: pw.FlexColumnWidth(1.5),
//         1: pw.FlexColumnWidth(0.9),
//         2: pw.FlexColumnWidth(0.9),
//         3: pw.FlexColumnWidth(3),
//         4: pw.FlexColumnWidth(1),
//         5: pw.FlexColumnWidth(1),
//       },
//       children: [
      
//       pw.TableRow(
//   // decoration: pw.BoxDecoration(color: PdfColors.redAccent.shade100),
//   decoration: pw.BoxDecoration(color: PdfColors.redAccent100), 
//   children: [
//     _buildPdfHeaderCellWithPadding('Surgery', PdfColors.white, fontSize: 16, padding: pw.EdgeInsets.all(15)), 
//     _buildPdfHeaderCellWithPadding('', PdfColors.white, padding: pw.EdgeInsets.all(15)),
//     _buildPdfHeaderCellWithPadding('', PdfColors.white, padding: pw.EdgeInsets.all(15)),
//     _buildPdfHeaderCellWithPadding('Strategic Contributions', PdfColors.white, fontSize: 16, padding: pw.EdgeInsets.all(15)),
//     _buildPdfHeaderCellWithPadding('30%', PdfColors.white, fontSize: 16, padding: pw.EdgeInsets.all(15)), 
//     _buildPdfHeaderCellWithPadding('', PdfColors.white, padding: pw.EdgeInsets.all(15)),
//   ],
// ),

// // Sub Header with different padding
// pw.TableRow(
//   decoration: pw.BoxDecoration(color: PdfColors.white),
//   children: [
//     _buildPdfHeaderCellWithPadding('KRA', PdfColors.black, padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//     _buildPdfHeaderCellWithPadding('DIRECT', PdfColors.black, padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//     _buildPdfHeaderCellWithPadding('INDIRECT', PdfColors.black, padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//     _buildPdfHeaderCellWithPadding('DELIVERABLES', PdfColors.black, padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//     _buildPdfHeaderCellWithPadding('BY WHEN', PdfColors.black, padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//     _buildPdfHeaderCellWithPadding('STATUS', PdfColors.black, padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
//   ],
// ),

//         // Sample Data
//         _buildPdfDataRow('PATIENT CARE', '', '', 'Admit 20 patients per month', 'March 2020', ''),
//         _buildPdfDataRow('RESEARCH', '', '', 'Submit 1 case report to Elsevier', 'May 2022', ''),
//         _buildPdfDataRow('LINKAGES', '', '', 'Community Screening Services', 'Aug 2022', ''),
//         _buildPdfDataRow('HR', '', '', '4-6 Residents Hired', 'Dec 2022', ''),
//       ],
//     );
//   }

// pw.Widget _buildPdfHeaderCellWithPadding(String text, PdfColor color, {double fontSize = 12, required pw.EdgeInsets padding}) {
//   return pw.Container(
//     padding: padding, // Different padding per row
//     child: pw.Text(
//       text,
//       style: pw.TextStyle(
//         color: color,
//         fontSize: fontSize,
//         fontWeight: pw.FontWeight.bold,
//       ),
//       textAlign: pw.TextAlign.center,
//     ),
//   );
// }

//   pw.TableRow _buildPdfDataRow(String kra, String direct, String indirect, String deliverables, String byWhen, String status) {
//   return pw.TableRow(
//     children: [
//       // KRA Column - Bold Text
//       pw.Container(
//         padding: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//         child: pw.Text(
//           kra,
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold, 
//           ),
//         ),
//       ),
    
//       _buildPdfCell(direct),
//       _buildPdfCell(indirect),
//       _buildPdfCell(deliverables),
//       _buildPdfCell(byWhen),
//       _buildPdfCell(status),
//     ],
//   );
// }

//   pw.Widget _buildPdfCell(String text) {
//     return pw.Container(
//       padding: pw.EdgeInsets.symmetric(vertical: 13, horizontal: 8),
//       child: pw.Text(
//         text,
//         style: pw.TextStyle(fontSize: 12), // Regular Text
//       ),
//     );
//   }
// }