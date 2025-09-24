// lib/utils/status_utils.dart
import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'NotStarted':
      return Colors.red;
    case 'Ongoing':
      return Colors.orange;
    case 'Completed':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Color getStatusTextColor(String status) {
  switch (status) {
    case 'NotStarted':
      return Colors.red[900]!;
    case 'Ongoing':
      return Colors.orange[900]!;
    case 'Completed':
      return Colors.green[900]!;
    default:
      return Colors.grey[900]!;
  }
}

Widget buildTrackingRow({
  required String period,
  required int periodIndex,
  required int totalPeriods,
  required int deliverableId,
}) {
  final accomplishmentController = TextEditingController();
  final remarksController = TextEditingController();
  final statusController = TextEditingController(text: "Not Started");

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Row(
      children: [
        // Period display
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              period,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),

        // Accomplishment percentage field
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: TextFormField(
              controller: accomplishmentController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "0-100",
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 6,
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final percent = int.tryParse(value) ?? 0;
                if (percent == 0) {
                  statusController.text = "Not Started";
                } else if (percent < 100) {
                  statusController.text = "In Progress";
                } else {
                  statusController.text = "Completed";
                }
              },
            ),
          ),
        ),

        // Remarks field
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: TextFormField(
              controller: remarksController,
              decoration: const InputDecoration(
                hintText: "Enter remarks...",
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 6,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(statusController.text),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusController.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: getStatusTextColor(statusController.text),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Upload button
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: IconButton(
              icon: const Icon(Icons.upload_file, color: Colors.blue),
              onPressed: () {
                uploadDocument(deliverableId, periodIndex, period);
              },
            ),
          ),
        ),
      ],
    ),
  );
}

// Function to handle document upload
void uploadDocument(int deliverableId, int periodIndex, String period) async {
  debugPrint(
    "Upload document for Deliverable: $deliverableId, Period: $period",
  );
}

// Function to save accomplishment data
void saveAccomplishmentData() {
  debugPrint("Saving accomplishment data...");
}
