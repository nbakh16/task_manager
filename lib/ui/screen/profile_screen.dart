import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/utils/auth_utility.dart';
import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/colors.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
//TODO: change password option only when user's current password matches
class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  UserData userData = AuthUtility.userInfo.data!;
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailTEController.text = userData.email!;
    _firstNameTEController.text = userData.firstName!;
    _lastNameTEController.text = userData.lastName!;
    _mobileTEController.text = userData.mobile!;
  }

  File? image;
  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      final imageTemp = File(image.path);
      this.image = imageTemp;
      setState(() {});
    } on PlatformException catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> updateProfile() async {
    if(!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      // "email": AuthUtility.userInfo.data!.email,
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      // "photo": image?.toString().split(' ').last.replaceAll("'", "") ?? AuthUtility.userInfo.data?.photo ?? ""
    };
    final NetworkResponse response = await NetworkCaller().postRequest(Urls.profileUpdateUrl, requestBody);

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

    if(response.isSuccess && mounted) {
      userData.firstName = _firstNameTEController.text.trim();
      userData.lastName = _lastNameTEController.text.trim();
      userData.mobile = _mobileTEController.text.trim();
      AuthUtility.updateUserInfo(userData);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile updated!'),
        backgroundColor: mainColor,
      ));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update profile!'),
        backgroundColor: Colors.red,
      ));
    }
    await AuthUtility.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
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
                      child: InkWell(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                        child: CircleAvatar(
                          minRadius: 35,
                          maxRadius: 55,
                          foregroundImage: image != null
                              ? FileImage(image!)
                              : NetworkImage(AuthUtility.userInfo.data?.photo ?? '') as ImageProvider,
                          // foregroundImage: NetworkImage(AuthUtility.userInfo.data?.photo ?? ''),
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
                  ),
                  const Positioned(
                    bottom: 16,
                    child: IgnorePointer(
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.add_a_photo)),
                    )
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
                textInputAction: TextInputAction.done,
                validator: (String? value) {
                  if(value?.isEmpty ?? true) {
                    return 'Please enter your Mobile Number!';
                  }
                  if(value!.length < 11) {
                    return 'Mobile Number is not valid!';
                  }
                  return null;
                },
                onEditingComplete: updateProfile,
              ),
              const SizedBox(height: 16,),
              Visibility(
                visible: _isLoading == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: ElevatedButton(
                  // onPressed: updateProfile,
                  onPressed: updateProfile,
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: mainColor.withOpacity(0.15),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Choose an action',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
