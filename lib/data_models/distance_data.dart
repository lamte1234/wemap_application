import 'package:flutter/material.dart';

class Distance with ChangeNotifier {
  double _distance;

  double get distance => this._distance;

  changeDistance(double newValue) {
    _distance = newValue;
    print("from provider: " + _distance.toString());
    notifyListeners();
  }
}