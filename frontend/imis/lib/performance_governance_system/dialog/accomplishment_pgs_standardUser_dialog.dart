// // ignore_for_file: use_build_context_synchronously, file_names

// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:imis/constant/constant.dart';
// import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
// import 'package:imis/performance_governance_system/enum/pgs_status.dart';
// import 'package:imis/utils/api_endpoint.dart';
// import 'package:imis/utils/auth_util.dart';
// import 'package:imis/performance_governance_system/deliverable_status_monitoring/dialog/accomplishment_pgs_auditor_dialog.dart';
// import 'package:intl/intl.dart';
// import 'package:motion_toast/motion_toast.dart';
// import 'package:universal_html/html.dart' as html;
// import '../../constant/permissions.dart';
// import '../../utils/permission_service.dart';

// final _accomplishmentService = DeliverableStatusMonitoringService(dio);
// final permissionService = PermissionService();

// class AccomplishmentPgsStandarduserDialog extends StatefulWidget {
//   final DateTime date;
//   final TrackingRowData row;
//   final void Function(PgsStatus newStatus)? onStatusChanged;
//   const AccomplishmentPgsStandarduserDialog({
//     super.key,
//     required this.date,
//     required this.row,
//     this.onStatusChanged,
//   });

//   @override
//   State<AccomplishmentPgsStandarduserDialog> createState() =>
//       AccomplishmentStandarduserDialogState();
// }

// class AccomplishmentStandarduserDialogState
//     extends State<AccomplishmentPgsStandarduserDialog> {
//   Uint8List? webImage;
//   File? mobileImage;
//   String? fileName;
//   final Dio dio = Dio();
//   bool isLoading = false;
//   Uint8List? _serverImageCache;

//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     super.initState();
//     _prefetchServerImage();
//   }

//   Future<void> _prefetchServerImage() async {
//     final row = widget.row;
//     if (row.accomplishmentId == null) return;
//     if (row.attachmentBytes != null) return;

//     final name = row.attachmentPath?.split("/").last ?? "";
//     if (name.toLowerCase().endsWith('.pdf')) return;
//     if (name.isEmpty) return;

//     try {
//       final loggedUser = await AuthUtil.processTokenValidity(dio, context);
//       final token = loggedUser?.accessToken;
//       if (token == null) return;

//       final previewUrl =
//           "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/preview";

//       final response = await dio.get<List<int>>(
//         previewUrl,
//         options: Options(
//           responseType: ResponseType.bytes,
//           headers: {"Authorization": "Bearer $token"},
//         ),
//       );

//       if (mounted) {
//         setState(() {
//           _serverImageCache = Uint8List.fromList(response.data!);
//         });
//       }
//     } catch (e) {
//       debugPrint("Thumbnail prefetch failed: $e");
//     }
//   }

//   Future<void> pickFile() async {
//     setState(() => isLoading = true);

//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'],
//         allowMultiple: false,
//         withData: true,
//       );

//       if (result != null) {
//         final file = result.files.first;
//         final pickedFile = result.files.first;

//         const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'];
//         final ext = (pickedFile.extension ?? '').toLowerCase();
//         if (!allowedExtensions.contains(ext)) {
//           MotionToast.error(
//             title: const Text("Invalid File Type"),
//             description: Text(
//               '".$ext" is not supported. Please upload a PDF or image (jpg, jpeg, png, gif, webp).',
//             ),
//             toastDuration: const Duration(seconds: 4),
//             toastAlignment: Alignment.topCenter,
//           ).show(context);
//           setState(() => isLoading = false);
//           return;
//         }

//         final fileSizeInMB = file.size / (1024 * 1024);
//         if (fileSizeInMB > 10) {
//           MotionToast.warning(
//             description: const Text(
//               "File too large! Maximum allowed size is 10 MB.",
//             ),
//             toastDuration: const Duration(seconds: 3),
//             toastAlignment: Alignment.topCenter,
//           ).show(context);
//           setState(() => isLoading = false);
//           return;
//         }

