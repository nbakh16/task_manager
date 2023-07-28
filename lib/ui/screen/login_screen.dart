import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController emailTEController = TextEditingController();
TextEditingController passwordTEController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Get Started With',
                textAlign: TextAlign.start,
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: emailTEController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email'
                ),
              ),
              const SizedBox(height: 12,),
              TextFormField(
                controller: passwordTEController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password'
                ),
              ),
              const SizedBox(height: 16,),
              ElevatedButton(
                onPressed: () {

                },
                child: const Icon(Icons.arrow_forward_ios,)
              ),
              TextButton(
                  onPressed: () {

                  },
                  child: Text('Forgot Password?',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5)
                    ),
                  ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have account? "),
                  TextButton(
                    onPressed: () {

                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
