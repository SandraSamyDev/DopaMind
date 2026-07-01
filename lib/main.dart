import 'package:dopamind/screens/home_screen.dart';
import 'package:dopamind/screens/login_screen.dart';
import 'package:dopamind/screens/signup_screen.dart';
import 'package:dopamind/screens/splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );

  // await FirebaseAppCheck.instance.activate(
  //  providerAndroid: kDebugMode 
  //       ? const AndroidDebugProvider() 
  //       : const AndroidPlayIntegrityProvider(),
  // );

  runApp(const DopaMindApp());
}

class DopaMindApp extends StatefulWidget {
  const DopaMindApp({super.key});

  @override
  State<DopaMindApp> createState() => _DopaMindAppState();
}

class _DopaMindAppState extends State<DopaMindApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DopaMind',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {"sign up": (context)=>SignUpPage(),
      "log in": (context)=>LoginPage(),
      // "homescreen": (context)=>HomeScreen(),
      },
    );
  }
}