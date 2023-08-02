import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/auth_utility.dart';
import 'package:task_manager/ui/screen/bottom_nav_base.dart';
import 'package:task_manager/ui/utils/colors.dart';

import '../../data/models/login_model.dart';
import '../../data/utils/urls.dart';
import '../utils/assets_utils.dart';
import '../widgets/screen_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _isLoading = false;
  bool _isObscureText = true;

  Future<void> userSignup() async {
    if(!_formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": ""
    };
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.signupUrl, requestBody);

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

    log(Urls.signupUrl);
    if(response.isSuccess && mounted) {
      _emailTEController.clear();
      _firstNameTEController.clear();
      _lastNameTEController.clear();
      _mobileTEController.clear();
      _passwordTEController.clear();

      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign up successful!'),
        backgroundColor: mainColor,));

      LoginModel loginModel = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(loginModel);

      if(mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBase()),
                (route) => false
        );
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign up failed!'),
        backgroundColor: Colors.red,));
      FocusScope.of(context).unfocus();
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
                Text('Join With Us',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email'
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
                  controller: _firstNameTEController,
                  decoration: const InputDecoration(
                      hintText: 'First Name',
                      labelText: 'First Name'
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (String? value) {
                    if(value?.isEmpty ?? true) {
                      return 'Please enter your First Name!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(
                      hintText: 'Last Name',
                      labelText: 'Last Name'
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (String? value) {
                    if(value?.isEmpty ?? true) {
                      return 'Please enter your Last Name!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  controller: _mobileTEController,
                  decoration: const InputDecoration(
                      hintText: 'Mobile',
                      labelText: 'Mobile'
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (String? value) {
                    if(value?.isEmpty ?? true) {
                      return 'Please enter your Mobile Number!';
                    }
                    if(value!.length < 11) {
                      return 'Mobile Number is not valid!';
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
                  onEditingComplete: userSignup,
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
                const SizedBox(height: 16,),
                Visibility(
                  visible: _isLoading == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: userSignup,
                        child: Image.asset(AssetsUtils.forwardPNG,),
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
