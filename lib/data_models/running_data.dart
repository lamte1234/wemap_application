import 'package:flutter/material.dart';

class RunningData with ChangeNotifier {
  double _distance;
  double _totalTime;

  double get distance => this._distance;
  double get totalTime => this._totalTime;

  changeDistance(double newValue) {
    _distance = newValue;
    notifyListeners();
  }
}