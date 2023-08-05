import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/data/utils/theme_utility.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';

class TaskManagerApp extends StatefulWidget {
  static GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeUtility.loadTheme();

      ThemeUtility.themeChangedCallback = (bool isLight) {
        setState(() {});
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: TaskManagerApp.globalKey,
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: _lightThemeData(context),
      darkTheme: _darkThemeData(context),
      themeMode: ThemeUtility.isLight ? ThemeMode.light : ThemeMode.dark,
      home: const SplashScreen(),
      // home: BottomNavBase(isLight: isLight, switchTheme: switchTheme),
    );
  }

  ThemeData _lightThemeData(BuildContext context) {
    return ThemeData(
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
      scaffoldBackgroundColor: mainColor.shade50,
      splashColor: Colors.white.withAlpha(15),
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
            color: Colors.black.withOpacity(0.75),
            letterSpacing: 0.5
          )
        ),
        labelMedium: GoogleFonts.nunito(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5
          )
        ),
        displaySmall: GoogleFonts.nunito(
            textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: mainColor.shade900,
                letterSpacing: 1
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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey.shade100
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: mainColor
      ),
      dialogBackgroundColor: Colors.grey.shade100,
      cardColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 3,
        focusElevation: 6,
        foregroundColor: Colors.white,
        iconSize: 32,
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(Colors.white)
      )
    );
  }

  ThemeData _darkThemeData(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: mainColor,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: mainColor.shade900,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: mainColor.shade900,
              systemNavigationBarIconBrightness: Brightness.light
          )
      ),
      scaffoldBackgroundColor: Colors.grey.shade900,
      splashColor: Colors.white.withAlpha(225),
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
              color: Colors.white.withOpacity(0.75),
              letterSpacing: 1.25
          ),
        ),
        titleSmall: GoogleFonts.nunito(
            textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.75),
                letterSpacing: 0.5
            )
        ),
        labelMedium: GoogleFonts.nunito(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5
          )
        ),
        displaySmall: GoogleFonts.nunito(
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: mainColor.shade300,
            letterSpacing: 1
          )
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.black,
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
          backgroundColor: mainColor.shade900,
          fixedSize: Size(
              MediaQuery.sizeOf(context).width,
              MediaQuery.sizeOf(context).height * 0.05),
        ),
      ),
      iconTheme: IconThemeData(
          color: mainColor.shade100,
          size: 30
      ),
      listTileTheme: ListTileThemeData(
          iconColor: mainColor.shade300,
          horizontalTitleGap: 3.0
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        unselectedItemColor: mainColor.shade200,
        backgroundColor: mainColor.shade900,
        elevation: 8
      ),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.grey.shade900
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: mainColor.shade300
      ),
      dialogBackgroundColor: Colors.grey.shade900,
      cardColor: Colors.black,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        focusElevation: 6,
        foregroundColor: Colors.white,
        backgroundColor: mainColor.shade900,
        iconSize: 32,
      ),
    );
  }
}