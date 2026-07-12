import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img; // Uses your existing image package layout

class PhotoService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // 1. Read the bytes from the selected large file
      final bytes = await imageFile.readAsBytes();

      // 2. Decode the image image background data
      final img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) return null;

      // 3. Downscale resolution safely if it's a massive camera photo
      // Keeps aspect ratio intact, but caps width/height to safe database dimensions
      img.Image resizedImage = decodedImage;
      if (decodedImage.width > 800 || decodedImage.height > 800) {
        resizedImage = img.copyResize(
          decodedImage, 
          width: decodedImage.width > decodedImage.height ? 800 : null,
          height: decodedImage.height >= decodedImage.width ? 800 : null,
        );
      }

      // 4. Compress to JPEG quality 70% to drastically shrink file weight
      final List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 70);

      // 5. Convert to Base64 String
      final String base64String = base64.encode(compressedBytes);
      final String dataUrl = 'data:image/jpeg;base64,$base64String';

      // Double-check the string size before sending to prevent crashes
      if (dataUrl.length > 1048487) {
        print("Image is still too large for Firestore text limits.");
        return null;
      }

      // 6. Write to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'profileImage': dataUrl,
      }, SetOptions(merge: true));

      return dataUrl;
    } catch (e) {
      print("Firestore Profile Save Failure: $e");
      return null;
    }
  }
}