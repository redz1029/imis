import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class StrategyRoadmapPage extends StatefulWidget {
  const StrategyRoadmapPage({super.key});

  @override
  State<StrategyRoadmapPage> createState() => _RoadmapState();
}

class _RoadmapState extends State<StrategyRoadmapPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Export Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Export as PDF clicked'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      icon: Icon(
                        Icons.download_outlined,
                        size: 18,
                        color: Theme.of(context).cardColor,
                      ),
                      label: Text(
                        "Export as PDF",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: InteractiveViewer(
                        child: Image.asset(
                          'assets/strat_map.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
