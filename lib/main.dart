import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemap_application/database/history_database.dart';
import 'package:wemapgl/wemapgl.dart' as WEMAP;

import './data_models/distance_data.dart';
import 'pages/my_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HistoryDatabase.instance.init();
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
      home: DataProvider(),
    );
  }
}

class DataProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Distance>(
      create: (context) => Distance(),
      child: MyHomePage(title: 'Tracking Demo'),
    );
  }
}



