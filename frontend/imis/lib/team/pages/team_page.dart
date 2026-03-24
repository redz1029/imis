// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/team/services/team_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  TeamPageState createState() => TeamPageState();
}

class TeamPageState extends State<TeamPage> {
  final _teamService = TeamService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<Team> teamSearchUtil;
  final _formKey = GlobalKey<FormState>();
  List<Team> teamList = [];
  List<Team> filteredList = [];

  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  String statusFilter = 'Active';
  final List<String> statusOptions = ['Active', 'Inactive'];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final Dio dio = Dio();

  Future<void> fetchTeam({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _teamService.getTeam(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          teamList = pageList.items;
          filteredList = List.from(teamList);
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

  @override
  void initState() {
    super.initState();
    fetchTeam();
    teamSearchUtil = FilterSearchResultUtil<Team>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().team,
      pageSize: _pageSize,
      fromJson: (json) => Team.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> filterSearchResults(String query) async {
    final results = await teamSearchUtil.filter(
      query,
      (team, search) =>
          (team.name).toLowerCase().contains(search.toLowerCase()),
    );

    setState(() {
      filteredList = results;
    });
  }

  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String? name,
    bool isActive = false,
  }) {
    TextEditingController teamController = TextEditingController(text: name);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            id == null ? 'Add Team' : 'Edit Team',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: teamController,
                    decoration: InputDecoration(
                      labelText: 'Team Name',
                      focusColor: primaryColor,
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please fill out this field';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool? confirmAction = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          id == null ? "Confirm Save" : "Confirm Update",
                        ),
                        content: Text(
                          id == null
                              ? "Are you sure you want to save this record?"
                              : "Are you sure you want to update this record?",
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
                            onPressed: () => Navigator.pop(context, true),
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
                    final team = Team(
                      int.tryParse(id ?? '0') ?? 0,
                      teamController.text,
                      isActive,
                      isDeleted,
                      rowVersion: '',
                    );
                    await _teamService.createTeam(team);
                    setState(() {
                      fetchTeam();
                    });
                    MotionToast.success(
                      description: const Text("Saved successfully!"),
                      toastAlignment: Alignment.topCenter,
                    ).show(context);
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(
                id == null ? 'Save' : 'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Auditor's Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 300,
                  child: TextField(
                    focusNode: isSearchfocus,
                    controller: searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(color: grey, fontSize: 14),
                      labelText: 'Search...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: isSearchfocus.hasFocus ? primaryColor : grey,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      filled: true,
                      fillColor: secondaryColor,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                    ),
                    onChanged: filterSearchResults,
                  ),
                ),
                const Spacer(),
                if (!isMobile)
                  ElevatedButton.icon(
                    onPressed: () => showFormDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add New',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 26),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Team",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),

                    Expanded(
                      child:
                          _isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                              : ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  final team = filteredList[index];

                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("$itemNumber"),
                                          ),

                                          Expanded(
                                            flex: 3,
                                            child: Text(team.name),
                                          ),

                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Tooltip(
                                                  message: 'Edit',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      size: 18,
                                                      Icons.edit_outlined,
                                                    ),
                                                    onPressed: () {
                                                      showFormDialog(
                                                        id: team.id.toString(),
                                                        name: team.name,
                                                      );
                                                    },
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    size: 18,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        team.id.toString(),
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "$itemNumber",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            PopupMenuButton<String>(
                                              color:
                                                  Theme.of(context).cardColor,
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) async {
                                                if (value == 'edit') {
                                                  showFormDialog(
                                                    id: team.id.toString(),
                                                    name: team.name,
                                                  );
                                                }

                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    team.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Edit'),
                                                        ],
                                                      ),
                                                    ),

                                                    PopupMenuItem(
                                                      value: 'delete',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .delete_simple,
                                                            color: Colors.red,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Delete'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text("Name: ${team.name}"),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PaginationInfo(
                            currentPage: _currentPage,
                            totalItems: _totalCount,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _totalCount,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged: (page) => fetchTeam(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showFormDialog(),
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   final width = MediaQuery.of(context).size.width;
  //   final isMobile = width < 600;

  //   return Scaffold(
  //     body: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "Team Information",
  //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 20),
  //           Row(
  //             children: [
  //               SizedBox(
  //                 height: 30,
  //                 width: 300,
  //                 child: TextField(
  //                   focusNode: isSearchfocus,
  //                   controller: searchController,
  //                   decoration: InputDecoration(
  //                     enabledBorder: OutlineInputBorder(
  //                       borderSide: BorderSide(color: lightGrey),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderSide: BorderSide(color: primaryColor),
  //                     ),
  //                     floatingLabelBehavior: FloatingLabelBehavior.never,
  //                     labelStyle: const TextStyle(color: grey, fontSize: 14),
  //                     labelText: 'Search Team',
  //                     prefixIcon: Icon(
  //                       Icons.search,
  //                       color: isSearchfocus.hasFocus ? primaryColor : grey,
  //                       size: 20,
  //                     ),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                     filled: true,
  //                     fillColor: secondaryColor,
  //                     contentPadding: const EdgeInsets.symmetric(
  //                       vertical: 5,
  //                       horizontal: 5,
  //                     ),
  //                   ),
  //                   onChanged: filterSearchResults,
  //                 ),
  //               ),
  //               const Spacer(),
  //               if (!isMobile)
  //                 ElevatedButton.icon(
  //                   onPressed: () => showFormDialog(),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: primaryColor,
  //                     padding: const EdgeInsets.symmetric(
  //                       vertical: 10,
  //                       horizontal: 16,
  //                     ),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                   ),
  //                   icon: const Icon(Icons.add, color: Colors.white),
  //                   label: const Text(
  //                     'Add New',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //             ],
  //           ),
  //           const SizedBox(height: 26),
  //           Expanded(
  //             child: Container(
  //               padding: const EdgeInsets.all(20),
  //               decoration: BoxDecoration(
  //                 color: Theme.of(context).cardColor,
  //                 borderRadius: BorderRadius.circular(20),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     blurRadius: 10,
  //                     color: Colors.black.withValues(alpha: .05),
  //                   ),
  //                 ],
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     child:
  //                         _isLoading
  //                             ? Center(
  //                               child: CircularProgressIndicator(
  //                                 color: primaryColor,
  //                               ),
  //                             )
  //                             : ListView.separated(
  //                               itemCount: filteredList.length,
  //                               separatorBuilder:
  //                                   (context, index) => Divider(
  //                                     height: 1,
  //                                     color: Colors.grey.withValues(alpha: 0.2),
  //                                   ),
  //                               itemBuilder: (context, index) {
  //                                 final team = filteredList[index];

  //                                 final initials =
  //                                     team.name.trim().isNotEmpty
  //                                         ? team.name
  //                                             .trim()
  //                                             .split(' ')
  //                                             .map((e) => e[0])
  //                                             .take(2)
  //                                             .join()
  //                                             .toUpperCase()
  //                                         : '?';
  //                                 if (!isMobile) {
  //                                   return Padding(
  //                                     padding: const EdgeInsets.symmetric(
  //                                       vertical: 14,
  //                                       horizontal: 12,
  //                                     ),
  //                                     child: Row(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.center,
  //                                       children: [
  //                                         // Avatar
  //                                         Container(
  //                                           width: 38,
  //                                           height: 38,
  //                                           decoration: BoxDecoration(
  //                                             color: primaryColor.withValues(
  //                                               alpha: 0.1,
  //                                             ),
  //                                             shape: BoxShape.circle,
  //                                           ),
  //                                           child: Center(
  //                                             child: Text(
  //                                               initials,
  //                                               style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 fontWeight: FontWeight.w600,
  //                                                 color: primaryColor,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         const SizedBox(width: 12),

  //                                         // Team name
  //                                         Expanded(
  //                                           child: Text(
  //                                             team.name,
  //                                             style: const TextStyle(
  //                                               fontWeight: FontWeight.w600,
  //                                               fontSize: 14,
  //                                             ),
  //                                           ),
  //                                         ),

  //                                         // Actions
  //                                         Row(
  //                                           mainAxisSize: MainAxisSize.min,
  //                                           children: [
  //                                             IconButton(
  //                                               icon: Icon(
  //                                                 Icons.edit_outlined,
  //                                                 size: 18,
  //                                               ),
  //                                               onPressed:
  //                                                   () => showFormDialog(
  //                                                     id: team.id.toString(),
  //                                                     name: team.name,
  //                                                   ),
  //                                             ),
  //                                             IconButton(
  //                                               icon: Icon(
  //                                                 CupertinoIcons.delete_simple,
  //                                                 size: 18,
  //                                                 color: Colors.redAccent,
  //                                               ),
  //                                               onPressed:
  //                                                   () => showDeleteDialog(
  //                                                     team.id.toString(),
  //                                                   ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   );
  //                                 }
  //                                 return Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                     vertical: 14,
  //                                     horizontal: 4,
  //                                   ),
  //                                   child: Row(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     children: [
  //                                       // Avatar
  //                                       Container(
  //                                         width: 36,
  //                                         height: 36,
  //                                         decoration: BoxDecoration(
  //                                           color: primaryColor.withValues(
  //                                             alpha: 0.1,
  //                                           ),
  //                                           shape: BoxShape.circle,
  //                                         ),
  //                                         child: Center(
  //                                           child: Text(
  //                                             initials,
  //                                             style: TextStyle(
  //                                               fontSize: 12,
  //                                               fontWeight: FontWeight.w600,
  //                                               color: primaryColor,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(width: 12),

  //                                       Expanded(
  //                                         child: Column(
  //                                           crossAxisAlignment:
  //                                               CrossAxisAlignment.start,
  //                                           children: [
  //                                             Text(
  //                                               team.name,
  //                                               style: const TextStyle(
  //                                                 fontWeight: FontWeight.bold,
  //                                                 fontSize: 14,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),

  //                                       PopupMenuButton<String>(
  //                                         color: Theme.of(context).cardColor,
  //                                         icon: Icon(
  //                                           Icons.more_vert,
  //                                           color: Colors.grey.shade500,
  //                                         ),
  //                                         onSelected: (value) {
  //                                           if (value == 'edit') {
  //                                             showFormDialog(
  //                                               id: team.id.toString(),
  //                                               name: team.name,
  //                                             );
  //                                           }
  //                                           if (value == 'delete') {
  //                                             showDeleteDialog(
  //                                               team.id.toString(),
  //                                             );
  //                                           }
  //                                         },
  //                                         itemBuilder:
  //                                             (_) => [
  //                                               PopupMenuItem(
  //                                                 value: 'edit',
  //                                                 child: Row(
  //                                                   children: const [
  //                                                     Icon(
  //                                                       Icons.edit_outlined,
  //                                                       size: 18,
  //                                                     ),
  //                                                     SizedBox(width: 8),
  //                                                     Text('Edit'),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                               PopupMenuItem(
  //                                                 value: 'delete',
  //                                                 child: Row(
  //                                                   children: [
  //                                                     Icon(
  //                                                       CupertinoIcons
  //                                                           .delete_simple,
  //                                                       color: Colors.redAccent,
  //                                                       size: 18,
  //                                                     ),
  //                                                     const SizedBox(width: 8),
  //                                                     const Text('Delete'),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.all(10),
  //                     color: Theme.of(context).cardColor,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         PaginationInfo(
  //                           currentPage: _currentPage,
  //                           totalItems: _totalCount,
  //                           itemsPerPage: _pageSize,
  //                         ),
  //                         PaginationControls(
  //                           currentPage: _currentPage,
  //                           totalItems: _totalCount,
  //                           itemsPerPage: _pageSize,
  //                           isLoading: _isLoading,
  //                           onPageChanged: (page) => fetchTeam(page: page),
  //                         ),
  //                         const SizedBox(width: 60),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton:
  //         isMobile
  //             ? FloatingActionButton(
  //               backgroundColor: primaryColor,
  //               onPressed: () => showFormDialog(),
  //               child: const Icon(Icons.add, color: Colors.white),
  //             )
  //             : null,
  //   );
  // }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this Team? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _teamService.deleteTeam(id);
                  await fetchTeam();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Team deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(description: Text('Failed to Delete Team'));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
