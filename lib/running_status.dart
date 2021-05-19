import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';

class RunningStatus extends StatefulWidget {
  RunningStatus(this.distance);

  double distance;

  @override
  _RunningStatusState createState() => _RunningStatusState();
}

class _RunningStatusState extends State<RunningStatus> {
  double _distance = 0;
  double _totalTime = 0;
  Timer _timer;

  void startTimer() {
    _totalTime = 0;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _totalTime++;
      });
    });
  }

  @override
  void initState() {
    startTimer();
  }

  void stopTimer() {
    // save running record
    _totalTime = 0;
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _totalTime = 0;
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            _distance.toStringAsFixed(2) + "km",
            style: TextStyle(color: Colors.white),
          )),
          Expanded(
              child: Text(
            _totalTime.toString() + "secs",
            style: TextStyle(color: Colors.white),
          )),
          Expanded(
              child: _totalTime == 0
                  ? Text(
                      "0.0 km/h",
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      (_distance / _totalTime * 3600).toStringAsFixed(2) +
                          "km/h",
                      style: TextStyle(color: Colors.white),
                    )),
        ],
      ),
      color: Colors.lightGreen,
    );
  }
}
