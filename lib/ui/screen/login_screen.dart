import 'package:flutter/material.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/utils/auth_utility.dart';
import 'package:task_manager/ui/screen/bottom_nav_base.dart';
import 'package:task_manager/ui/screen/email_verification_screen.dart';
import 'package:task_manager/ui/screen/singup_screen.dart';
import 'package:task_manager/data/utils/assets_utils.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isObscureText = true;

  Future<void> loginUser() async {
    if(!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      "email":_emailTEController.text.trim(),
      "password":_passwordTEController.text
    };
    final NetworkResponse response = await NetworkCaller().postRequest(Urls.loginUrl, requestBody, onLoginScreen: true);

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

    if(response.isSuccess && mounted) {
      LoginModel loginModel = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(loginModel);

      _emailTEController.clear();
      _passwordTEController.clear();

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login Successful!'),
          backgroundColor: mainColor,
        ));

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const BottomNavBase()),
                (route) => false);
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login Failed!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _emailTEController.text = 'test@email.com';
    _passwordTEController.text = '12345678';
    return Scaffold(
      body: ScreenBackground(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Get Started With',
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
                textInputAction: TextInputAction.done,
                onEditingComplete: loginUser,
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
                replacement: const Center(child: CircularProgressIndicator(),),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: loginUser,
                      child: Image.asset(AssetsUtils.forwardPNG,),
                    ),
                    forgotPasswordButton(context),
                    signUpButton(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Center forgotPasswordButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EmailVerificationScreen()
              ));
        },
        child: Text('Forgot Password?',
          style: TextStyle(
              color: Colors.black.withOpacity(0.35)
          ),
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
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignupScreen()
                ));
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
