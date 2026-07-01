import 'package:dopamind/auth/auth_gate.dart';
import 'package:dopamind/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  final AuthService _authService =AuthService();

void logout() async{
  try {
    _authService.signOut();
  } on FirebaseAuthException catch (e) {
            if (!mounted) return null;
            ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())));
      
    }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () async{
          logout();
         if (!mounted) return;


  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const AuthGate()),
    (route) => false,
  );

        }, icon: Icon(Icons.logout))
      ],
      ),
    );
  }
}