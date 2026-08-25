import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/scorecard/dialog/impact_strategy_scorecard_dialog.dart';
import 'package:imis/scorecard/impact_strategic_goal_scorecard_period/models/impact_strategic_goal_scorecard_period.dart';
import 'package:imis/scorecard/models/impact_strategic_goal_scorecard.dart';
import 'package:imis/scorecard/services/impact_strategy_scorecard_services.dart';
import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

class ImpactStrategyGoalScorecardPage extends StatefulWidget {
  const ImpactStrategyGoalScorecardPage({super.key});

  @override
  State<ImpactStrategyGoalScorecardPage> createState() =>
      ImpactStrategyGoalScorecardPageState();
}

class ImpactStrategyGoalScorecardPageState
    extends State<ImpactStrategyGoalScorecardPage> {
  final _impactService = ImpactStrategyScorecardService(Dio());
  final _commonService = CommonService(Dio());

  bool _isLoading = false;
  bool _isLoadingPeriods = true;

  List<ImpactStrategicGoalScoreCard> impactStrategyGoalList = [];
  List<ImpactStrategicGoalScoreCard> filteredList = [];

  List<ImpactStrategicGoalScorecardPeriod> _periods = [];
  ImpactStrategicGoalScorecardPeriod? _selectedPeriod;

  int _currentPage = 1;
  int totalCount = 0;
  final int _pageSize = 15;

  @override
  void initState() {
    super.initState();
    _loadPeriodsThenFetch();
  }

  Future<void> _loadPeriodsThenFetch() async {
    setState(() => _isLoadingPeriods = true);
    try {
      final periods = await _commonService.fetchImpactPeriod();

      if (!mounted) return;

      ImpactStrategicGoalScorecardPeriod? initialPeriod;
      if (periods.isNotEmpty) {
        initialPeriod = periods.firstWhere(
          (p) => p.isActive ?? false,
          orElse: () => periods.first,
        );
      }

      setState(() {
        _periods = periods;
        _selectedPeriod = initialPeriod;
        _isLoadingPeriods = false;
      });

      if (_selectedPeriod != null) {
        fetchImpactGoalStrageyScoreCard();
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _isLoadingPeriods = false);
    }
  }

  Future<void> fetchImpactGoalStrageyScoreCard({
    int page = 1,
    String? searchQuery,
  }) async {
    if (_isLoading || _selectedPeriod == null) return;
    setState(() => _isLoading = true);
    try {
      final pageList = await _impactService.getImpactStrategicGoalScorecard(
        periodId: _selectedPeriod!.id,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          totalCount = pageList.totalCount;
          impactStrategyGoalList = pageList.items;
          filteredList = List.from(impactStrategyGoalList);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleEdit(ImpactStrategicGoalScoreCard item) async {
    final period = item.impactStrategicGoalScoreCardPeriod;
    if (period == null) return;

    try {
      final fullScorecard = await _impactService.fetchById(item.id);
      if (!mounted || fullScorecard == null) return;

      final startYear = period.startDate.year;
      final endYear = period.endDate.year;
      final years = [for (int y = startYear; y <= endYear; y++) y.toString()];
      final baselineYear = (startYear - 1).toString();

      showImpactStrategyScorecardDialog(
        context,
        periodId: period.id,
        targetYears: years,
        baselineYear: baselineYear,
        // IMPORTANT: pass the existing id so the dialog does a PUT (update)
        // instead of a POST (create) -> without this it inserts a new row
        // every time you save.
        scorecardId: fullScorecard.id,
        scorecardRowVersion: fullScorecard.rowVersion,
        initialImpactGroups: _buildImpactGroups(
          fullScorecard.impactScoreCard ?? [],
          years,
          baselineYear,
        ),
        initialStrategicGroups: _buildStrategicGroups(
          fullScorecard.impactStrategicScoreCard ?? [],
          years,
          baselineYear,
        ),
        onSaved: () => fetchImpactGoalStrageyScoreCard(page: _currentPage),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<ScorecardGroup> _buildImpactGroups(
    List<ImpactScoreCard> cards,
    List<String> targetYears,
    String baselineYear,
  ) {
    if (cards.isEmpty) {
      return [ScorecardGroup(yearCount: targetYears.length)];
    }
    final baselineYearNum = int.tryParse(baselineYear) ?? -1;

    return cards.map((card) {
      final measures =
          card.impactScoreCardIndicator.map((indicator) {
            final targetsByYear = {
              for (final t in indicator.impactScoreCardTarget) t.year: t,
            };

            final baselineTarget = targetsByYear[baselineYearNum];
            final baselineVal = baselineTarget?.target ?? '';

            final yearTargets = <String>[];
            final targetIds = <int>[baselineTarget?.id ?? 0];
            final targetRowVersions = <String?>[baselineTarget?.rowVersion];

            for (final y in targetYears) {
              final t = targetsByYear[int.tryParse(y) ?? -1];
              yearTargets.add(t?.target ?? '');
              targetIds.add(t?.id ?? 0);
              targetRowVersions.add(t?.rowVersion);
            }

            return ScorecardMeasure(
              id: indicator.id,
              rowVersion: indicator.rowVersion,
              description: indicator.indicatorDescription,
              baseline: baselineVal,
              targets: yearTargets,
              targetIds: targetIds,
              targetRowVersions: targetRowVersions,
              yearCount: targetYears.length,
            );
          }).toList();

      return ScorecardGroup(
        id: card.id,
        rowVersion: card.rowVersion,
        label: card.impactDescription,
        measures:
            measures.isEmpty
                ? [ScorecardMeasure(yearCount: targetYears.length)]
                : measures,
        yearCount: targetYears.length,
      );
    }).toList();
  }

  List<ScorecardGroup> _buildStrategicGroups(
    List<ImpactStrategicScoreCard> cards,
    List<String> targetYears,
    String baselineYear,
  ) {
    if (cards.isEmpty) {
      return [ScorecardGroup(yearCount: targetYears.length)];
    }
    final baselineYearNum = int.tryParse(baselineYear) ?? -1;

    return cards.map((card) {
      final measures =
          card.impactStrategicScoreCardMeasure.map((measure) {
            final targetsByYear = {
              for (final t in measure.impactStrategicScoreCardTarget) t.year: t,
            };

            final baselineTarget = targetsByYear[baselineYearNum];
            final baselineVal = baselineTarget?.target ?? '';

            final yearTargets = <String>[];
            final targetIds = <int>[baselineTarget?.id ?? 0];
            final targetRowVersions = <String?>[baselineTarget?.rowVersion];

            for (final y in targetYears) {
              final t = targetsByYear[int.tryParse(y) ?? -1];
              yearTargets.add(t?.target ?? '');
              targetIds.add(t?.id ?? 0);
              targetRowVersions.add(t?.rowVersion);
            }

            return ScorecardMeasure(
              id: measure.id,
              rowVersion: measure.rowVersion,
              description: measure.measureDescription,
              baseline: baselineVal,
              targets: yearTargets,
              targetIds: targetIds,
              targetRowVersions: targetRowVersions,
              yearCount: targetYears.length,
            );
          }).toList();

      return ScorecardGroup(
        id: card.id,
        rowVersion: card.rowVersion,
        label: card.goalDescription,
        measures:
            measures.isEmpty
                ? [ScorecardMeasure(yearCount: targetYears.length)]
                : measures,
        yearCount: targetYears.length,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(isMobile),
          gap4px,
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withValues(alpha: .05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMobile)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Period",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 5),
                    Expanded(child: _buildListBody(isMobile)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PaginationInfo(
                            currentPage: _currentPage,
                            totalItems: totalCount,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: totalCount,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged:
                                (page) =>
                                    fetchImpactGoalStrageyScoreCard(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => _showPeriodSelectionDialog(),
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildListBody(bool isMobile) {
    if (_isLoadingPeriods || _isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    if (_periods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_outlined,
              color: Colors.grey.shade400,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              "No Impact Period Available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.grey.shade400,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              "No Impact Strategy Available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final impactStrategyGoal = filteredList[index];

        int itemNumber = ((_currentPage - 1) * _pageSize) + index + 1;

        final period = impactStrategyGoal.impactStrategicGoalScoreCardPeriod;
        final periodLabel =
            period != null
                ? "${period.startDate.year} - ${period.endDate.year}"
                : "N/A";

        if (!isMobile) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text("$itemNumber")),
                Expanded(
                  flex: 3,
                  child: Text(periodLabel, style: TextStyle(fontSize: 12)),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => _handleEdit(impactStrategyGoal),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.description_outlined,
                          size: 18,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          openImpactGoalStrategyReportPreview(
                            impactStrategyGoal.id.toString(),
                            '',
                            context: context,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.delete_simple,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                        onPressed:
                            () => showDeleteDialog(
                              impactStrategyGoal.id.toString(),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "$itemNumber",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    color: Theme.of(context).cardColor,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'edit' &&
                          permissionService.hasPermission(
                            AppPermissions.editImpactStrategicGoalScoreCard,
                          )) {
                        _handleEdit(impactStrategyGoal);
                      }
                      if (value == 'preview') {
                        openImpactGoalStrategyReportPreview(
                          impactStrategyGoal.id.toString(),
                          '',
                          context: context,
                        );
                      }
                      if (value == 'delete' &&
                          permissionService.hasPermission(
                            AppPermissions.editImpactStrategicGoalScoreCard,
                          )) {
                        showDeleteDialog(impactStrategyGoal.id.toString());
                      }
                    },
                    itemBuilder:
                        (_) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: PermissionWidget(
                              permission: AppPermissions.viewKraRoadMap,
                              child: const Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 16),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'preview',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 16,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 8),
                                Text('Print preview'),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            value: 'delete',
                            child: PermissionWidget(
                              permission: AppPermissions.deleteKraRoadMap,
                              child: const Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.delete_simple,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ),
                        ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(periodLabel, style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 900;
    final isXSmall = width < 700;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, isXSmall ? 12 : 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isXSmall ? 6 : 8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: primaryColor,
                  size: isXSmall ? 18 : 22,
                ),
              ),
              SizedBox(width: isXSmall ? 18 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Impact Strategy Scorecard',
                      style: TextStyle(
                        fontSize:
                            isXSmall
                                ? 12
                                : isSmall
                                ? 14
                                : 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      "${filteredList.length} impact strategy${filteredList.length != 1 ? 's' : ''} found",
                      style: TextStyle(
                        fontSize: isXSmall ? 10 : 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                PermissionWidget(
                  permission: AppPermissions.addImpactStrategicGoalScoreCard,
                  child: ElevatedButton.icon(
                    onPressed: () => _showPeriodSelectionDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: isXSmall ? 8 : 10,
                        horizontal: isXSmall ? 10 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: isXSmall ? 14 : 16,
                    ),
                    label: Text(
                      isXSmall ? 'Add' : 'Add New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isXSmall ? 11 : 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _showPeriodSelectionDialog() async {
    List<ImpactStrategicGoalScorecardPeriod> periods = [];
    bool isLoading = true;
    bool hasFetched = false;
    ImpactStrategicGoalScorecardPeriod? selectedPeriod;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            if (!hasFetched) {
              hasFetched = true;
              _commonService
                  .fetchImpactPeriod()
                  .then((fetchedPeriods) {
                    setStateDialog(() {
                      periods = fetchedPeriods;
                      isLoading = false;
                    });
                  })
                  .catchError((_) {
                    setStateDialog(() => isLoading = false);
                  });
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 440,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.event_note_outlined,
                            color: primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Impact Period',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: kText,
                                ),
                              ),
                              Text(
                                'Baseline & target years will follow this period',
                                style: TextStyle(fontSize: 12, color: kMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (periods.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No impact periods found. Please create one first.',
                          style: TextStyle(fontSize: 13, color: kMuted),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<
                              ImpactStrategicGoalScorecardPeriod
                            >(
                              value: selectedPeriod,
                              isExpanded: true,
                              hint: Text(
                                'Select a period',
                                style: TextStyle(fontSize: 13, color: kMuted),
                              ),
                              items:
                                  periods.map((p) {
                                    final label =
                                        '${DateFormat('yyyy-MM-dd').format(p.startDate)}  -  '
                                        '${DateFormat('yyyy-MM-dd').format(p.endDate)}'
                                        '${(p.isActive ?? false) ? '  (Active)' : ''}';
                                    return DropdownMenuItem(
                                      value: p,
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: kText,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged:
                                  (val) => setStateDialog(
                                    () => selectedPeriod = val,
                                  ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: kBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: kMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                selectedPeriod == null
                                    ? null
                                    : () {
                                      final period = selectedPeriod!;
                                      Navigator.pop(dialogContext);
                                      _openScorecardDialogForPeriodData(
                                        periodId: period.id,
                                        startDate: period.startDate,
                                        endDate: period.endDate,
                                      );
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Impact Strategy Goal Scorecard',
            itemName: 'impact strategy goal scorecard',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _impactService.deleteImpactStratgyGoalScorecard(id);
                await fetchImpactGoalStrageyScoreCard();
                if (mounted) {
                  MotionToast.success(
                    description: Text(
                      'Impact strategy goal scorecard',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete strategy goal scorecard',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }

  void _openScorecardDialogForPeriodData({
    required int periodId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final startYear = startDate.year;
    final endYear = endDate.year;
    final years = [for (int y = startYear; y <= endYear; y++) y.toString()];
    final baselineYear = (startYear - 1).toString();

    showImpactStrategyScorecardDialog(
      context,
      periodId: periodId,
      targetYears: years,
      baselineYear: baselineYear,
      onSaved: () {
        fetchImpactGoalStrageyScoreCard(page: _currentPage);
      },
    );
  }
}
