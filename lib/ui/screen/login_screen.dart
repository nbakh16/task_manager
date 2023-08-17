import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:line_icons/line_icon.dart';
import 'package:task_manager/data/utils/assets_utils.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/ui/screen/email_verification_screen.dart';
import 'package:task_manager/ui/screen/singup_screen.dart';
import 'package:task_manager/ui/state_managers/login_controller.dart';
import 'package:task_manager/ui/widgets/custom_loading.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:get/get.dart';

import 'bottom_nav_base.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimateList(
            interval: 50.ms,
              effects: [
                const ScaleEffect(curve: Curves.easeInOut),
                ShimmerEffect(delay: 900.ms, color: mainColor.shade100.withOpacity(0.35))
              ],
            children: [
              Align(alignment: Alignment.center, child: Image.asset(AssetsUtils.appLogoPNG, width: 64)),
              const SizedBox(height: 16),
              Text('Get Started With',
                textAlign: TextAlign.start,
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _emailTEController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  prefixIcon: LineIcon.at()
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (String? value) {
                  if(value?.isEmpty ?? true) {
                    return 'Please enter Email!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12,),
              TextFormField(
                controller: _passwordTEController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: const LineIcon.key(),
                  suffixIcon: IconButton(
                    onPressed: (){
                      _isObscureText = !_isObscureText;
                      setState(() {});
                    },
                    icon: Icon(
                      _isObscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: mainColor.shade200,
                    )
                  )
                ),
                obscureText: _isObscureText,
                textInputAction: TextInputAction.done,
                // onEditingComplete: loginUser,
                validator: (String? value) {
                  if(value?.isEmpty ?? true) {
                    return 'Please enter Password!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              GetBuilder<LoginController>(
                builder: (loginController) {
                  return Visibility(
                    visible: loginController.isLoading == false,
                    replacement: const CustomLoading(),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if(!_formKey.currentState!.validate()) {
                              return;
                            }
                            FocusScope.of(context).unfocus();

                            loginController.loginUser(
                              _emailTEController.text.trim(),
                              _passwordTEController.text
                            ).then((value) {
                              if(value == true) {
                                Get.offAll(()=> const BottomNavBase());
                                Get.snackbar(
                                  'Success', 'Login Successful!',
                                  backgroundColor: mainColor,
                                  colorText: Colors.white,
                                    borderWidth: 1,
                                    borderColor: Colors.white
                                );
                              } else {
                                Get.snackbar(
                                  'Failed', 'Login Failed! Try again.',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white
                                );
                                }
                            });
                          },
                          child: const LineIcon.chevronCircleRight()
                        ),
                        forgotPasswordButton(context),
                        signUpButton(context)
                      ],
                    ),
                  );
                }
              ),
            ],)
          ),
        ),
      )
    );
  }

  Center forgotPasswordButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Get.to(()=> const EmailVerificationScreen()),
        child: Text('Forgot Password?',
          style: Theme.of(context).primaryTextTheme.displaySmall
        ),
      ),
    );
  }

  Row signUpButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account? "),
        TextButton(
          onPressed: ()=> Get.to(()=> const SignupScreen()),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
