import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSaver {
  static String nameKey = "NAMEKEY";
  static String emailKey = "EMAILKEY";
  static String imgKey = "IMGKEY";
  static String logKey = "LOGWALIKEY";
  static String syncKey = "SYNCKEY";

  static Future<bool> saveName(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nameKey, username);
  }

  static Future<bool> saveMail(String useremail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(emailKey, useremail);
  }

  static Future<bool> saveImg(String imgUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(imgKey, imgUrl);
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(nameKey);
  }

  static Future<String?> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(emailKey);
  }

  static Future<String?> getImg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(imgKey);
  }

  static Future<bool> saveLoginData(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("User is logged in : $isUserLoggedIn");
    return await preferences.setBool(logKey, isUserLoggedIn);
  }

  static Future<bool> setSync(bool isSyncOn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(syncKey, isSyncOn);
  }

  static Future<bool?> getLogData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(logKey);
  }

  static Future<bool?> getSyncSet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(syncKey);
  }
}
