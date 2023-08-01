import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/tasks/canceled_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/completed_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/new_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/progress_tasks_screen.dart';
import 'package:task_manager/ui/utils/colors.dart';

import '../utils/assets_utils.dart';

class BottomNavBase extends StatefulWidget {
  const BottomNavBase({super.key});

  @override
  State<BottomNavBase> createState() => _BottomNavBaseState();
}

class _BottomNavBaseState extends State<BottomNavBase> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    NewTasksScreen(),
    CompletedTasksScreen(),
    CanceledTasksScreen(),
    ProgressTasksScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name',
              style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                color: Colors.white
              )),
            Text('email@abc.com',
              style: Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
                color: mainColor.shade50
              )),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            child: Image.asset(AssetsUtils.forwardPNG),
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        currentIndex: _selectedIndex,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          _selectedIndex = index;
          if(mounted) {
            setState(() {});
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.filter_1), label: 'New Task'),
          BottomNavigationBarItem(icon: Icon(Icons.filter_2), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.filter_3), label: 'Canceled'),
          BottomNavigationBarItem(icon: Icon(Icons.filter_4), label: 'Progress'),
        ],
      ),
    );
  }
}
