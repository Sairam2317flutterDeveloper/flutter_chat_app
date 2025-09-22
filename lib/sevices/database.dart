import 'package:cloud_firestore/cloud_firestore.dart';

class databaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future addUser(Map<String, dynamic> UserInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(UserInfo);
  }

  Future<DocumentSnapshot?> getUserById(String userId) async {
    try {
      return await _firestore.collection("users").doc(userId).get();
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
}
