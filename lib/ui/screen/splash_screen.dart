import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/utils/assets_utils.dart';
import 'package:task_manager/data/utils/auth_utility.dart';
import 'package:task_manager/ui/screen/bottom_nav_base.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToNextPage();
    });
  }

  void navigateToNextPage() {
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      final bool isUserLoggedIn = await AuthUtility.isUserLoggedIn();
      Get.offAll(()=> isUserLoggedIn
        ? const BottomNavBase()
        : const LoginScreen()
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetsUtils.appLogoPNG,
                width: MediaQuery.sizeOf(context).width * 0.2
            ),
            Text('Task Manager', textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                color: mainColor,
                fontSize: MediaQuery.sizeOf(context).width * 0.075
              )
            ),
          ],
        ),
      ),
    );
  }
}
