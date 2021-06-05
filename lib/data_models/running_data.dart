import 'package:flutter/material.dart';
import 'dart:async';

class RunningData with ChangeNotifier {
  double _distance;
  double _totalTime;

  Timer _timer;

  double get distance => this._distance;
  double get totalTime => this._totalTime;

  double caloriesConsumed() {
    return _distance * 100 / 1.6;
  }

  changeDistance(double newValue) {
    _distance = newValue;
    notifyListeners();
  }

  startTimer() {
    _totalTime = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _totalTime++;
      notifyListeners();
    });
  }

  stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }
}