import 'package:Sai_chat_app/home_page.dart';
import 'package:Sai_chat_app/sevices/database.dart';
import 'package:Sai_chat_app/sevices/shared_preferences.dart';
// import 'package:chat_app/home_page.dart';
// import 'package:chat_app/sevices/database.dart';
// import 'package:chat_app/sevices/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<User?>? getcurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential results = await firebaseAuth.signInWithCredential(
        credential,
      );
      User? userDetails = results.user;

      if (userDetails != null) {
        String username = userDetails.email!.replaceAll("@gmail.com", "");
        String firstLetter = username.substring(0, 1).toUpperCase();

        // Save in SharedPreferences
        await addSharedPreferences().saveUserName(
          userDetails.displayName ?? "Guest",
        );
        await addSharedPreferences().saveUserEmail(userDetails.email ?? "");
        await addSharedPreferences().saveUserId(userDetails.uid);
        await addSharedPreferences().saveUserImage(userDetails.photoURL ?? "");
        await addSharedPreferences().saveUserUserNmae(username);

        Map<String, dynamic> userInfoMap = {
          "Name": userDetails.displayName ?? "Guest",
          "Email": userDetails.email,
          "image": userDetails.photoURL ?? "",
          "id": userDetails.uid,
          "username": username.toUpperCase(),
          "searchKey": firstLetter,
        };

        // ✅ Check if user already exists in Firestore
        final db = databaseMethods();
        final existingUser = await db.getUserById(userDetails.uid);

        if (existingUser == null || !existingUser.exists) {
          await db.addUser(userInfoMap, userDetails.uid);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Welcome ${userDetails.displayName ?? username}!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Error: $e")),
      );
    }
  }
}
