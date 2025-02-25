
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TableSaveExample extends StatefulWidget {
  @override
  _TableSaveExampleState createState() => _TableSaveExampleState();
}

class _TableSaveExampleState extends State<TableSaveExample> {
  List<RowData> tableData = []; // List to store row data

  @override
  void initState() {
    super.initState();
    tableData.add(RowData()); // Add initial empty row
  }

  void addNewRow() {
    setState(() {
      tableData.add(RowData());
    });
  }

  void saveTableData() async {
    List<Map<String, String>> formattedData = tableData.map((row) {
      return {
        "name": row.nameController.text,
        "quantity": row.quantityController.text,
      };
    }).toList();

    String apiUrl = "https://your-api.com/save-data"; // Replace with actual API
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"data": formattedData}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data saved successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data!")),
      );
    }
  }

  @override
  void dispose() {
    for (var row in tableData) {
      row.nameController.dispose();
      row.quantityController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Table Data Save Example")),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Quantity")),
              ],
              rows: tableData.map((row) {
                return DataRow(
                  cells: [
                    DataCell(TextField(controller: row.nameController)),
                    DataCell(TextField(controller: row.quantityController)),
                  ],
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: addNewRow,
                child: Text("Add Row"),
              ),
              ElevatedButton(
                onPressed: saveTableData,
                child: Text("Save Data"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RowData {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
}
