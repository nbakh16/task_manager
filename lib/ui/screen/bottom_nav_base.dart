import 'package:flutter/material.dart';
import 'package:task_manager/data/utils/auth_utility.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/screen/tasks/canceled_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/completed_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/new_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/progress_tasks_screen.dart';
import 'package:task_manager/ui/utils/colors.dart';

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
        title: appBarTitle(context),
        leading: profilePicture(context),
        actions: [
          IconButton(
            onPressed: () {
              signOutShowDialog(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
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

  Column appBarTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${AuthUtility.userInfo.data?.firstName.toString()} '
            '${AuthUtility.userInfo.data?.lastName.toString()}',
            style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                color: Colors.white
            )),
        Text(AuthUtility.userInfo.data?.email.toString() ?? "email@abc.com",
            style: Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
                color: mainColor.shade50
            )),
      ],
    );
  }

  Padding profilePicture(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: CircleAvatar(
        foregroundImage: NetworkImage(AuthUtility.userInfo.data?.photo ?? ''),
        // foregroundImage: NetworkImage('https://images.unsplash.com/photo-1575936123452-b67c3203c357'),
        onForegroundImageError: (_, __) {
          return;
        },
        child: Text('${AuthUtility.userInfo.data?.firstName![0]}',
          style: Theme.of(context).primaryTextTheme.titleLarge,
        ),
      ),
    );
  }

  Future<dynamic> signOutShowDialog(BuildContext context) {
    return showDialog(barrierDismissible: false,
      context: context, builder: (_) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.only(left: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text('Sign Out',
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.red.withOpacity(0.75),
              ))
          ],
        ),
        content: Text('Are you sure to sign out?',
            style: Theme.of(context).primaryTextTheme.titleSmall
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await AuthUtility.clearUserInfo();

              if(mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => const SplashScreen()),
                        (route) => false);
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
    ));
  }
}
