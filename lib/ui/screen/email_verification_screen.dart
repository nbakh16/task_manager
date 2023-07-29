import 'package:flutter/material.dart';

import '../utils/assets_utils.dart';
import '../widgets/screen_background.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

TextEditingController _emailTEController = TextEditingController();

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
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
              const SizedBox(height: 12,),
              Text('A 6 digit verification pin will send to your email address',
                textAlign: TextAlign.start,
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _emailTEController,
                decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email'
                ),
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
