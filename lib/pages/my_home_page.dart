import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:wemap_application/models/record_model.dart';
import 'package:wemap_application/services/record_service.dart';
import 'package:wemapgl/wemapgl.dart' as WEMAP;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../widgets/running_status.dart';
import '../data_models/running_data.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPageIndex = 0;
  final List<String> _routes = ['/', '/progress'];

  WEMAP.WeMapController _controller;
  String _styleString = WEMAP.WeMapStyles.WEMAP_VECTOR_STYLE;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  RecordService _recordService = RecordService();

  double _totalDistance = 0;

  bool _isRunning = false;

  List<WEMAP.LatLng> _line = [];

  WEMAP.CameraPosition _initialLocation = WEMAP.CameraPosition(
      target: WEMAP.LatLng(21.028511, 105.804817), zoom: 16.00);

  void _onNavigationBarItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    Navigator.popAndPushNamed(context, _routes[_selectedPageIndex]);
  }

  void _onMapCreated(WEMAP.WeMapController controller) async {
    _controller = controller;
    _line = [];

    var location = await _locationTracker.getLocation();
    _initialLocation = WEMAP.CameraPosition(
        target: WEMAP.LatLng(location.latitude, location.longitude),
        zoom: 16.0);
    _line.add(WEMAP.LatLng(location.latitude, location.longitude));
  }

  double _distanceBetween(WEMAP.LatLng point1, WEMAP.LatLng point2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((point2.latitude - point1.latitude) * p) / 2 +
        cos(point1.latitude * p) *
            cos(point2.latitude * p) *
            (1 - cos((point2.longitude - point1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  void _totalRunningDistance(List<WEMAP.LatLng> pathPoint) {
    _totalDistance = 0;
    for (var i = 0; i < pathPoint.length - 1; ++i) {
      _totalDistance += _distanceBetween(pathPoint[i], pathPoint[i + 1]);
      Provider.of<RunningData>(context, listen: false)
          .changeDistance(_totalDistance);
    }
  }

  void _startRunning() async {
    try {
      var location = await _locationTracker.getLocation();

      setState(() {
        _isRunning = true;
      });

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newData) {
        if (_controller != null) {
          _controller.animateCamera(WEMAP.CameraUpdate.newCameraPosition(
              new WEMAP.CameraPosition(
                  bearing: 0.0,
                  target: WEMAP.LatLng(newData.latitude, newData.longitude),
                  tilt: 0,
                  zoom: 16.00)));
          _line.add(WEMAP.LatLng(newData.latitude, newData.longitude));
          _controller.addLine(WEMAP.LineOptions(
            geometry: _line,
            lineColor: "#ff0000",
            lineWidth: 7.5,
            lineOpacity: 1,
          ));
          _totalRunningDistance(_line);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void _stopRunning() async {
    double newTotalDistance = Provider.of<RunningData>(context, listen: false).distance;
    Record newRecord = Record(
      id: 2,
      distance: newTotalDistance,
      totalTime: 10,
      speed: newTotalDistance/10,
      dateTime: DateTime.now().toString(),
    );
    // do something with data, save the running record
    await _recordService.insertRecord(newRecord);
    // routing
    setState(() {
      _isRunning = false;
      _totalDistance = 0;
      _line = [];
    });
    Navigator.popAndPushNamed(context, '/progress');
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    // remove line on map
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            _isRunning ? SafeArea(child: RunningStatus()) : Container(),
            Expanded(
              child: WEMAP.WeMap(
                styleString: _styleString,
                initialCameraPosition: _initialLocation,
                myLocationEnabled: true,
                // myLocationTrackingMode: WEMAP.MyLocationTrackingMode.TrackingGPS,
                // myLocationRenderMode: WEMAP.MyLocationRenderMode.GPS,
                onMapCreated: _onMapCreated,
              ),
            )
          ],
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
      floatingActionButton: _isRunning == false
          ? FloatingActionButton.extended(
              onPressed: _startRunning,
              foregroundColor: Colors.white,
              tooltip: 'startRunning',
              icon: Icon(Icons.run_circle),
              label: Text('START'))
          : FloatingActionButton.extended(
              onPressed: _stopRunning,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              tooltip: 'stopRunning',
              icon: Icon(Icons.run_circle),
              label: Text('STOP'),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
