import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ezhealth_app/config/palette.dart';
import 'package:ezhealth_app/screens/extra_screens/restart.dart';
import 'package:ezhealth_app/screens/extra_screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    RestartWidget(
      child: MaterialApp(
        title: "EZHEALTH",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Palette.scaffoldColor,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}
