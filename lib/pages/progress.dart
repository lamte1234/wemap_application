import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemap_application/models/record_model.dart';
import 'package:wemap_application/services/record_service.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int _selectedPageIndex = 1;
  final List<String> _routes = ['/', '/progress'];
  final RecordService _recordService = RecordService();
  List<Record> _listRecords = [];

  _getListRecords() async {
    List<Record> listFromDB = await _recordService.getAllRecords();
    setState(() {
      _listRecords = listFromDB;
    });
  }

  @override
  void initState() {
    _getListRecords();
    super.initState();
  }

  void _onNavigationBarItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    Navigator.popAndPushNamed(context, _routes[_selectedPageIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("History"))),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _listRecords.length,
            itemBuilder: (context, index) {
              var item = _listRecords[index];
              var mapDateTime = item.dateTime.split(' ');
              String date = mapDateTime[0].split('-').reversed.join('/');
              String time = mapDateTime[1].split('.')[0];
              return Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.black12),
                    )),
                    height: 75,
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${item.distance.toStringAsFixed(2)} km",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text("$date $time"),
                            SizedBox(width: 10),
                            Text(
                                "${item.totalTime.toStringAsFixed(2)} seconds"),
                            SizedBox(width: 10),
                            Text("${item.speed.toStringAsFixed(2)} km/h"),
                          ],
                        ),
                      ],
                    )),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.run_circle),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          )
        ],
        onTap: _onNavigationBarItemTapped,
        currentIndex: _selectedPageIndex,
      ),
    );
  }
}
