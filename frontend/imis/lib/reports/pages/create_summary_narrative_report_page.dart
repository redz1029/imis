// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/navigation/navigation_panel.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/reports/services/summary_narrative_service.dart';

class CreateSummaryNarrativeReportPage extends StatefulWidget {
  final int periodId;
  const CreateSummaryNarrativeReportPage({super.key, required this.periodId});

  @override
  CreateSummaryNarrativeReportPageState createState() =>
      CreateSummaryNarrativeReportPageState();
}

class CreateSummaryNarrativeReportPageState
    extends State<CreateSummaryNarrativeReportPage> {
  final _summaryNarrativeService = SummaryNarrativeService(Dio());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _findingsController = TextEditingController();
  final TextEditingController _conclusionsController = TextEditingController();
  final TextEditingController _recommendationsController =
      TextEditingController();
  final dio = Dio();
  late final int _periodId;
  @override
  void initState() {
    super.initState();
    _periodId = widget.periodId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder:
                                  (context) => const NavigationPanel(
                                    initialScreenIndex: 17,
                                  ),
                            ),
                            (route) => false,
                          ),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text(
                        "Back",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBgColor,
                        foregroundColor: primaryTextColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade400,
                          width: 0.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Create Report - Q2 2024',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Enter your findings, conclusions, and recommendations",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    bool? confirmAction = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Confirm Save"),
                          content: Text(
                            "Are you sure you want to save this record?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                "No",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },

                              child: Text(
                                "Yes",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmAction == true) {
                      final summaryNarrative = PgsSummaryNarrative(
                        0,
                        _periodId,
                        _findingsController.text,
                        _recommendationsController.text,
                        _conclusionsController.text,
                        isDeleted: false,
                        rowVersion: '',
                      );
                      await _summaryNarrativeService.addSummaryNarrative(
                        summaryNarrative,
                      );
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: const Text("Save Report"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),

            gap32px,

            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 900,
                  maxHeight: 1000,
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Report Details - Q2 2024',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      gap48px,
                      _buildReportSection(
                        icon: Icons.error_outline_rounded,
                        iconColor: Colors.blue,
                        title: "Key Findings",
                        description:
                            "These will be displayed as separate points in the report.",
                        controller: _findingsController,
                      ),
                      const SizedBox(height: 24),
                      _buildReportSection(
                        icon: Icons.check_circle_outline,
                        iconColor: Colors.green,
                        title: "Conclusions",
                        description:
                            "These should summarize your analysis and insights.",
                        controller: _conclusionsController,
                      ),
                      const SizedBox(height: 24),
                      _buildReportSection(
                        title: "Recommendations",
                        icon: Icons.trending_up,
                        iconColor: Colors.deepOrangeAccent,
                        description:
                            "These should be actionable steps for improvement.",
                        controller: _recommendationsController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportSection({
    required String title,
    required String description,
    required TextEditingController controller,
    IconData icon = Icons.description_outlined,
    Color iconColor = Colors.black54,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title with Icon
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Section Description
        Text(
          description,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 12),

        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: TextField(
                style: TextStyle(fontSize: 14),
                controller: controller,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type here...",
                  hintStyle: TextStyle(color: grey),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
