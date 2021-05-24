import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import '../data_models/running_data.dart';

class RunningStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var runningData = Provider.of<RunningData>(context);
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: runningData.distance == null
                  ? Text(
                "0.00km",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )
                  : Text(
                runningData.distance.toStringAsFixed(2) + "km",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
          Expanded(
              child: Text(
                runningData.totalTime.toString() + "secs",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
          Expanded(
              child: runningData.totalTime == 0 || runningData.distance == null
                  ? Text(
                "0.0km/h",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )
                  : Text(
                (runningData.distance / runningData.totalTime * 3600)
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
