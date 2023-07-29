import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/login_screen.dart';

import '../widgets/screen_background.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

TextEditingController _passwordTEController = TextEditingController();
TextEditingController _confirmPasswordTEController = TextEditingController();

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
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
              ),
              const SizedBox(height: 12,),
              TextFormField(
                controller: _confirmPasswordTEController,
                decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password'
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16,),
              ElevatedButton(
                onPressed: () {

                },
                child: const Text('Confirm'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()
                          ));
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}
