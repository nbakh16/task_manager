import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';

import '../../data/utils/urls.dart';
import '../utils/assets_utils.dart';
import '../utils/colors.dart';
import '../widgets/screen_background.dart';
import 'bottom_nav_base.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();

  bool _isLoading = false;

  Future<void> createTask() async {
    if(!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      "title":_titleTEController.text.trim(),
      "description":_descriptionTEController.text.trim(),
      "status":"New"
    };
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.createTaskUrl, requestBody);

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

    if(response.isSuccess && mounted) {
      _titleTEController.clear();
      _descriptionTEController.clear();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task created successfully!'),
        backgroundColor: newTaskColor,
      ));

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => const BottomNavBase()),
              (route) => false);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task creation failed!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task'),),
      body: ScreenBackground(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create new task',
                textAlign: TextAlign.start,
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _titleTEController,
                decoration: const InputDecoration(
                    hintText: 'Title of the task',
                    labelText: 'Title'
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (String? value) {
                  if(value?.isEmpty ?? true) {
                    return 'Missing title!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12,),
              TextFormField(
                controller: _descriptionTEController,
                decoration: const InputDecoration(
                  hintText: 'Brief description',
                  labelText: 'Description',
                ),
                maxLines: 4,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onEditingComplete: createTask,
                // validator: (String? value) {
                //   if(value?.isEmpty ?? true) {
                //     return 'Description';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16,),
              Visibility(
                visible: _isLoading == false,
                replacement: const Center(child: CircularProgressIndicator(),),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: createTask,
                      child: Image.asset(AssetsUtils.forwardPNG,),
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
}
