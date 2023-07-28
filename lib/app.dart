import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/utils/colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: mainColor,
        primaryTextTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.75),
            letterSpacing: 0.75
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
            ),
            foregroundColor: Colors.white
          )
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}