//         if (kIsWeb) {
//           Uint8List? bytes = pickedFile.bytes;
//           if (bytes != null) {
//             setState(() {
//               webImage = bytes;
//               fileName = pickedFile.name;
//               widget.row.attachmentPath = pickedFile.name;
//               widget.row.attachmentBytes = bytes;
//               widget.row.attachmentDeleted = false;
//             });
//           }
//         } else {
//           File file = File(pickedFile.path!);
//           Uint8List bytes = await file.readAsBytes();
//           setState(() {
//             mobileImage = file;
//             fileName = pickedFile.name;
//             widget.row.attachmentPath = file.path;
//             widget.row.attachmentBytes = bytes;
//             widget.row.attachmentDeleted = false;
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint("File picking failed: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Uint8List? get _thumbnailBytes {
//     if (widget.row.attachmentBytes != null) return widget.row.attachmentBytes;
//     return _serverImageCache;
//   }

//   void _showTooltip(BuildContext context, String message) {
//     _removeTooltip();

//     final renderBox = context.findRenderObject() as RenderBox?;
//     if (renderBox == null) return;
//     final offset = renderBox.localToGlobal(Offset.zero);

//     _overlayEntry = OverlayEntry(
//       builder:
//           (context) => Positioned(
//             left: offset.dx - 20,
//             top: offset.dy - 40,
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.black87,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   message,
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//             ),
//           ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);

//     Future.delayed(const Duration(seconds: 2), _removeTooltip);
//   }

//   void _removeTooltip() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final remarksController = widget.row.remarksController;
//     final percentageController = widget.row.percentageController;
//     final selectedStatus = widget.row.status;
//     final remarksAuditorController = widget.row.auditorRemarksController;
//     final statusDescriptions = {
//       PgsStatus.notStarted:
//           "Deliverable has been defined but work has not yet begun",
//       PgsStatus.onGoing:
//           "Deliverable is in progress and may be on hold pending decisions or resources",
//       PgsStatus.completed:
//           "Deliverable has been finished and meets PGS requirements",
//     };
//     final statusDisplayNames = {
//       PgsStatus.notStarted: "Not Started",
//       PgsStatus.onGoing: "On Going",
//       PgsStatus.completed: "Completed",
//     };

//     final canEdit = permissionService.hasPermission(
//       AppPermissions.editPgsDeliverableAccomplishment,
//     );
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               DateFormat("MMMM yyyy").format(widget.date),
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: ValueListenableBuilder<PgsStatus>(
//               valueListenable: selectedStatus,
//               builder: (context, status, _) {
//                 if (!canEdit) {
//                   return Center(
//                     child: Tooltip(
//                       message:
//                           statusDescriptions[status] ??
//                           statusDisplayNames[status]!,
//                       child: Text(statusDisplayNames[status]!),
//                     ),
//                   );
//                 }
//                 return Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 6),
//                   child: DropdownButtonFormField<PgsStatus>(
//                     initialValue: status,
//                     isExpanded: true,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.all(8.0),
//                     ),
//                     onChanged: (newValue) {
//                       if (newValue == null) return;

//                       selectedStatus.value = newValue;

//                       if (newValue == PgsStatus.completed) {
//                         percentageController.text = '100';
//                       } else if (newValue == PgsStatus.notStarted) {
//                         percentageController.text = '0';
//                       } else if (newValue == PgsStatus.onGoing &&
//                           (int.tryParse(percentageController.text) ?? 0) >=
//                               100) {
//                         percentageController.text = '1';
//                       }

//                       widget.onStatusChanged?.call(newValue);
//                     },
//                     items:
//                         PgsStatus.values.map((value) {
//                           return DropdownMenuItem<PgsStatus>(
//                             value: value,
//                             child: Tooltip(
//                               message:
//                                   statusDescriptions[value] ??
//                                   statusDisplayNames[value],
//                               child: Text(
//                                 statusDisplayNames[value]!,
//                                 style: const TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                   ),
//                 );
//               },
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: ValueListenableBuilder<PgsStatus>(
//               valueListenable: selectedStatus,
//               builder: (context, status, _) {
//                 if (status == PgsStatus.onGoing &&
//                     percentageController.text == '0') {
//                   percentageController.text = '1';
//                 } else if (status == PgsStatus.notStarted &&
//                     percentageController.text != '0') {
//                   percentageController.text = '0';
//                 } else if (status == PgsStatus.completed &&
//                     (int.tryParse(percentageController.text) ?? 0) < 100) {
//                   percentageController.text = '100';
//                 }
//                 return ValueListenableBuilder<TextEditingValue>(
//                   valueListenable: percentageController,
//                   builder: (context, value, __) {
//                     int progress = int.tryParse(value.text) ?? 0;
//                     double progressFraction;
//                     Color progressColor;

//                     if (status == PgsStatus.onGoing && progress == 0) {
//                       progressFraction = 0.0;
//                       progressColor = Colors.orange;
//                     } else if (progress == 100) {
//                       progressFraction = 1.0;
//                       progressColor = Colors.green;
//                     } else if (progress == 0) {
//                       progressFraction = 1.0;
//                       progressColor = Colors.red;
//                     } else {
//                       progressFraction = progress / 100.0;
//                       progressColor = Colors.orange;
//                     }
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             SizedBox(
//                               width: 60,
//                               height: 60,
//                               child: CircularProgressIndicator(
//                                 value: progressFraction,
//                                 strokeWidth: 6,
//                                 backgroundColor: Colors.grey[300],
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   progressColor,
//                                 ),
//                               ),
//                             ),

//                             SizedBox(
//                               width: 40,
//                               height: 40,
//                               child: Center(
//                                 child:
//                                     canEdit
//                                         ? Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Focus(
//                                               onFocusChange: (hasFocus) {
//                                                 if (hasFocus &&
//                                                     status ==
//                                                         PgsStatus.onGoing) {
//                                                   _showTooltip(
//                                                     context,
//                                                     'Enter value from 1–99 only',
//                                                   );
//                                                 }
//                                               },
//                                               child: SizedBox(
//                                                 width: 30,
//                                                 child: TextField(
//                                                   controller:
//                                                       percentageController,
//                                                   textAlign: TextAlign.center,
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                   keyboardType:
//                                                       TextInputType.number,
//                                                   readOnly:
//                                                       selectedStatus.value ==
//                                                       PgsStatus.notStarted,
//                                                   decoration:
//                                                       const InputDecoration(
//                                                         border:
//                                                             InputBorder.none,
//                                                         isDense: true,
//                                                         contentPadding:
//                                                             EdgeInsets.symmetric(
//                                                               horizontal: 0,
//                                                               vertical: 12,
//                                                             ),
//                                                       ),
//                                                   onTap: () {
//                                                     if (status ==
//                                                         PgsStatus.onGoing) {
//                                                       _showTooltip(
//                                                         context,
//                                                         'Enter value from 1–99 only',
//                                                       );
//                                                     }
//                                                     if (status ==
//                                                         PgsStatus.completed) {
//                                                       _showTooltip(
//                                                         context,
//                                                         'Enter value from 100–999 only',
//                                                       );
//                                                     }
//                                                   },
//                                                   onChanged: (val) {
//                                                     if (status ==
//                                                         PgsStatus.onGoing) {
//                                                       _showTooltip(
//                                                         context,
//                                                         'Enter score from 1–99 only',
//                                                       );
//                                                     }
//                                                     if (status ==
//                                                         PgsStatus.completed) {
//                                                       _showTooltip(
//                                                         context,
//                                                         'Enter score from 100–999 only',
//                                                       );
//                                                     }
//                                                     if (val.isEmpty) return;
//                                                     int parsed =
//                                                         int.tryParse(val) ?? 0;

//                                                     if (selectedStatus.value ==
//                                                         PgsStatus.completed) {
//                                                       if (parsed < 100 &&
//                                                           val.length >= 3) {
//                                                         percentageController
//                                                             .text = '100';
//                                                       } else if (parsed > 999) {
//                                                         percentageController
//                                                             .text = '999';
//                                                       }
//                                                     } else if (selectedStatus
//                                                             .value ==
//                                                         PgsStatus.onGoing) {
//                                                       if (parsed < 1 &&
//                                                           val.isNotEmpty) {
//                                                         percentageController
//                                                             .text = '1';
//                                                       } else if (parsed > 99) {
//                                                         percentageController
//                                                             .text = '99';
//                                                       }
//                                                     } else if (selectedStatus
//                                                             .value ==
//                                                         PgsStatus.notStarted) {
//                                                       if (parsed != 0) {
//                                                         percentageController
//                                                             .text = '0';
//                                                       }
//                                                     }

//                                                     percentageController
//                                                             .selection =
//                                                         TextSelection.fromPosition(
//                                                           TextPosition(
//                                                             offset:
//                                                                 percentageController
//                                                                     .text
//                                                                     .length,
//                                                           ),
//                                                         );
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                             const Text(
//                                               '%',
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ],
//                                         )
//                                         : Text(
//                                           '${value.text}%',
//                                           style: const TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           Expanded(
//             flex: 3,
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(minHeight: 50.0),
//               child:
//                   canEdit
//                       ? TextField(
//                         controller: remarksController,
//                         maxLines: null,
//                         keyboardType: TextInputType.multiline,
//                         style: const TextStyle(fontSize: 14.0),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: grey),
//                           ),
//                           contentPadding: const EdgeInsets.all(8.0),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: primaryColor),
//                           ),
//                         ),
//                       )
//                       : Center(
//                         child: Text(
//                           remarksController.text.isEmpty
//                               ? "No remarks"
//                               : remarksController.text,
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ),
//             ),
//           ),

//           const SizedBox(width: 20),

//           Expanded(
//             flex: 2,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 6),
//               child: Builder(
//                 builder: (context) {
//                   final hasAttachment =
//                       widget.row.attachmentPath != null &&
//                       widget.row.attachmentPath!.isNotEmpty;

//                   final rawName =
//                       fileName ??
//                       widget.row.attachmentPath?.split("/").last ??
//                       "Attachment";

//                   final fileNameToUse =
//                       rawName.contains('_')
//                           ? rawName.substring(rawName.indexOf('_') + 1)
//                           : rawName;
//                   final isPdf = fileNameToUse.toLowerCase().endsWith('.pdf');
//                   final isImage = !isPdf;

//                   if (!hasAttachment &&
//                       webImage == null &&
//                       mobileImage == null) {
//                     return Column(
//                       children: [
//                         IconButton(
//                           icon: const Icon(
//                             Icons.upload_file_outlined,
//                             color: Colors.blue,
//                           ),
//                           onPressed: canEdit ? pickFile : null,
//                         ),
//                         Text(
//                           'Upload 1 supported file: PDF or image (Max 10 MB)',
//                           style: TextStyle(color: grey, fontSize: 10),
//                         ),
//                       ],
//                     );
//                   }
//                   if (isImage) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   final imageBytes = _thumbnailBytes;
//                                   if (imageBytes == null) return;
//                                   showDialog(
//                                     context: context,
//                                     builder:
//                                         (_) => Dialog(
//                                           child: InteractiveViewer(
//                                             child: Image.memory(
//                                               imageBytes,
//                                               fit: BoxFit.contain,
//                                             ),
//                                           ),
//                                         ),
//                                   );
//                                 },
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(6),
//                                   child:
//                                       _thumbnailBytes != null
//                                           ? Image.memory(
//                                             _thumbnailBytes!,
//                                             height: 80,
//                                             width: double.infinity,
//                                             fit: BoxFit.cover,
//                                           )
//                                           : Container(
//                                             height: 80,
//                                             color: Colors.grey.shade200,
//                                             child: const Center(
//                                               child: CircularProgressIndicator(
//                                                 strokeWidth: 2,
//                                               ),
//                                             ),
//                                           ),
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(width: 6),

//                             IconButton(
//                               icon: const Icon(
//                                 Icons.delete,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   webImage = null;
//                                   mobileImage = null;
//                                   fileName = null;

//                                   widget.row.attachmentBytes = null;
//                                   widget.row.attachmentPath = null;

//                                   widget.row.attachmentDeleted = true;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 4),

//                         Text(
//                           fileNameToUse,
//                           style: const TextStyle(
//                             color: Colors.blue,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                   return Row(
//                     children: [
//                       const Icon(Icons.picture_as_pdf, color: Colors.red),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () async {
//                             if (widget.row.attachmentBytes != null) {
//                               final blob = html.Blob([
//                                 widget.row.attachmentBytes!,
//                               ], 'application/pdf');
//                               final url = html.Url.createObjectUrlFromBlob(
//                                 blob,
//                               );
//                               html.window.open(url, "_blank");
//                               Future.delayed(
//                                 const Duration(minutes: 1),
//                                 () => html.Url.revokeObjectUrl(url),
//                               );
//                               return;
//                             }

//                             if (widget.row.accomplishmentId == null) return;
//                             final url =
//                                 '${ApiEndpoint.baseUrl}/${widget.row.accomplishmentId}/preview';
//                             html.window.open(url, "_blank");
//                           },
//                           child: Text(
//                             fileNameToUse,
//                             style: const TextStyle(
//                               color: Colors.blue,
//                               decoration: TextDecoration.underline,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.grey),
//                         onPressed: () {
//                           setState(() {
//                             webImage = null;
//                             mobileImage = null;
//                             fileName = null;

//                             widget.row.attachmentBytes = null;
//                             widget.row.attachmentPath = null;

//                             widget.row.attachmentDeleted = true;
//                           });
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             flex: 3,
//             child: Center(
//               child: ValueListenableBuilder<TextEditingValue>(
//                 valueListenable: remarksAuditorController,
//                 builder: (context, value, _) {
//                   return Text(
//                     value.text.isEmpty ? 'No remarks' : value.text,
//                     style: const TextStyle(fontSize: 14.0),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AccomplishmentListView extends StatefulWidget {
//   final int index;
//   final int deliverableId;
//   final List<DateTime> startAndEndDates;

//   const AccomplishmentListView({
//     super.key,
//     required this.index,
//     required this.startAndEndDates,
//     required this.deliverableId,
//   });

//   @override
//   State<AccomplishmentListView> createState() => _AccomplishmentListViewState();
// }

// class _AccomplishmentListViewState extends State<AccomplishmentListView> {
//   @override
//   void initState() {
//     super.initState();
//     loadAccomplishments(widget.deliverableId, widget.startAndEndDates).then((
//       _,
//     ) {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     achievementsList.putIfAbsent(
//       widget.deliverableId,
//       () => AchievementPeriodData(rows: []),
//     );

//     while (achievementsList[widget.deliverableId]!.rows.length <
//         widget.startAndEndDates.length) {
//       final idx = achievementsList[widget.deliverableId]!.rows.length;
//       achievementsList[widget.deliverableId]!.rows.add(
//         TrackingRowData(
//           date: widget.startAndEndDates[idx],
//           remarksController: TextEditingController(),
//           percentageController: TextEditingController(text: '0'),
//           status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
//           auditorRemarksController: TextEditingController(),
//         ),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: widget.startAndEndDates.length,
//       itemBuilder: (context, i) {
//         final row = achievementsList[widget.deliverableId]!.rows[i];
//         return Column(
//           children: [
//             AccomplishmentPgsStandarduserDialog(
//               date: widget.startAndEndDates[i],
//               row: row,
//               onStatusChanged: (newStatus) {
//                 final rows = achievementsList[widget.deliverableId]!.rows;

//                 if (newStatus == PgsStatus.completed) {
//                   for (int j = i + 1; j < rows.length; j++) {
//                     rows[j].status.value = PgsStatus.completed;
//                     rows[j].percentageController.text = '100';
//                   }
//                 }

//                 if (mounted) setState(() {});
//               },
//             ),
//             if (i != widget.startAndEndDates.length - 1)
//               const Divider(height: 1),
//           ],
//         );
//       },
//     );
//   }
// }

// Future<void> saveAccomplishmentDataStandardUser(
//   int currentDeliverableId,
//   String userId,
// ) async {
//   final periodData = achievementsList[currentDeliverableId];
//   if (periodData == null) return;

//   for (var row in periodData.rows) {
//     final postingDate =
//         row.date != null
//             ? DateTime(row.date!.year, row.date!.month, 1).toIso8601String()
//             : null;

//     final hasNewFile = row.attachmentBytes != null;

//     MultipartFile? attachment;
//     if (hasNewFile) {
//       if (!kIsWeb && row.attachmentPath != null) {
//         attachment = await MultipartFile.fromFile(
//           row.attachmentPath!,
//           filename: row.attachmentPath!.split("/").last,
//         );
//       } else if (kIsWeb) {
//         attachment = MultipartFile.fromBytes(
//           row.attachmentBytes!,
//           filename: row.attachmentPath?.split("/").last ?? "upload.bin",
//         );
//       }
//     }

//     final data = {
//       if (row.accomplishmentId != null) "id": row.accomplishmentId,
//       "pgsDeliverableId": currentDeliverableId,
//       if (postingDate != null) "postingDate": postingDate,
//       "userId": userId,
//       "status": row.status.value.toInt(),
//       "percentAccomplished":
//           double.tryParse(row.percentageController.text) ?? 0,
//       "remarks": row.remarksController.text,
//       "auditorRemarks": row.auditorRemarksController.text,
//       "removeAttachment": row.attachmentDeleted && !hasNewFile,
//     };

//     final formData = FormData.fromMap({
//       ...data,
//       if (attachment != null) "file": attachment,
//     });

//     try {
//       await _accomplishmentService.saveAccomplishment(
//         formData,
//         id: row.accomplishmentId,
//       );
//     } catch (e) {
//       debugPrint("Failed to save accomplishment: $e");
//     }
//   }
// }

// Future<void> loadAccomplishments(
//   int deliverableId,
//   List<DateTime> startAndEndDates,
// ) async {
//   try {
//     final accomplishments = await _accomplishmentService.fetchAccomplishments(
//       deliverableId,
//     );

//     final rows =
//         accomplishments.asMap().entries.map((entry) {
//           final i = entry.key;
//           final acc = entry.value;
//           final percent = acc.percentAccomplished ?? 0;

//           final DateTime rowDate =
//               i < startAndEndDates.length
//                   ? DateTime(
//                     startAndEndDates[i].year,
//                     startAndEndDates[i].month,
//                     1,
//                   )
//                   : DateTime(acc.postingDate.year, acc.postingDate.month, 1);

//           return TrackingRowData(
//             date: rowDate,
//             remarksController: TextEditingController(text: acc.remarks),
//             percentageController: TextEditingController(
//               text: percent.toString(),
//             ),
//             status: ValueNotifier<PgsStatus>(
//               acc.status != null
//                   ? PgsStatusExtension.fromInt(acc.status!)
//                   : _deriveStatusFromPercent(percent),
//             ),
//             auditorRemarksController: TextEditingController(
//               text: acc.auditorRemarks,
//             ),
//             attachmentPath: acc.attachmentPath,
//             attachmentBytes: null,
//             accomplishmentId: acc.id,
//           );
//         }).toList();

//     final dio = Dio();
//     final loggedUser = await AuthUtil.processTokenValidity(dio, null);
//     final token = loggedUser?.accessToken;

//     if (token != null) {
//       await Future.wait(
//         rows.map((row) async {
//           if (row.accomplishmentId == null) return;
//           final name = row.attachmentPath?.split("/").last ?? "";
//           if (name.isEmpty || name.toLowerCase().endsWith('.pdf')) return;

//           try {
//             final response = await dio.get<List<int>>(
//               "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/preview",
//               options: Options(
//                 responseType: ResponseType.bytes,
//                 headers: {"Authorization": "Bearer $token"},
//               ),
//             );
//             row.attachmentBytes = Uint8List.fromList(response.data!);
//           } catch (e) {
//             debugPrint(
//               "Thumbnail fetch failed for ${row.accomplishmentId}: $e",
//             );
//           }
//         }),
//       );
//     }

//     achievementsList[deliverableId] = AchievementPeriodData(rows: rows);
//   } catch (e) {
//     debugPrint(
//       "Failed to load accomplishments for deliverable $deliverableId: $e",
//     );
//   }
// }

// PgsStatus _deriveStatusFromPercent(int percent) {
//   if (percent >= 100) return PgsStatus.completed;
//   if (percent > 0) return PgsStatus.onGoing;
//   return PgsStatus.notStarted;
// }
// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/dialog/accomplishment_pgs_auditor_dialog.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:universal_html/html.dart' as html;
import '../../constant/permissions.dart';
import '../../utils/permission_service.dart';

final _accomplishmentService = DeliverableStatusMonitoringService(dio);
final permissionService = PermissionService();

class AccomplishmentPgsStandarduserDialog extends StatefulWidget {
  final DateTime date;
  final TrackingRowData row;
  final void Function(PgsStatus newStatus)? onStatusChanged;
  const AccomplishmentPgsStandarduserDialog({
    super.key,
    required this.date,
    required this.row,
    this.onStatusChanged,
  });

  @override
  State<AccomplishmentPgsStandarduserDialog> createState() =>
      AccomplishmentStandarduserDialogState();
}

class AccomplishmentStandarduserDialogState
    extends State<AccomplishmentPgsStandarduserDialog> {
  Uint8List? webImage;
  File? mobileImage;
  String? fileName;
  final Dio dio = Dio();
  bool isLoading = false;
  Uint8List? _serverImageCache;

  OverlayEntry? _overlayEntry;

  static const _statusDescriptions = {
    PgsStatus.notStarted:
        "Deliverable has been defined but work has not yet begun",
    PgsStatus.onGoing:
        "Deliverable is in progress and may be on hold pending decisions or resources",
    PgsStatus.completed:
        "Deliverable has been finished and meets PGS requirements",
  };

  static const _statusDisplayNames = {
    PgsStatus.notStarted: "Not Started",
    PgsStatus.onGoing: "On Going",
    PgsStatus.completed: "Completed",
  };

  @override
  void initState() {
    super.initState();
    _prefetchServerImage();
  }

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  Future<void> _prefetchServerImage() async {
    final row = widget.row;
    if (row.accomplishmentId == null) return;
    if (row.attachmentBytes != null) return;

    final name = row.attachmentPath?.split("/").last ?? "";
    if (name.toLowerCase().endsWith('.pdf')) return;
    if (name.isEmpty) return;

    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      final token = loggedUser?.accessToken;
      if (token == null) return;

      final previewUrl =
          "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/preview";

      final response = await dio.get<List<int>>(
        previewUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (mounted) {
        setState(() {
          _serverImageCache = Uint8List.fromList(response.data!);
        });
      }
    } catch (e) {
      debugPrint("Thumbnail prefetch failed: $e");
    }
  }

  Future<void> pickFile() async {
    setState(() => isLoading = true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null) {
        final file = result.files.first;
        final pickedFile = result.files.first;

        const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'];
        final ext = (pickedFile.extension ?? '').toLowerCase();
        if (!allowedExtensions.contains(ext)) {
          MotionToast.error(
            title: const Text("Invalid File Type"),
            description: Text(
              '".$ext" is not supported. Please upload a PDF or image (jpg, jpeg, png, gif, webp).',
            ),
            toastDuration: const Duration(seconds: 4),
            toastAlignment: Alignment.topCenter,
          ).show(context);
          setState(() => isLoading = false);
          return;
        }

        final fileSizeInMB = file.size / (1024 * 1024);
        if (fileSizeInMB > 10) {
          MotionToast.warning(
            description: const Text(
              "File too large! Maximum allowed size is 10 MB.",
            ),
            toastDuration: const Duration(seconds: 3),
            toastAlignment: Alignment.topCenter,
          ).show(context);
          setState(() => isLoading = false);
          return;
        }

        if (kIsWeb) {
          Uint8List? bytes = pickedFile.bytes;
          if (bytes != null) {
            setState(() {
              webImage = bytes;
              fileName = pickedFile.name;
              widget.row.attachmentPath = pickedFile.name;
              widget.row.attachmentBytes = bytes;
              widget.row.attachmentDeleted = false;
            });
          }
        } else {
          File file = File(pickedFile.path!);
          Uint8List bytes = await file.readAsBytes();
          setState(() {
            mobileImage = file;
            fileName = pickedFile.name;
            widget.row.attachmentPath = file.path;
            widget.row.attachmentBytes = bytes;
            widget.row.attachmentDeleted = false;
          });
        }
      }
    } catch (e) {
      debugPrint("File picking failed: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Uint8List? get _thumbnailBytes {
    if (widget.row.attachmentBytes != null) return widget.row.attachmentBytes;
    return _serverImageCache;
  }

  void _showTooltip(BuildContext context, String message) {
    _removeTooltip();

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx < 8 ? 8 : offset.dx,
            top: offset.dy - 40,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), _removeTooltip);
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _clearAttachment() {
    setState(() {
      webImage = null;
      mobileImage = null;
      fileName = null;
      _serverImageCache = null;

      widget.row.attachmentBytes = null;
      widget.row.attachmentPath = null;
      widget.row.attachmentDeleted = true;
    });
  }

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: grey),
    ),
  );

  Widget _buildStatusField(bool canEdit) {
    final selectedStatus = widget.row.status;
    final percentageController = widget.row.percentageController;

    return ValueListenableBuilder<PgsStatus>(
      valueListenable: selectedStatus,
      builder: (context, status, _) {
        if (!canEdit) {
          return Center(
            child: Tooltip(
              message:
                  _statusDescriptions[status] ?? _statusDisplayNames[status]!,
              child: Text(_statusDisplayNames[status]!),
            ),
          );
        }
        return DropdownButtonFormField<PgsStatus>(
          initialValue: status,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8.0),
            isDense: true,
          ),
          onChanged: (newValue) {
            if (newValue == null) return;

            selectedStatus.value = newValue;

            if (newValue == PgsStatus.completed) {
              percentageController.text = '100';
            } else if (newValue == PgsStatus.notStarted) {
              percentageController.text = '0';
            } else if (newValue == PgsStatus.onGoing &&
                (int.tryParse(percentageController.text) ?? 0) >= 100) {
              percentageController.text = '1';
            }

            widget.onStatusChanged?.call(newValue);
          },
          items:
              PgsStatus.values.map((value) {
                return DropdownMenuItem<PgsStatus>(
                  value: value,
                  child: Tooltip(
                    message:
                        _statusDescriptions[value] ??
                        _statusDisplayNames[value]!,
                    child: Text(
                      _statusDisplayNames[value]!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildProgressField(bool canEdit) {
    final percentageController = widget.row.percentageController;
    final selectedStatus = widget.row.status;

    return ValueListenableBuilder<PgsStatus>(
      valueListenable: selectedStatus,
      builder: (context, status, _) {
        if (status == PgsStatus.onGoing && percentageController.text == '0') {
          percentageController.text = '1';
        } else if (status == PgsStatus.notStarted &&
            percentageController.text != '0') {
          percentageController.text = '0';
        } else if (status == PgsStatus.completed &&
            (int.tryParse(percentageController.text) ?? 0) < 100) {
          percentageController.text = '100';
        }
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: percentageController,
          builder: (context, value, __) {
            int progress = int.tryParse(value.text) ?? 0;
            double progressFraction;
            Color progressColor;

            if (status == PgsStatus.onGoing && progress == 0) {
              progressFraction = 0.0;
              progressColor = Colors.orange;
            } else if (progress == 100) {
              progressFraction = 1.0;
              progressColor = Colors.green;
            } else if (progress == 0) {
              progressFraction = 1.0;
              progressColor = Colors.red;
            } else {
              progressFraction = progress / 100.0;
              progressColor = Colors.orange;
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: progressFraction,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                SizedBox(
                  width: 44,
                  height: 40,
                  child: Center(
                    child:
                        canEdit
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    if (hasFocus &&
                                        status == PgsStatus.onGoing) {
                                      _showTooltip(
                                        context,
                                        'Enter value from 1–99 only',
                                      );
                                    }
                                  },
                                  child: SizedBox(
                                    width: 34,
                                    child: TextField(
                                      controller: percentageController,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      keyboardType: TextInputType.number,
                                      readOnly:
                                          selectedStatus.value ==
                                          PgsStatus.notStarted,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: 12,
                                        ),
                                      ),
                                      onTap: () {
                                        if (status == PgsStatus.onGoing) {
                                          _showTooltip(
                                            context,
                                            'Enter value from 1–99 only',
                                          );
                                        }
                                        if (status == PgsStatus.completed) {
                                          _showTooltip(
                                            context,
                                            'Enter value from 100–999 only',
                                          );
                                        }
                                      },
                                      onChanged: (val) {
                                        if (status == PgsStatus.onGoing) {
                                          _showTooltip(
                                            context,
                                            'Enter score from 1–99 only',
                                          );
                                        }
                                        if (status == PgsStatus.completed) {
                                          _showTooltip(
                                            context,
                                            'Enter score from 100–999 only',
                                          );
                                        }
                                        if (val.isEmpty) return;
                                        int parsed = int.tryParse(val) ?? 0;

                                        if (selectedStatus.value ==
                                            PgsStatus.completed) {
                                          if (parsed < 100 && val.length >= 3) {
                                            percentageController.text = '100';
                                          } else if (parsed > 999) {
                                            percentageController.text = '999';
                                          }
                                        } else if (selectedStatus.value ==
                                            PgsStatus.onGoing) {
                                          if (parsed < 1 && val.isNotEmpty) {
                                            percentageController.text = '1';
                                          } else if (parsed > 99) {
                                            percentageController.text = '99';
                                          }
                                        } else if (selectedStatus.value ==
                                            PgsStatus.notStarted) {
                                          if (parsed != 0) {
                                            percentageController.text = '0';
                                          }
                                        }

                                        percentageController.selection =
                                            TextSelection.fromPosition(
                                              TextPosition(
                                                offset:
                                                    percentageController
                                                        .text
                                                        .length,
                                              ),
                                            );
                                      },
                                    ),
                                  ),
                                ),
                                const Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              '${value.text}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRemarksField(bool canEdit, {bool compact = false}) {
    final remarksController = widget.row.remarksController;
    if (canEdit) {
      return TextField(
        controller: remarksController,
        maxLines: null,
        minLines: compact ? 3 : 1,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 14.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: grey)),
          contentPadding: const EdgeInsets.all(8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      );
    }
    return Text(
      remarksController.text.isEmpty ? "No remarks" : remarksController.text,
      textAlign: compact ? TextAlign.start : TextAlign.center,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildEvaluatorRemarks({bool compact = false}) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.row.auditorRemarksController,
      builder: (context, value, _) {
        return Text(
          value.text.isEmpty ? 'No remarks' : value.text,
          textAlign: compact ? TextAlign.start : TextAlign.center,
          style: const TextStyle(fontSize: 14.0),
        );
      },
    );
  }

  Widget _buildAttachmentField(bool canEdit, {bool compact = false}) {
    final hasAttachment =
        widget.row.attachmentPath != null &&
        widget.row.attachmentPath!.isNotEmpty;

    final rawName =
        fileName ?? widget.row.attachmentPath?.split("/").last ?? "Attachment";

    final fileNameToUse =
        rawName.contains('_')
            ? rawName.substring(rawName.indexOf('_') + 1)
            : rawName;
    final isPdf = fileNameToUse.toLowerCase().endsWith('.pdf');
    final isImage = !isPdf;

    if (!hasAttachment && webImage == null && mobileImage == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.upload_file_outlined, color: Colors.blue),
            onPressed: canEdit ? pickFile : null,
          ),
          Text(
            'Upload 1 supported file: PDF or image (Max 10 MB)',
            textAlign: TextAlign.center,
            style: TextStyle(color: grey, fontSize: 10),
          ),
        ],
      );
    }

    if (isImage) {
      final thumb = _thumbnailBytes;

      Widget thumbnail({double? width}) => GestureDetector(
        onTap: () {
          final imageBytes = _thumbnailBytes;
          if (imageBytes == null) return;
          showDialog(
            context: context,
            builder:
                (_) => Dialog(
                  child: InteractiveViewer(
                    child: Image.memory(imageBytes, fit: BoxFit.contain),
                  ),
                ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child:
              thumb != null
                  ? Image.memory(
                    thumb,
                    height: 80,
                    width: width ?? double.infinity,
                    fit: BoxFit.cover,
                  )
                  : Container(
                    height: 80,
                    width: width ?? double.infinity,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
        ),
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              if (compact)
                thumbnail(width: 120)
              else
                Expanded(child: thumbnail()),
              const SizedBox(width: 6),
              if (canEdit)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: _clearAttachment,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            fileNameToUse,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.picture_as_pdf, color: Colors.red),
        const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onTap: () async {
              if (widget.row.attachmentBytes != null) {
                final blob = html.Blob([
                  widget.row.attachmentBytes!,
                ], 'application/pdf');
                final url = html.Url.createObjectUrlFromBlob(blob);
                html.window.open(url, "_blank");
                Future.delayed(
                  const Duration(minutes: 1),
                  () => html.Url.revokeObjectUrl(url),
                );
                return;
              }

              if (widget.row.accomplishmentId == null) return;
              final url =
                  '${ApiEndpoint.baseUrl}/${widget.row.accomplishmentId}/preview';
              html.window.open(url, "_blank");
            },
            child: Text(
              fileNameToUse,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (canEdit)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: _clearAttachment,
          ),
      ],
    );
  }

  // ───────────────────────────── Layouts ─────────────────────────────

  Widget _buildMobileCard(bool canEdit) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, size: 16, color: primaryColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  DateFormat("MMMM yyyy").format(widget.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_fieldLabel('Status'), _buildStatusField(canEdit)],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  _fieldLabel('% Accomplishment'),
                  _buildProgressField(canEdit),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          _fieldLabel('Remarks (Dept Head)'),
          _buildRemarksField(canEdit, compact: true),
          const SizedBox(height: 14),
          _fieldLabel('Proof'),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildAttachmentField(canEdit, compact: true),
          ),
          const SizedBox(height: 14),
          _fieldLabel('Remarks (Evaluator)'),
          _buildEvaluatorRemarks(compact: true),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(bool canEdit) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              DateFormat("MMMM yyyy").format(widget.date),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildStatusField(canEdit),
            ),
          ),
          Expanded(flex: 2, child: Center(child: _buildProgressField(canEdit))),
          Expanded(
            flex: 3,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50.0),
              child: _buildRemarksField(canEdit),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildAttachmentField(canEdit),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(flex: 3, child: Center(child: _buildEvaluatorRemarks())),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = permissionService.hasPermission(
      AppPermissions.editPgsDeliverableAccomplishment,
    );
    final isMobile =
        MediaQuery.of(context).size.width < kAccomplishmentMobileBreakpoint;

    return isMobile ? _buildMobileCard(canEdit) : _buildDesktopRow(canEdit);
  }
}

class AccomplishmentListView extends StatefulWidget {
  final int index;
  final int deliverableId;
  final List<DateTime> startAndEndDates;

  const AccomplishmentListView({
    super.key,
    required this.index,
    required this.startAndEndDates,
    required this.deliverableId,
  });

  @override
  State<AccomplishmentListView> createState() => _AccomplishmentListViewState();
}

class _AccomplishmentListViewState extends State<AccomplishmentListView> {
  @override
  void initState() {
    super.initState();
    loadAccomplishments(widget.deliverableId, widget.startAndEndDates).then((
      _,
    ) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    achievementsList.putIfAbsent(
      widget.deliverableId,
      () => AchievementPeriodData(rows: []),
    );

    while (achievementsList[widget.deliverableId]!.rows.length <
        widget.startAndEndDates.length) {
      final idx = achievementsList[widget.deliverableId]!.rows.length;
      achievementsList[widget.deliverableId]!.rows.add(
        TrackingRowData(
          date: widget.startAndEndDates[idx],
          remarksController: TextEditingController(),
          percentageController: TextEditingController(text: '0'),
          status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
          auditorRemarksController: TextEditingController(),
        ),
      );
    }

    final isMobile =
        MediaQuery.of(context).size.width < kAccomplishmentMobileBreakpoint;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.startAndEndDates.length,
      itemBuilder: (context, i) {
        final row = achievementsList[widget.deliverableId]!.rows[i];
        return Column(
          children: [
            AccomplishmentPgsStandarduserDialog(
              date: widget.startAndEndDates[i],
              row: row,
              onStatusChanged: (newStatus) {
                final rows = achievementsList[widget.deliverableId]!.rows;

                if (newStatus == PgsStatus.completed) {
                  for (int j = i + 1; j < rows.length; j++) {
                    rows[j].status.value = PgsStatus.completed;
                    rows[j].percentageController.text = '100';
                  }
                }

                if (mounted) setState(() {});
              },
            ),
            if (!isMobile && i != widget.startAndEndDates.length - 1)
              const Divider(height: 1),
          ],
        );
      },
    );
  }
}

Future<void> saveAccomplishmentDataStandardUser(
  int currentDeliverableId,
  String userId,
) async {
  final periodData = achievementsList[currentDeliverableId];
  if (periodData == null) return;

  for (var row in periodData.rows) {
    final postingDate =
        row.date != null
            ? DateTime(row.date!.year, row.date!.month, 1).toIso8601String()
            : null;

    final hasNewFile = row.attachmentBytes != null;

    MultipartFile? attachment;
    if (hasNewFile) {
      if (!kIsWeb && row.attachmentPath != null) {
        attachment = await MultipartFile.fromFile(
          row.attachmentPath!,
          filename: row.attachmentPath!.split("/").last,
        );
      } else if (kIsWeb) {
        attachment = MultipartFile.fromBytes(
          row.attachmentBytes!,
          filename: row.attachmentPath?.split("/").last ?? "upload.bin",
        );
      }
    }

    final data = {
      if (row.accomplishmentId != null) "id": row.accomplishmentId,
      "pgsDeliverableId": currentDeliverableId,
      if (postingDate != null) "postingDate": postingDate,
      "userId": userId,
      "status": row.status.value.toInt(),
      "percentAccomplished":
          double.tryParse(row.percentageController.text) ?? 0,
      "remarks": row.remarksController.text,
      "auditorRemarks": row.auditorRemarksController.text,
      "removeAttachment": row.attachmentDeleted && !hasNewFile,
    };

    final formData = FormData.fromMap({
      ...data,
      if (attachment != null) "file": attachment,
    });

    try {
      await _accomplishmentService.saveAccomplishment(
        formData,
        id: row.accomplishmentId,
      );
    } catch (e) {
      debugPrint("Failed to save accomplishment: $e");
    }
  }
}

Future<void> loadAccomplishments(
  int deliverableId,
  List<DateTime> startAndEndDates,
) async {
  try {
    final accomplishments = await _accomplishmentService.fetchAccomplishments(
      deliverableId,
    );

    final rows =
        accomplishments.asMap().entries.map((entry) {
          final i = entry.key;
          final acc = entry.value;
          final percent = acc.percentAccomplished ?? 0;

          final DateTime rowDate =
              i < startAndEndDates.length
                  ? DateTime(
                    startAndEndDates[i].year,
                    startAndEndDates[i].month,
                    1,
                  )
                  : DateTime(acc.postingDate.year, acc.postingDate.month, 1);

          return TrackingRowData(
            date: rowDate,
            remarksController: TextEditingController(text: acc.remarks),
            percentageController: TextEditingController(
              text: percent.toString(),
            ),
            status: ValueNotifier<PgsStatus>(
              acc.status != null
                  ? PgsStatusExtension.fromInt(acc.status!)
                  : _deriveStatusFromPercent(percent),
            ),
            auditorRemarksController: TextEditingController(
              text: acc.auditorRemarks,
            ),
            attachmentPath: acc.attachmentPath,
            attachmentBytes: null,
            accomplishmentId: acc.id,
          );
        }).toList();

    final dio = Dio();
    final loggedUser = await AuthUtil.processTokenValidity(dio, null);
    final token = loggedUser?.accessToken;

    if (token != null) {
      await Future.wait(
        rows.map((row) async {
          if (row.accomplishmentId == null) return;
          final name = row.attachmentPath?.split("/").last ?? "";
          if (name.isEmpty || name.toLowerCase().endsWith('.pdf')) return;

          try {
            final response = await dio.get<List<int>>(
              "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/preview",
              options: Options(
                responseType: ResponseType.bytes,
                headers: {"Authorization": "Bearer $token"},
              ),
            );
            row.attachmentBytes = Uint8List.fromList(response.data!);
          } catch (e) {
            debugPrint(
              "Thumbnail fetch failed for ${row.accomplishmentId}: $e",
            );
          }
        }),
      );
    }

    achievementsList[deliverableId] = AchievementPeriodData(rows: rows);
  } catch (e) {
    debugPrint(
      "Failed to load accomplishments for deliverable $deliverableId: $e",
    );
  }
}

PgsStatus _deriveStatusFromPercent(int percent) {
  if (percent >= 100) return PgsStatus.completed;
  if (percent > 0) return PgsStatus.onGoing;
  return PgsStatus.notStarted;
}
