import 'package:Sai_chat_app/home_page.dart';
import 'package:Sai_chat_app/sevices/database.dart';
import 'package:Sai_chat_app/sevices/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      // Google Sign-In Popup
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Firebase login
      UserCredential result = await firebaseAuth.signInWithCredential(
        credential,
      );
      User? user = result.user;
      print("CURRENT USER UID = ${user!.uid}");

      if (user == null) return;

      // Username (remove @gmail.com)
      String username = user.email!.split("@").first.toUpperCase();

      // Search key
      String searchKey = username.substring(0, 1);

      // Save local data
      await addSharedPreferences().saveUserName(user.displayName ?? "Guest");
      await addSharedPreferences().saveUserEmail(user.email ?? "");
      await addSharedPreferences().saveUserId(user.uid);
      await addSharedPreferences().saveUserImage(user.photoURL ?? "");
      await addSharedPreferences().saveUserUserNmae(username);

      // Firestore user data
      Map<String, dynamic> userInfoMap = {
        "id": user.uid,
        "Name": user.displayName ?? "Guest",
        "Email": user.email,
        "image": user.photoURL ?? "",
        "username": username,
        "searchKey": searchKey,
      };

      // 🔥 Check if user already exists in Firestore
      final DocumentSnapshot existingUser = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!existingUser.exists) {
        // 🔥 Create user only first time
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set(userInfoMap);
      }

      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Welcome ${user.displayName ?? username}!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );

      // Go to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print("Error sairam: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Error: $e")),
      );
    }
  }

  Future signOut() async {
    await auth.signOut();
  }

  Future deleteAccount() async {
    User? user = auth.currentUser;
    user?.delete();
  }

  Future<void> deleteAccount1() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No user found");
      }

      // Re-authenticate based on provider
      for (final provider in user.providerData) {
        if (provider.providerId == 'password') {
          // Email/Password users MUST re-login → show dialog or ask password
          throw FirebaseAuthException(
            code: "requires-recent-login",
            message: "Please re-login before deleting account.",
          );
        }

        if (provider.providerId == 'google.com') {
          // 🔥 Re-authenticate Google user
          final googleUser = await GoogleSignIn().signIn();
          final googleAuth = await googleUser!.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await user.reauthenticateWithCredential(credential);
        }
      }

      // 🔥 Delete account safely
      await user.delete();
    } catch (e) {
      print("Delete Error: $e");
      rethrow; // send back to UI
    }
  }
}
