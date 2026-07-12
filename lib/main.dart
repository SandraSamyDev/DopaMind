import 'package:dopamind/screens/home_screen.dart';
import 'package:dopamind/screens/auth_screens/login_screen.dart';
import 'package:dopamind/screens/auth_screens/signup_screen.dart';
import 'package:dopamind/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'package:zo_app_blocker/zo_app_blocker.dart';
import 'package:dopamind/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'services/focus_foreground_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  FocusForegroundService.init();

  // await FirebaseAppCheck.instance.activate(
  //  providerAndroid: kDebugMode
  //       ? const AndroidDebugProvider()
  //       : const AndroidPlayIntegrityProvider(),
  // );
  await ZoAppBlocker.instance.initialize(
    blockScreenCallback: onBlockScreenRequested,
  );
  await NotificationService.initialize();
  await NotificationService.requestPermission();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: const DopaMindApp(),
    ),
  );
}


@pragma('vm:entry-point')
void onBlockScreenRequested() {
  ZoBlockScreenRunner.run(
    builder: (context) {
      // 1. SAFEGUARD: Get the package name that triggered the block
      final blockedPackage = context.packageName;
      
      // 2. Replace this with YOUR actual Flutter app's package id from AndroidManifest.xml
      const myAppPackage = 'com.example.dopamind'; 

      // If the system claims our own app is blocked, DO NOT close it.
      if (blockedPackage == myAppPackage) {
        return const SizedBox.shrink();
      }

      // 3. Only dismiss if it's a target social media/distracting app
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          context.onDismiss();
        } catch (e) {
          debugPrint("Error handling native dismiss execution: $e");
        }
      });
      
      return const SizedBox.shrink();
    },
  );
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
      home: SplashScreen(),
      routes: {
        "sign up": (context) => SignUpPage(),
        "log in": (context) => LoginPage(),
        "homescreen": (context) => HomeScreen(),
      },
    );
  }
}
