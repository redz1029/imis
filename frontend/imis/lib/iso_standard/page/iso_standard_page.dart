// // ignore_for_file: use_build_context_synchronously

// import 'package:data_table_2/data_table_2.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:imis/constant/constant.dart';
// import 'package:imis/iso_standard/models/iso_standard.dart';
// import 'package:imis/iso_standard/service/iso_standard_service.dart';
// import 'package:imis/standard_version/models/standard_version.dart';
// import 'package:imis/utils/api_endpoint.dart';
// import 'package:imis/utils/filter_search_result_util.dart';
// import 'package:imis/utils/pagination_util.dart';
// import 'package:imis/widgets/pagination_controls.dart';
// import 'package:motion_toast/motion_toast.dart';

// class IsoStandardPage extends StatefulWidget {
//   const IsoStandardPage({super.key});

//   @override
//   IsoStandardPageState createState() => IsoStandardPageState();
// }

// class IsoStandardPageState extends State<IsoStandardPage> {
//   final _isoStandardService = IsoStandardService(Dio());
//   final _paginationUtils = PaginationUtil(Dio());
//   late FilterSearchResultUtil<IsoStandard> isoStandardSearchUtil;
//   final _formKey = GlobalKey<FormState>();

//   List<IsoStandard> isoStandardList = [];
//   List<IsoStandard> filteredList = [];
//   TextEditingController searchController = TextEditingController();
//   final FocusNode isSearchfocus = FocusNode();

//   int _currentPage = 1;
//   final int _pageSize = 15;
//   int _totalCount = 0;
//   bool _isLoading = false;

//   final dio = Dio();

//   Future<void> fetchIsoStandards({int page = 1, String? searchQuery}) async {
//     if (_isLoading) return;

//     setState(() => _isLoading = true);

//     try {
//       final pageList = await _isoStandardService.getIsoStandards(
//         page: page,
//         pageSize: _pageSize,
//         searchQuery: searchQuery,
//       );

//       if (mounted) {
//         setState(() {
//           _currentPage = pageList.page;
//           _totalCount = pageList.totalCount;
//           isoStandardList = pageList.items;
//           filteredList = List.from(isoStandardList);
//         });
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchIsoStandards();
//     isoStandardSearchUtil = FilterSearchResultUtil<IsoStandard>(
//       paginationUtils: _paginationUtils,
//       endpoint: ApiEndpoint().isoStandard,
//       pageSize: _pageSize,
//       fromJson: (json) => IsoStandard.fromJson(json),
//     );
//     isSearchfocus.addListener(() {
//       setState(() {});
//     });
//   }

//   Future<void> filterSearchResults(String query) async {
//     final results = await isoStandardSearchUtil.filter(
//       query,
//       (isoStandard, search) =>
//           (isoStandard.description).toLowerCase().contains(search.toLowerCase()) ||
//           (isoStandard.clauseRef).toLowerCase().contains(search.toLowerCase()),
//     );

//     setState(() {
//       filteredList = results;
//     });
//   }

//   @override
//   void dispose() {
//     isSearchfocus.dispose();
//     searchController.dispose();
//     super.dispose();
//   }

