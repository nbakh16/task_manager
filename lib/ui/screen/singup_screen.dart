import 'package:flutter/material.dart';

import '../utils/assets_utils.dart';
import '../widgets/screen_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

TextEditingController _emailTEController = TextEditingController();
TextEditingController _firstNameTEController = TextEditingController();
TextEditingController _lastNameTEController = TextEditingController();
TextEditingController _mobileTEController = TextEditingController();
TextEditingController _passwordTEController = TextEditingController();

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
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
              Row(
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
              )
            ],
          ),
        )
    );
  }
}
