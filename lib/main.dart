import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart' as WEMAP;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'running_status.dart';

void main() {
  WEMAP.Configuration.setWeMapKey('GqfwrZUEfxbwbnQUhtBMFivEysYIxelQ');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wemap Tracking',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'Tracking Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WEMAP.WeMapController _controller;
  String _styleString = WEMAP.WeMapStyles.WEMAP_VECTOR_STYLE;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();

  double _totalDistance = 0;

  bool _isRunning = false;

  List<WEMAP.LatLng> _line = [];

  WEMAP.CameraPosition _initialLocation = WEMAP.CameraPosition(
      target: WEMAP.LatLng(21.028511, 105.804817), zoom: 16.00);

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

  void _stopRunning() {
    setState(() {
      _isRunning = false;
      _totalDistance = 0;
      _line = [];
    });

    // do something with data, save the running record
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
            _isRunning
                ? SafeArea(child: RunningStatus(_totalDistance))
                : Container(),
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
