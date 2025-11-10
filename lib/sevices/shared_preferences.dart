import 'package:shared_preferences/shared_preferences.dart';

class addSharedPreferences {
  final String userIdKey = "USERIDKEY";
  final String userNameKey = "USERNAMEKEY";
  final String userEmsilKey = "USEREMAILKEY";
  final String userImageKey = "USERIMAGEKEY";
  final String userUserNameKey = "USERUSERNAMEKEY";

  Future<bool> saveUserId(String getUserId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // save the userId
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // save the userId
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmial) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // save the userId
    return prefs.setString(userEmsilKey, getUserEmial);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // save the userId
    return prefs.setString(userImageKey, getUserImage);
  }

  Future<bool> saveUserUserNmae(String getUserUserName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // save the userId
    return prefs.setString(userUserNameKey, getUserUserName);
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  Future<String?> getUserUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUserNameKey);
  }

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmsilKey);
  }
}
