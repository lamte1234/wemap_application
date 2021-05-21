import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int _selectedPageIndex = 1;
  final List<String> _routes = ['/', '/progress'];

  void _onNavigationBarItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    Navigator.popAndPushNamed(context, _routes[_selectedPageIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('showing running results page'),
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
    );
  }
}
