import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/colors.dart';
import '../../data/utils/urls.dart';
import '../widgets/custom_loading.dart';
import '../widgets/screen_background.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.emailAddress, required this.otpCode});

  final String emailAddress, otpCode;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();

  Future<void> postNewPassword() async {
    if(!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    Map<String,dynamic> requestBody = {
      "email":widget.emailAddress,
      "OTP":widget.otpCode,
      "password":_confirmPasswordTEController.text
    };
    final NetworkResponse response = await NetworkCaller().postRequest(
        Urls.setPasswordUrl, requestBody
    );
    Map<String, dynamic> decodedResponse = jsonDecode(jsonEncode(response.body));

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

      if(response.isSuccess && mounted) {
        if(decodedResponse['status'] == 'success') {
          _passwordTEController.clear();
          _confirmPasswordTEController.clear();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Password reset successful.'),
            backgroundColor: mainColor,
          ));

          Get.to(()=> const LoginScreen());
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid request!"),
            backgroundColor: Colors.red,
          ));
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Set password error!'),
          backgroundColor: Colors.red,
        ));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set Password',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                ),
                const SizedBox(height: 6,),
                Text('Minimum length password 8 character with letter and number combination',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).primaryTextTheme.titleSmall,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: const InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password'
                  ),
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  validator: (String? value) {
                    if(value?.isEmpty ?? true) {
                      return 'Please enter Password!';
                    }
                    if(value!.length < 8) {
                      return 'Password length must be 8 or more!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  controller: _confirmPasswordTEController,
                  decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      labelText: 'Confirm Password'
                  ),
                  textInputAction: TextInputAction.done,
                  onEditingComplete: postNewPassword,
                  obscureText: true,
                  validator: (String? value) {
                    if(value?.isEmpty ?? true) {
                      return 'Please confirm password!';
                    }
                    if(value! != _passwordTEController.text) {
                      return "Password didn't match!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                Visibility(
                  visible: _isLoading == false,
                  replacement: const CustomLoading(),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: postNewPassword,
                        child: const Text('Confirm'),
                      ),
                      signInButton(context)
                    ],
                  ),
                ),
              ],
            ),
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
