import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/data/utils/auth_utility.dart';
import 'package:task_manager/ui/screen/bottom_nav_base.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:task_manager/data/utils/assets_utils.dart';
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
    navigateToNextPage();
  }

  void navigateToNextPage() {
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      final bool isUserLoggedIn = await AuthUtility.isUserLoggedIn();

      if(mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => isUserLoggedIn
                    ? const BottomNavBase()
                    : const LoginScreen()
            ),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.1,
              child: SvgPicture.asset(AssetsUtils.ostadLogoSVG,
                width: MediaQuery.sizeOf(context).width * 0.85,
                fit: BoxFit.scaleDown,
              ),
            ),
            Text('Task\nManager', textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                color: mainColor,
                fontSize: MediaQuery.sizeOf(context).width * 0.125
              )
            ),
          ],
        ),
      ),
    );
  }
}
