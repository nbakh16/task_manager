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
import '../widgets/custom_loading.dart';
import '../widgets/screen_background.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
//TODO: change password option only when user's current password matches
class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordChanging = false;

  UserData userData = AuthUtility.userInfo.data!;
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();

  final TextEditingController _currentPasswordTEController = TextEditingController();
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _newConfirmPasswordTEController = TextEditingController();

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

  Future<void> changePassword() async {
    if(!_passwordFormKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    _isPasswordChanging = true;
    if(mounted) {
      setState(() {});
    }

    Map<String, dynamic> loginRequestBody = {
      "email":AuthUtility.userInfo.data!.email,
      "password":_currentPasswordTEController.text
    };

    final NetworkResponse loginResponse = await NetworkCaller().postRequest(Urls.loginUrl, loginRequestBody, onProfileScreen: true);

    if(loginResponse.isSuccess) {
      Map<String, dynamic> requestBody = {
        "password":_newPasswordTEController.text,
      };

      final NetworkResponse response = await NetworkCaller().postRequest(Urls.profileUpdateUrl, requestBody);

      if(response.isSuccess && mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password updated!'),
          backgroundColor: mainColor,
        ));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to update profile!'),
          backgroundColor: Colors.red,
        ));
      }
    }
    else {
      if (mounted) {
        Fluttertoast.showToast(
                  msg: "Wrong current password",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
      }
    }

    _isPasswordChanging = false;
    if(mounted) {
      setState(() {});
    }
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
                        onTap: () => _imageSelectBottomSheet(context),
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
                child: Column(
                  children: [
                    ElevatedButton(
                      // onPressed: updateProfile,
                      onPressed: updateProfile,
                      child: const Text('Update'),
                    ),
                    const SizedBox(height: 6.0,),
                    TextButton(
                      onPressed: () {
                        _changePasswordBottomSheet();
                      },
                      child: const Text('Change Password'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _imageSelectBottomSheet(BuildContext context) {
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

  void _changePasswordBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0)
            )),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 18,
                  right: 18,
                  left: 18,
                  top: 18),
              child: Form(
                key: _passwordFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Change Password',
                              style: Theme.of(context).primaryTextTheme.titleLarge
                          ),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.cancel_outlined,
                                color: Colors.red.shade300,
                              )
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _currentPasswordTEController,
                      decoration: const InputDecoration(
                          hintText: 'Current Password',
                          labelText: 'Current Password'
                      ),
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (String? value) {
                        if(value?.isEmpty ?? true) {
                          return 'Fill current password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30,),
                    TextFormField(
                      controller: _newPasswordTEController,
                      decoration: const InputDecoration(
                        hintText: 'New Password',
                        labelText: 'New Password',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        if(value?.isEmpty ?? true) {
                          return 'Please enter New Password!';
                        }
                        if(value!.length < 8) {
                          return 'Password length must be 8 or more!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0,),
                    TextFormField(
                      controller: _newConfirmPasswordTEController,
                      decoration: const InputDecoration(
                        hintText: 'Confirm New Password',
                        labelText: 'Confirm New Password',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                      validator: (String? value) {
                        if(value?.isEmpty ?? true) {
                          return 'Please confirm New Password!';
                        }
                        if(value! != _newPasswordTEController.text) {
                          return "Password didn't match!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    Visibility(
                      visible: _isPasswordChanging == false,
                      replacement: const CustomLoading(),
                      child: ElevatedButton(
                        onPressed: changePassword,
                        child: const Text('Proceed'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
