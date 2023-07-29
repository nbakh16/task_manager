import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/email_verification_screen.dart';
import 'package:task_manager/ui/screen/singup_screen.dart';
import 'package:task_manager/ui/utils/assets_utils.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController _emailTEController = TextEditingController();
TextEditingController _passwordTEController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
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
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: _passwordTEController,
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password'
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () {

              },
              child: Image.asset(AssetsUtils.forwardPNG,),
            ),
            Center(
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
                    color: Colors.black.withOpacity(0.5)
                  ),
                ),
              ),
            ),
            Row(
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
            )
          ],
        ),
      )
    );
  }
}
