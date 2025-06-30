import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class PgsSignatoryTemplateNewPage extends StatefulWidget {
  const PgsSignatoryTemplateNewPage({super.key});

  @override
  State<PgsSignatoryTemplateNewPage> createState() =>
      _PgsSignatoryTemplateNewPageState();
}

class _PgsSignatoryTemplateNewPageState
    extends State<PgsSignatoryTemplateNewPage> {
  final List<SignatoryOffice> _signatoryOffices = [];
  final FocusNode isSearchfocus = FocusNode();
  final TextEditingController searchController = TextEditingController();
  List<User> userList = [];
  List<User> filteredListUser = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    var url = ApiEndpoint().users;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();

        if (mounted) {
          setState(() {
            userList = data;
            filteredListUser = List.from(userList);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  void _addNewOffice() {
    final officeNameController = TextEditingController();
    String? selectedNotedBy;
    String? selectedReviewBy;
    String? selectedApprovedBy;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Add New Signatory Office"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: officeNameController,
                        decoration: const InputDecoration(
                          labelText: "Office Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Signatories:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedNotedBy,
                        decoration: const InputDecoration(
                          labelText: 'Noted by',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            filteredListUser.map((user) {
                              return DropdownMenuItem<String>(
                                value: user.id,
                                child: Text(user.fullName),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedNotedBy = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedReviewBy,
                        decoration: const InputDecoration(
                          labelText: 'Review by',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            filteredListUser.map((user) {
                              return DropdownMenuItem<String>(
                                value: user.id,
                                child: Text(user.fullName),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedReviewBy = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedApprovedBy,
                        decoration: const InputDecoration(
                          labelText: 'Approved by',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            filteredListUser.map((user) {
                              return DropdownMenuItem<String>(
                                value: user.id,
                                child: Text(user.fullName),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedApprovedBy = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      if (officeNameController.text.trim().isNotEmpty &&
                          selectedNotedBy != null &&
                          selectedReviewBy != null &&
                          selectedApprovedBy != null) {
                        final notedByUser = filteredListUser.firstWhere(
                          (user) => user.id == selectedNotedBy,
                        );
                        final reviewByUser = filteredListUser.firstWhere(
                          (user) => user.id == selectedReviewBy,
                        );
                        final approvedByUser = filteredListUser.firstWhere(
                          (user) => user.id == selectedApprovedBy,
                        );

                        setState(() {
                          _signatoryOffices.add(
                            SignatoryOffice(
                              officeName: officeNameController.text.trim(),
                              notedBy: [notedByUser.fullName],
                              reviewBy: [reviewByUser.fullName],
                              approvedBy: [approvedByUser.fullName],
                            ),
                          );
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildSignatoryBox(SignatoryOffice office) {
    return Card(
      color: secondaryColor,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              office.officeName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(
                office.isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  office.isExpanded = !office.isExpanded;
                });
              },
            ),
          ),

          if (office.isExpanded) ...[
            _buildSignatorySection("Noted by", office.notedBy, office),
            _buildSignatorySection("Review by", office.reviewBy, office),
            _buildSignatorySection("Approved by", office.approvedBy, office),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Future<void> filterSearchResults(String query) async {
    // final results = await signatorySearchUtil.filter(
    //   query,
    //   (signatory, search) => (signatory.signatoryLabel ?? '')
    //       .toLowerCase()
    //       .contains(search.toLowerCase()),
    // );

    // setState(() {
    //   filteredList = results;
    // });
  }

  Widget _buildSignatorySection(
    String title,
    List<String> names,
    SignatoryOffice office,
  ) {
    bool hasPerson = names.isNotEmpty;
    String? currentName = hasPerson ? names.first : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, color: grey),
          ),
          Row(
            children: [
              Expanded(
                child:
                    hasPerson
                        ? Text(currentName!)
                        : const Text(
                          "No person assigned",
                          style: TextStyle(color: Colors.grey),
                        ),
              ),
              IconButton(
                icon: Icon(
                  hasPerson ? Icons.delete : Icons.add,
                  size: 18,
                  color: hasPerson ? primaryTextColor : primaryColor,
                ),
                onPressed: () {
                  if (hasPerson) {
                    setState(() {
                      names.clear();
                    });
                  } else {
                    _addSignatoryToSection(title, office);
                  }
                },
              ),
            ],
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  void _addSignatoryToSection(String sectionTitle, SignatoryOffice office) {
    String? selectedUserId;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Add $sectionTitle"),
                content: DropdownButtonFormField<String>(
                  value: selectedUserId,
                  decoration: InputDecoration(
                    labelText: sectionTitle,

                    border: const OutlineInputBorder(),
                  ),
                  items:
                      filteredListUser.map((user) {
                        return DropdownMenuItem<String>(
                          value: user.id,
                          child: Text(user.fullName),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUserId = value;
                    });
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      if (selectedUserId != null) {
                        final user = filteredListUser.firstWhere(
                          (user) => user.id == selectedUserId,
                        );

                        setState(() {
                          if (sectionTitle == 'Noted by') {
                            office.notedBy = [
                              user.fullName,
                            ]; // Replace with new list
                          } else if (sectionTitle == 'Review by') {
                            office.reviewBy = [user.fullName];
                          } else if (sectionTitle == 'Approved by') {
                            office.approvedBy = [user.fullName];
                          }
                        });

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('PGS Signatory Template Information'),
        backgroundColor: mainBgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      labelText: 'Search PGS Signatory',
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
                if (!isMinimized)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: _addNewOffice,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 5),
                        Text('Add New', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  _signatoryOffices.isEmpty
                      ? const Center(
                        child: Text(
                          'No signatory offices added yet',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                      : ListView(
                        children:
                            _signatoryOffices
                                .map((office) => _buildSignatoryBox(office))
                                .toList(),
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMinimized
              ? FloatingActionButton(
                onPressed: _addNewOffice,
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}

class SignatoryOffice {
  final String officeName;
  List<String> notedBy;
  List<String> reviewBy;
  List<String> approvedBy;
  bool isExpanded;

  SignatoryOffice({
    required this.officeName,
    required this.notedBy,
    required this.reviewBy,
    required this.approvedBy,
    this.isExpanded = false,
  });
}
