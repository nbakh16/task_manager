import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/data/utils/colors.dart';

class TaskManagerApp extends StatefulWidget {
  static GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: TaskManagerApp.globalKey,
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: mainColor,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.grey.shade50,
            systemNavigationBarIconBrightness: Brightness.dark
          )
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          const TextTheme(
            labelLarge:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: mainColor
              )
            ),
        ),
        primaryTextTheme: TextTheme(
          titleLarge: GoogleFonts.oswald(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.75),
              letterSpacing: 1.25
            ),
          ),
          titleSmall: GoogleFonts.nunito(
           textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.5),
              letterSpacing: 0.5
            )
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: mainColor, width: 1
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.red, width: 1
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)
            ),
            foregroundColor: Colors.white,
            fixedSize: Size(
              MediaQuery.sizeOf(context).width,
              MediaQuery.sizeOf(context).height * 0.05),
          ),
        ),
        iconTheme: IconThemeData(
          color: mainColor.shade300,
          size: 30
        ),
        listTileTheme: ListTileThemeData(
          iconColor: mainColor.shade300,
          horizontalTitleGap: 3.0
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 3,
          focusElevation: 6,
          foregroundColor: Colors.white,
          iconSize: 32,
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}