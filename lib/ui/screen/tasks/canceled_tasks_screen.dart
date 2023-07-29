import 'package:flutter/material.dart';

class CanceledTasksScreen extends StatefulWidget {
  const CanceledTasksScreen({super.key});

  @override
  State<CanceledTasksScreen> createState() => _CanceledTasksScreenState();
}

class _CanceledTasksScreenState extends State<CanceledTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Canceled'),
      ),
    );
  }
}
