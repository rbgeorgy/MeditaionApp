import 'package:flutter/material.dart';
import 'package:meditation/components/MainBottomNavigationBar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MainBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