//   void showFormDialog({
//     String? id,
//     String? clauseRef,
//     String? description,
//     StandardVersion? version,
//     int? versionID,
//   }) async {
//     TextEditingController clauseRefController =
//         TextEditingController(text: clauseRef);
//     TextEditingController descriptionController =
//         TextEditingController(text: description);
//     TextEditingController versionNameController =
//         TextEditingController(text: version?.versionName ?? '');
//     TextEditingController versionIDController =
//         TextEditingController(text: version?.id.toString() ?? '');

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: mainBgColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           titlePadding: EdgeInsets.zero,
//           title: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//             decoration: BoxDecoration(
//               color: primaryLightColor,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//             ),
//             child: Text(
//               id == null ? 'Create ISO Standard' : 'Edit ISO Standard',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           content: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: 480,
//                   height: 65,
//                   child: TextFormField(
//                     controller: clauseRefController,
//                     decoration: InputDecoration(
//                       labelText: 'Clause Reference',
//                       focusColor: primaryColor,
//                       floatingLabelStyle: TextStyle(color: primaryColor),
//                       border: OutlineInputBorder(),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: primaryColor),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please fill out this field';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 gap16px,
//                 SizedBox(
//                   width: 480,
//                   height: 65,
//                   child: TextFormField(
//                     controller: versionNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Version Name',
//                       focusColor: primaryColor,
//                       floatingLabelStyle: TextStyle(color: primaryColor),
//                       border: OutlineInputBorder(),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: primaryColor),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please fill out this field';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 gap16px,
//                 SizedBox(
//                   width: 480,
//                   height: 100,
//                   child: TextFormField(
//                     controller: descriptionController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       labelText: 'Description',
//                       focusColor: primaryColor,
//                       floatingLabelStyle: TextStyle(color: primaryColor),
//                       border: OutlineInputBorder(),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: primaryColor),
//                       ),
//                       alignLabelWithHint: true,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please fill out this field';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//               child: Text('Cancel', style: TextStyle(color: primaryColor)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   bool? confirmAction = await showDialog<bool>(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: Text(
//                           id == null ? "Confirm Save" : "Confirm Update",
//                         ),
//                         content: Text(
//                           id == null
//                               ? "Are you sure you want to save this record?"
//                               : "Are you sure you want to update this record?",
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: Text(
//                               "No",
//                               style: TextStyle(color: primaryColor),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 Navigator.pop(context, true);
//                               }
//                             },
//                             child: Text(
//                               "Yes",
//                               style: TextStyle(color: primaryColor),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   if (confirmAction == true) {
//                     final standardVersion = StandardVersion(
//                       id: int.tryParse(versionIDController.text) ?? 0,
//                       versionName: versionNameController.text,
//                       isDeleted: false,
//                       isActive: true,
//                     );
//                     final isoStandard = IsoStandard(
//                       id: int.tryParse(id ?? '0') ?? 0,
//                       clauseRef: clauseRefController.text,
//                       description: descriptionController.text,
//                       version: standardVersion,
//                       versionID:
//                           int.tryParse(versionIDController.text) ?? 0,
//                           isdelete: false,
//                       isActive: true,
//                     );
//                     await _isoStandardService
//                         .createOrUpdateIsoStandard(isoStandard);
//                     setState(() {
//                       fetchIsoStandards();
//                     });
//                     MotionToast.success(
//                       toastAlignment: Alignment.topCenter,
//                       description: Text('Saved successfully'),
//                     ).show(context);
//                     Navigator.pop(context);
//                   }
//                 }
//               },
//               child: Text(
//                 id == null ? 'Save' : 'Update',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isMinimized = MediaQuery.of(context).size.width < 600;
//     return Scaffold(
//       backgroundColor: mainBgColor,
//       appBar: AppBar(
//         title: const Text('ISO Standards'),
//         backgroundColor: mainBgColor,
//         elevation: 0,
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isMobile = constraints.maxWidth < 600;

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       height: 30,
//                       width: 300,
//                       child: TextField(
//                         focusNode: isSearchfocus,
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: lightGrey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: primaryColor),
//                           ),
//                           floatingLabelBehavior: FloatingLabelBehavior.never,
//                           labelStyle: TextStyle(color: grey, fontSize: 14),
//                           labelText: 'Search...',
//                           prefixIcon: Icon(
//                             Icons.search,
//                             color: isSearchfocus.hasFocus ? primaryColor : grey,
//                             size: 20,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           filled: true,
//                           fillColor: secondaryColor,
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 5,
//                             horizontal: 5,
//                           ),
//                         ),
//                         onChanged: filterSearchResults,
//                       ),
//                     ),
//                     if (!isMinimized)
//                       ElevatedButton.icon(
//                         onPressed: () => showFormDialog(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 10,
//                             horizontal: 16,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),
//                         icon: const Icon(Icons.add, color: Colors.white),
//                         label: const Text(
//                           'Add New',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: DataTable2(
//                     columnSpacing: isMobile ? 16 : 40,
//                     headingRowColor: WidgetStatePropertyAll(secondaryColor),
//                     dataRowColor: WidgetStatePropertyAll(mainBgColor),
//                     headingTextStyle: const TextStyle(color: grey),
//                     horizontalMargin: 12,
//                     minWidth: constraints.maxWidth,
//                     fixedTopRows: 1,
//                     border: TableBorder(
//                       horizontalInside: BorderSide(color: Colors.grey.shade100),
//                     ),
//                     columns: const [
//                       DataColumn2(label: Text('#'), fixedWidth: 40),
//                       DataColumn2(label: Text('Clause Reference'), size: ColumnSize.L),
//                       DataColumn(label: Text('Version Name')),
//                       DataColumn(label: Text('Description')),
//                       DataColumn(label: Text('Actions')),
//                     ],
//                     rows:
//                         filteredList.asMap().entries.map((entry) {
//                           int index = entry.key;
//                           var isoStandard = entry.value;
//                           int itemNumber =
//                               ((_currentPage - 1) * _pageSize) + index + 1;

