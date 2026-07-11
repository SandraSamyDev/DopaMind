import 'package:dopamind/screens/home_screen.dart';
import 'package:dopamind/screens/auth_screens/login_screen.dart';
import 'package:dopamind/screens/auth_screens/signup_screen.dart';
import 'package:dopamind/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'package:zo_app_blocker/zo_app_blocker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await FirebaseAppCheck.instance.activate(
  //  providerAndroid: kDebugMode
  //       ? const AndroidDebugProvider()
  //       : const AndroidPlayIntegrityProvider(),
  // );
  await ZoAppBlocker.instance.initialize(blockScreenCallback: onBlockScreenRequested);


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
      return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (context.appIcon != null)
                Image.memory(context.appIcon!, width: 100, height: 100),
              const SizedBox(height: 24),
              Text(
                '${context.appName ?? 'App'} is Blocked!',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 48),
              // Dismiss button
              ElevatedButton(
                onPressed: ()async{
                  context.onDismiss();

                },
                child: const Text('Exit'),
              ),
              const SizedBox(height: 16),
              // Unlock button for the current session
              
            ],
          ),
        ),
      );
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
