import 'package:flutter/material.dart';
import 'package:wemap_application/models/record_model.dart';
import 'package:wemap_application/services/record_service.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final RecordService _recordService = RecordService();
  List<Record> _listRecords = [];

  _getListRecords() async {
    List<Record> listFromDB = await _recordService.getAllRecords();
    print("listFromDB $listFromDB");
    setState(() {
      _listRecords = listFromDB;
    });
  }

  @override
  void initState() {
    super.initState();
    _getListRecords();
    print("List $_listRecords");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History"),),
      body: Container(
        child: ListView.builder(
          itemCount: _listRecords.length,
          itemBuilder: (context, index) {
            return Container(
              height: 50,
              child: Center(
                child: Text(
                  _listRecords[index].toString(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