//                           return DataRow(
//                             cells: [
//                               DataCell(Text(itemNumber.toString())),
//                               DataCell(Text(isoStandard.clauseRef)),
//                               DataCell(Text(isoStandard.version.versionName)),
//                               DataCell(
//                                 Text(
//                                   isoStandard.description.length > 50
//                                       ? '${isoStandard.description.substring(0, 50)}...'
//                                       : isoStandard.description,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               DataCell(
//                                 Row(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.edit),
//                                       onPressed: () => showFormDialog(
//                                         id: isoStandard.id.toString(),
//                                         clauseRef: isoStandard.clauseRef,
//                                         description: isoStandard.description,
//                                         version: isoStandard.version,
//                                         versionID: isoStandard.versionID,
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(
//                                         Icons.delete,
//                                         color: primaryColor,
//                                       ),
//                                       onPressed: () {
//                                         showDeleteDialog(
//                                             isoStandard.id.toString());
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                   ),
//                 ),

//                 Container(
//                   padding: EdgeInsets.all(10),
//                   color: secondaryColor,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       PaginationInfo(
//                         currentPage: _currentPage,
//                         totalItems: _totalCount,
//                         itemsPerPage: _pageSize,
//                       ),
//                       PaginationControls(
//                         currentPage: _currentPage,
//                         totalItems: _totalCount,
//                         itemsPerPage: _pageSize,
//                         isLoading: _isLoading,
//                         onPageChanged: (page) => fetchIsoStandards(page: page),
//                       ),
//                       Container(width: 60),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),

//       floatingActionButton:
//           isMinimized
//               ? FloatingActionButton(
//                 backgroundColor: primaryColor,
//                 onPressed: () => showFormDialog(),
//                 child: Icon(Icons.add, color: Colors.white),
//               )
//               : null,
//     );
//   }

//   void showDeleteDialog(String id) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Confirm Delete"),
//           content: Text(
//             "Are you sure you want to delete this ISO Standard? This action cannot be undone.",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 try {
//                   await _isoStandardService.deleteIsoStandard(id);
//                   await fetchIsoStandards();
//                   MotionToast.success(
//                     toastAlignment: Alignment.topCenter,
//                     description: Text('ISO Standard deleted successfully'),
//                   ).show(context);
//                 } catch (e) {
//                   MotionToast.error(
//                     description: Text('Failed to Delete ISO Standard'),
//                   ).show(context);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//               child: Text('Delete', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
