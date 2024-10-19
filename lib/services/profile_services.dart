import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class ProfileServices {
  Future<Map<String, dynamic>> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (user != null) {
      String userId = user.uid;
      String email = prefs.getString('${userId}_email') ?? '';
      String username = prefs.getString('${userId}_username') ?? 'User Name';
      String phone = prefs.getString('${userId}_phone') ?? '';
      String? imageBase64 = prefs.getString('${userId}_imageBase64');

      return {
        'email': email,
        'username': username,
        'phone': phone,
        'imageBase64': imageBase64,
      };
    }
    throw Exception("User not found");
  }

  Future<void> saveUserData(String email, String username, String phone, String? imageBase64) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = user.uid;

      await prefs.setString('${userId}_email', email);
      await prefs.setString('${userId}_username', username);
      await prefs.setString('${userId}_phone', phone);

      if (imageBase64 != null) {
        await prefs.setString('${userId}_imageBase64', imageBase64);
      }
    } else {
      throw Exception("User not authenticated");
    }
  }

  Future<String> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }
}
