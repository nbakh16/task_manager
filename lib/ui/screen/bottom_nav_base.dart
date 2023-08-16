import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:line_icons/line_icon.dart';
import 'package:task_manager/data/utils/auth_utility.dart';
import 'package:task_manager/data/utils/base64_image.dart';
import 'package:task_manager/data/utils/tasks_screen_info.dart';
import 'package:task_manager/data/utils/theme_utility.dart';
import 'package:task_manager/ui/screen/profile_screen.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/screen/tasks_screen.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/ui/widgets/custom_alert_dialog.dart';
import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/task_status.dart';
import '../../data/utils/urls.dart';
import '../widgets/custom_loading.dart';

class BottomNavBase extends StatefulWidget {
  const BottomNavBase({super.key});

  @override
  State<BottomNavBase> createState() => _BottomNavBaseState();
}

class _BottomNavBaseState extends State<BottomNavBase> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

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

      Get.offAll(() => const BottomNavBase());
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
        title: profileSummary(context),
        actions: [
          IconButton(
            onPressed: ThemeUtility.switchTheme,
            icon: Visibility(
              visible: ThemeUtility.isLight,
              replacement: const LineIcon.moon(),
              child: const LineIcon.sun()
            )
          ),
          IconButton(
            onPressed: () => signOutShowDialog(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          TasksScreen(TasksScreenInfo(
              responseUrl: Urls.newTasksListUrl,
              taskStatus: TaskStatus.newTask,
              chipColor: newTaskColor)),
          TasksScreen(TasksScreenInfo(
              responseUrl: Urls.progressTasksListUrl,
              taskStatus: TaskStatus.progressTask,
              chipColor: progressTaskColor)),
          TasksScreen(TasksScreenInfo(
              responseUrl: Urls.canceledTasksListUrl,
              taskStatus: TaskStatus.canceledTask,
              chipColor: canceledTaskColor)),
          TasksScreen(TasksScreenInfo(
              responseUrl: Urls.completedTasksListUrl,
              taskStatus: TaskStatus.completedTask,
              chipColor: completedTaskColor)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(icon: LineIcon.clipboardList(), label: 'New Task'),
          BottomNavigationBarItem(icon: LineIcon.cog(), label: 'Progress'),
          BottomNavigationBarItem(icon: LineIcon.ban(), label: 'Canceled'),
          BottomNavigationBarItem(icon: LineIcon.checkCircle(), label: 'Completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTaskModalBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  InkWell profileSummary(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(()=> const ProfileScreen()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          profilePicture(),
          const SizedBox(width: 12.0,),
          appBarTitle(context),
        ],
      ),
    );
  }

  Column appBarTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('${AuthUtility.userInfo.data?.firstName.toString()} '
              '${AuthUtility.userInfo.data?.lastName.toString()}',
              style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                  color: Colors.white
              )),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(AuthUtility.userInfo.data?.email.toString() ?? "email@abc.com",
              style: Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
                  color: mainColor.shade50
              )),
        ),
      ],
    );
  }

  CircleAvatar profilePicture() {
    String userPhoto = AuthUtility.userInfo.data!.photo!;
    return CircleAvatar(
      radius: 25,
      foregroundImage: Base64Image.getBase64Image(userPhoto),
    );
  }

  void createTaskModalBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0)
        )),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 18,
                  right: 18,
                  left: 18,
                  top: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: AnimateList(
                  interval: 70.ms,
                  effects: const [ScaleEffect(curve: Curves.easeInOut)],
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add new Task',
                            style: Theme.of(context).primaryTextTheme.titleLarge
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(Icons.cancel_outlined,
                              color: Colors.red.shade300,
                            )
                          )
                        ],
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
                      replacement: const CustomLoading(),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: createTask,
                            child: const LineIcon.chevronCircleRight(),
                          ),
                        ],
                      ),
                    ),
                  ],)
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> signOutShowDialog(BuildContext context) {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      pageBuilder: (_, __, ___) {
        return Container();
      },
      transitionBuilder: (_, anim, __, ___) {
        return Transform.scale(
          scale: Curves.easeInOut.transform(anim.value),
          child: CustomAlertDialog(
              onPress: signOut,
              title: 'Sign Out',
              content: 'Are you sure to sign out? You will be redirected to login page.',
              actionText: 'Sign Out'
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> signOut() async{
    await AuthUtility.clearUserInfo();
    Get.offAll(()=> const SplashScreen());
  }
}
