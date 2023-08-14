import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/screen/pin_verification_screen.dart';

import '../../data/utils/colors.dart';
import '../../data/utils/urls.dart';
import '../widgets/custom_loading.dart';
import '../widgets/screen_background.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();

  Future<void> sendPinToEmail() async {
    if(!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    final String responseUrl = Urls.recoveryEmailUrl(_emailTEController.text);
    final NetworkResponse response = await NetworkCaller().getRequest(responseUrl);

    Map<String, dynamic> decodedResponse = jsonDecode(jsonEncode(response.body));

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

    if(response.isSuccess && mounted) {
      if(decodedResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Verification mail sent. Kindly check your email.'),
          backgroundColor: mainColor,
        ));

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PinVerificationScreen(emailAddress: _emailTEController.text)
            ));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not found!'),
          backgroundColor: Colors.red,
        ));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed sending email!'),
        backgroundColor: Colors.red,
      ));
    }
  }

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
                  onEditingComplete: sendPinToEmail,
                ),
              ),
              const SizedBox(height: 16,),
              Visibility(
                visible: _isLoading == false,
                replacement: const CustomLoading(),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: sendPinToEmail,
                      child: const LineIcon.chevronCircleRight(),
                    ),
                    signInButton(context)
                  ],
                ),
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
