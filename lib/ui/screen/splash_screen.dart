import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:task_manager/ui/utils/assets_utils.dart';
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
    Future.delayed(const Duration(seconds: 3)).then((value){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(AssetsUtils.logoSVG,
            width: MediaQuery.sizeOf(context).width * 0.25,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
