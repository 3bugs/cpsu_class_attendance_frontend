import 'package:classroom_attendance/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CP-SU Classroom Attendance',
      theme: ThemeData(
        fontFamily: GoogleFonts.sarabun().fontFamily,
        primarySwatch: Palette.colorTheme,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black54),
          titleMedium: TextStyle(fontSize: 19.0),
          titleSmall: TextStyle(fontSize: 16.0),
          bodyLarge: TextStyle(fontSize: 22.0),
          bodyMedium: TextStyle(fontSize: 19.0),
          bodySmall: TextStyle(fontSize: 16.0),
          labelLarge: TextStyle(fontSize: 20.0), // ข้อความบนปุ่ม
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      home: const LoginPage(),
    );
  }
}

class Palette {
  static const MaterialColor colorTheme = MaterialColor(
    //0xFF722922,
    0xff007468,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff66aca4), //10%
      100: Color(0xff4d9e95), //20%
      200: Color(0xff339086), //30%
      300: Color(0xff1a8277), //40%
      400: Color(0xff007468), //50%
      500: Color(0xff00685e), //60%
      600: Color(0xff005d53), //70%
      700: Color(0xff005149), //80%
      800: Color(0xff00463e), //90%
      900: Color(0xff003a34), //100%
    },
  );
}
