import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';

class MainBottomNavigationBar extends StatefulWidget {
  @override
  _MainBottomNavigationBarState createState() =>
      _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  final _chooseNotifier = ValueNotifier<String>('');
  int selectionIndex = 1;
  String whichCategory;

  void onPressedCategory(int index) {
    _chooseNotifier.value = index.toString();
    if (index == 0) return;
    selectionIndex = index;
    print(index);
  }

  void onBack() {
    _chooseNotifier.value = 'back';
  }

  @override
  void dispose() {
    _chooseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _chooseNotifier,
      builder: (_, value, __) => getWidget(context),
    );
  }

  BottomNavigationBar getWidget(BuildContext context) {
    return BottomNavigationBar(
      onTap: (selectionIndex) => onPressedCategory(selectionIndex),
      currentIndex: selectionIndex,
      unselectedIconTheme: IconThemeData(color: Theme.of(context).accentColor),
      selectedIconTheme:
          IconThemeData(color: Theme.of(context).accentColor, size: 40),
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
