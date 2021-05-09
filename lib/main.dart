import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart' as WEMAP;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

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

  WEMAP.Circle circle;

  static final WEMAP.CameraPosition initialLocation = WEMAP.CameraPosition(
      target: WEMAP.LatLng(21.028511, 105.804817), zoom: 14.00);

  // void updateCircle(LocationData newData) {
  //   WEMAP.LatLng latlng = WEMAP.LatLng(newData.latitude, newData.longitude);
  //   circle = WEMAP.Circle(
  //       "circle_location",
  //       WEMAP.CircleOptions(
  //         circleRadius: newData.accuracy,
  //         circleColor: "lime",
  //         circleStrokeColor: "lightGreen",
  //         geometry: latlng,
  //       ));
  // }

  void _getLocation() async {
    try {
      var location = await _locationTracker.getLocation();

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
                  zoom: 14.00)));
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: WEMAP.WeMap(
        styleString: _styleString,
        initialCameraPosition: initialLocation,
        myLocationEnabled: true,
        myLocationTrackingMode: WEMAP.MyLocationTrackingMode.TrackingGPS,
        myLocationRenderMode: WEMAP.MyLocationRenderMode.GPS,
        onMapCreated: (WEMAP.WeMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'getLocation',
        child: Icon(Icons.location_searching),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
