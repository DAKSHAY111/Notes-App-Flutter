import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class LocalDataSaver {
  static String BoxName = "LoginInfo";
  static String nameKey = "UserName";
  static String emailKey = "UserGmail";
  static String imgKey = "UserImg";
  static String logKey = "isLogin";
  static String syncKey = "isSyncOn";

//* -------------- To know user is logged in or not locally  ---------------*//

  static Future<void> saveLoginData(bool isUserLoggedIn) async {
    Box box = await Hive.openBox(BoxName);
    print(
        "----------------------- User Saved : $isUserLoggedIn ---------------");
    box.put(logKey, isUserLoggedIn);
  }

  static Future<bool> getLogData() async {
    Box box = await Hive.openBox(BoxName);
    bool isLogin = box.get(logKey) != null && box.get(logKey) != false;
    print(isLogin);
    return isLogin;
  }

//* Store UserName Locally*//

  static Future<void> saveName(String username) async {
    Box box = await Hive.openBox(BoxName);
    box.put(nameKey, username);
  }

  static Future<String?> getName() async {
    Box box = await Hive.openBox(BoxName);
    return box.get(nameKey);
  }

//* Store UserGmail Locally*//

  static Future<void> saveMail(String useremail) async {
    Box box = await Hive.openBox(BoxName);
    box.put(emailKey, useremail);
  }

  static Future<String?> getEmail() async {
    Box box = await Hive.openBox(BoxName);
    return box.get(emailKey);
  }

//* ---------- Store UserGmail Locally ---------------- *//

  static Future<void> saveImg(String imgUrl) async {
    Box box = await Hive.openBox(BoxName);
    box.put(imgKey, imgUrl);
  }

  static Future<String> getImg() async {
    Box box = await Hive.openBox(BoxName);
    return box.get(imgKey).toString();
  }

//* ------------------- Sync -------------------------- *//

  static Future<void> setSync(bool isSyncOn) async {
    Box box = await Hive.openBox(BoxName);
    box.put(syncKey, isSyncOn);
  }

  static Future<bool?> getSyncSet() async {
    Box box = await Hive.openBox(BoxName);
    return box.get(syncKey);
  }
}
