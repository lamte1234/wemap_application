import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:core';

import '../data_models/running_data.dart';

class RunningStatus extends StatefulWidget {
  RunningStatus();
  @override
  _RunningStatusState createState() => _RunningStatusState();
}

class _RunningStatusState extends State<RunningStatus> {
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
    super.initState();
  }

  // optional can be removed
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
    // handle data when the widget is disposed
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var distance = Provider.of<RunningData>(context);
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: distance.distance == null
                  ? Text(
                      "0.00km",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      distance.distance.toStringAsFixed(2) + "km",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
          Expanded(
              child: Text(
            _totalTime.toString() + "secs",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: _totalTime == 0 || distance.distance == null
                  ? Text(
                      "0.0km/h",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      (distance.distance / _totalTime * 3600)
                              .toStringAsFixed(2) +
                          "km/h",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
        ],
      ),
      color: Colors.lightGreen,
    );
  }
}
