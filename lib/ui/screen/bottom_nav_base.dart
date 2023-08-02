import 'package:flutter/material.dart';
import 'package:task_manager/data/utils/auth_utility.dart';
import 'package:task_manager/ui/screen/create_task_screen.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/screen/tasks/canceled_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/completed_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/new_tasks_screen.dart';
import 'package:task_manager/ui/screen/tasks/progress_tasks_screen.dart';
import 'package:task_manager/ui/utils/colors.dart';
import 'package:task_manager/ui/widgets/custom_aler_dialog.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/task_status.dart';
import '../../data/utils/urls.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();

  bool _isLoading = false;

  Future<void> createTask() async {
    if(!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      "title":_titleTEController.text.trim(),
      "description":_descriptionTEController.text.trim(),
      "status":TaskStatus.newTask
    };
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createTaskUrl, requestBody);

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

    if(response.isSuccess && mounted) {
      _titleTEController.clear();
      _descriptionTEController.clear();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task created successfully!'),
        backgroundColor: newTaskColor,
      ));

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => const BottomNavBase()),
              (route) => false);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task creation failed!'),
        backgroundColor: Colors.red,
      ));
    }
  }

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
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => const CreateTaskScreen()));
        // },
        onPressed: addTaskModalBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addTaskModalBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0)
        )),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
                right: 18,
                left: 18,
                top: 18),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add new Task',
                      style: Theme.of(context).primaryTextTheme.titleLarge
                    ),
                  ),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: const InputDecoration(
                        hintText: 'Title of the task',
                        labelText: 'Title'
                    ),
                    maxLines: 1,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      if(value?.isEmpty ?? true) {
                        return 'Missing title!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _descriptionTEController,
                    decoration: const InputDecoration(
                      hintText: 'Brief description',
                      labelText: 'Description',
                    ),
                    maxLines: 4,
                    maxLength: 250,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: createTask,
                    // validator: (String? value) {
                    //   if(value?.isEmpty ?? true) {
                    //     return 'Description';
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 16,),
                  Visibility(
                    visible: _isLoading == false,
                    replacement: const Center(child: CircularProgressIndicator(),),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: createTask,
                          child: Image.asset(AssetsUtils.forwardPNG,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
      context: context, builder: (_) => CustomAlertDialog(
        onPress: signOut,
        title: 'Sign Out',
        content: 'Are you sure to sign out? You will be redirected to login page.',
        actionText: 'Sign Out'
    ));
  }

  Future<void> signOut() async{
    await AuthUtility.clearUserInfo();

    if(mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => const SplashScreen()),
              (route) => false);
    }
  }
}
