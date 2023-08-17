import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/ui/screen/set_password_screen.dart';
import 'package:task_manager/ui/state_managers/pin_verification_controller.dart';

import '../widgets/custom_loading.dart';
import '../widgets/screen_background.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.emailAddress});

  final String emailAddress;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _pinCodeTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PIN Verification',
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
                child: PinCodeTextField(
                  controller: _pinCodeTEController,
                  appContext: context,
                  length: 6,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    borderWidth: 0.5,
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white
                  ),
                  backgroundColor: Colors.white,
                  cursorColor: mainColor,
                  animationType: AnimationType.scale,
                  // onEditingComplete: verifyEmailWithPin,
                ),
              ),
              const SizedBox(height: 16,),
              GetBuilder<PinVerificationController>(
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

                            controller.verifyEmailWithPin(widget.emailAddress, _pinCodeTEController.text.trim()).then((value) {
                              if(value == true) {
                                Get.offAll(()=> SetPasswordScreen(
                                  emailAddress: widget.emailAddress,
                                  otpCode: _pinCodeTEController.text,
                                ));
                                Get.snackbar(
                                    'Success', 'Set new password',
                                    backgroundColor: mainColor,
                                    colorText: Colors.white
                                );
                              } else {
                                Get.snackbar(
                                    'Failed', 'Verification failed! Try again.',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white
                                );
                              }
                            });
                          },
                          child: const Text('Verify'),
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
