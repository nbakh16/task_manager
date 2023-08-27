import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:task_manager/ui/screen/pin_verification_screen.dart';

import '../../data/utils/colors.dart';
import '../state_managers/email_verification_controller.dart';
import '../widgets/custom_loading.dart';
import '../widgets/screen_background.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Email Address',
                textAlign: TextAlign.start,
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              const SizedBox(height: 6,),
              Text('A 6 digit verification pin will send to your email address',
                textAlign: TextAlign.start,
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
              const SizedBox(height: 16,),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (String? value) {
                    if(value?.isEmpty ?? true) {
                      return 'Please enter Email!';
                    }
                    return null;
                  },
                  // onEditingComplete: sendPinToEmail,
                ),
              ),
              const SizedBox(height: 16,),
              GetBuilder<EmailVerificationController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.isLoading == false,
                    replacement: const CustomLoading(),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if(!_formKey.currentState!.validate()) {
                              return;
                            }
                            FocusScope.of(context).unfocus();

                            controller.sendPinToEmail(_emailTEController.text.trim()).then((value) {
                              if(value == true) {
                                Get.to(()=> PinVerificationScreen(emailAddress: _emailTEController.text));
                                Get.snackbar(
                                    'OTP Sent', 'Verification mail sent. Kindly check your email.',
                                    backgroundColor: mainColor,
                                    colorText: Colors.white
                                );
                              } else {
                                Get.snackbar(
                                    'Failed', "Couldn't send verification email! Try again.",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white
                                );
                              }
                            });
                          },
                          child: const LineIcon.chevronCircleRight(),
                        ),
                        signInButton(context)
                      ],
                    ),
                  );
                }
              ),
            ],
          ),
        )
    );
  }

  Row signInButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Have account? "),
        TextButton(
          onPressed: ()=> Get.back(),
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
