import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';

// ignore: must_be_immutable
class MainBottomNavigationBar extends StatefulWidget {
  MainBottomNavigationBar(ValueNotifier<String> chooseNotifier) {
    _chooseNotifier = chooseNotifier;
  }

  ValueNotifier<String> _chooseNotifier;

  @override
  _MainBottomNavigationBarState createState() =>
      _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  int selectionIndex = 1;

  void onPressedCategory(int index) {
    if (index == 0) return;
    widget._chooseNotifier.value = index.toString();
    selectionIndex = index;
  }

  void onBack() {
    widget._chooseNotifier.value = 'back';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget._chooseNotifier,
      builder: (_, value, __) => getWidget(context),
    );
  }

  BottomNavigationBar getWidget(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 32,
      onTap: (selectionIndex) => onPressedCategory(selectionIndex),
      currentIndex: selectionIndex,
      unselectedIconTheme: IconThemeData(color: Theme.of(context).accentColor),
      selectedIconTheme: IconThemeData(color: Theme.of(context).accentColor),
      selectedFontSize: 12.0,
      selectedItemColor: Theme.of(context).accentColor,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
            icon: Container(
              width: 0,
            ),
            label: ''),
        BottomNavigationBarItem(
          icon: Icon(
            LineIcons.heartbeat,
          ),
          label: 'Тренировка',
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Ionicons.settings,
              color: Theme.of(context).accentColor,
            ),
            label: 'Управление'),
        BottomNavigationBarItem(
            icon: Icon(
              LineIcons.bar_chart,
              color: Theme.of(context).accentColor,
            ),
            label: 'Опыт'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).accentColor,
            ),
            label: 'Напоминания'),
        BottomNavigationBarItem(
            icon: Icon(
              LineIcons.sliders,
              color: Theme.of(context).accentColor,
            ),
            label: 'Настройки')
      ],
    );
  }
}
