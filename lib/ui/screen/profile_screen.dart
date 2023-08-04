import 'package:flutter/material.dart';
import 'package:task_manager/data/utils/auth_utility.dart';

import '../widgets/screen_background.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _emailTEController.text = AuthUtility.userInfo.data?.email ?? '';
    _firstNameTEController.text = AuthUtility.userInfo.data?.firstName ?? '';
    _lastNameTEController.text = AuthUtility.userInfo.data?.lastName ?? '';
    _mobileTEController.text = AuthUtility.userInfo.data?.mobile ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'),),
      body: ScreenBackground(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 35),
                      child: CircleAvatar(
                        minRadius: 35,
                        maxRadius: 55,
                        foregroundImage: NetworkImage(AuthUtility.userInfo.data?.photo ?? ''),
                        // foregroundImage: NetworkImage('https://images.unsplash.com/photo-1575936123452-b67c3203c357'),
                        onForegroundImageError: (_, __) {
                          return;
                        },
                        child: Text('${AuthUtility.userInfo.data?.firstName![0]}',
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: IconButton(
                      onPressed: () {
                        print('hey');
                      },
                      icon: const Icon(Icons.add_a_photo)
                    ),
                  )
                ],
              ),
              TextFormField(
                controller: _emailTEController,
                decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email'
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: false,
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
              const SizedBox(height: 16,),
              Visibility(
                visible: _isLoading == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: ElevatedButton(
                  onPressed: (){},
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}