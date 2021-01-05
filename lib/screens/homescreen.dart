import 'package:flutter/material.dart';
import 'package:meditation/components/MainBottomNavigationBar.dart';
import 'package:meditation/components/TrainPageView.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _chooseNotifier = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:
      bottomNavigationBar: MainBottomNavigationBar(_chooseNotifier),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: getWidget(_chooseNotifier.value, context),
    );
  }

  Widget getAppbar(String value, BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _chooseNotifier,
        builder: (_, value, __) => getAppbarWidget());
  }

  Widget getAppbarWidget() {
    switch (_chooseNotifier.value) {
      case '1':
        return TrainPageView();
        break;
      default:
        return Container();
    }
  }

  Widget getWidget(String value, BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _chooseNotifier,
        builder: (_, value, __) => getCenterWidget());
  }

  Widget getCenterWidget() {
    switch (_chooseNotifier.value) {
      case '1':
        return TrainPageView();
        break;
      default:
        return Container();
    }
  }
}
