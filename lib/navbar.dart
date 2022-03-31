import 'package:clambi/cuaca.dart';
import 'package:clambi/mqtt/mqtt.dart';
import 'package:clambi/schedule/sch.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var _currentIndex = 0;

  final _pageOptions = [
    MyCuaca(),
    Mymqtt(),
    MySch(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 20, 27),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.white,
              unselectedColor: Colors.white),

          /// Likes
          SalomonBottomBarItem(
              icon: Icon(Icons.settings),
              title: Text("Control"),
              selectedColor: Colors.white,
              unselectedColor: Colors.white),

          /// Search
          SalomonBottomBarItem(
              icon: Icon(Icons.schedule),
              title: Text("Scheduler"),
              selectedColor: Colors.white,
              unselectedColor: Colors.white),
        ],
      ),
      body: Center(
        child: _pageOptions[_currentIndex],
      ),
    );
  }
}
