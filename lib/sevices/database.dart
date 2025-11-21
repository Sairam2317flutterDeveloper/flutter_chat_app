import 'package:Sai_chat_app/sevices/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future addMessage(
    String chatRoomId,
    String messageId,
    Map<String, dynamic> messageInfo,
  ) async {
    return await _firestore
        .collection("Chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfo);
  }

  Future<void> lastMessage(
    String chatRoomId,
    Map<String, dynamic> lastMessageInfo,
  ) async {
    final chatRoomRef = _firestore.collection("Chatrooms").doc(chatRoomId);

    try {
      await chatRoomRef.update(lastMessageInfo);
    } catch (e) {
      // If doc doesn't exist → create it
      if (e.toString().contains("not-found")) {
        await chatRoomRef.set(lastMessageInfo, SetOptions(merge: true));
      } else {
        print("Error updating last message: $e");
      }
    }
  }

  Future<QuerySnapshot> search(String userName) {
    return _firestore
        .collection("users")
        .where("searchKey", isEqualTo: userName.substring(0, 1).toUpperCase())
        .get();
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatInfoMap) async {
    final snapshot = await _firestore
        .collection("Chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("Chatrooms")
          .doc(chatRoomId)
          .set(chatInfoMap);
    }
  }

  Stream<QuerySnapshot> getChatroommMessages(chatRoomId) {
    return _firestore
        .collection("Chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String userName) async {
    return await _firestore
        .collection("users")
        .where("username", isEqualTo: userName)
        .get();
  }

  Future<Stream<QuerySnapshot>> getChatrooms() async {
    String? myuser = await addSharedPreferences().getUserUserName();
    return await _firestore
        .collection("Chatrooms")
        .orderBy("lastMessagets", descending: true)
        .where("users", arrayContains: myuser)
        .snapshots();
  }
}
