import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authchanges => firebaseAuth.userChanges();
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '616774633841-8887dqvflq1l53htc6pe1c4n0f7bgtqv.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        return null;
      }

      await Future.delayed(Duration.zero);

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print("Google Auth Stalled Event Info: $e");
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("Error during clean logout sequence: $e");
      }
    }
  }

  Future<UserCredential> createAccount({
    required String username,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? newUser = userCredential.user;

    if (newUser != null) {
      await newUser.updateDisplayName(username);

      await FirebaseFirestore.instance.collection("users").doc(newUser.uid).set(
        {
          "name": username,
          "email": email,
          "createdAt": FieldValue.serverTimestamp(),
        },
      );

      if (kDebugMode) {
        print("USER DOC CREATED");
      }
    }

    return userCredential;
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String email,
    required String currentpassword,
    required String newpassword,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentpassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newpassword);
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = firebaseAuth.currentUser;
      await user?.sendEmailVerification();
    } catch (e) {
      throw Exception("Failed to send verification email: ${e.toString()}");
    }
  }

  Future<bool> checkEmailVerified() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();

      firebaseAuth.userChanges();
      return firebaseAuth.currentUser?.emailVerified ?? false;
    }
    return false;
  }
}
