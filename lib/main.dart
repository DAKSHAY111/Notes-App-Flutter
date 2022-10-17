import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/pages/AllNotesView.dart';
import 'package:notes_app/pages/SearchPageView.dart';
import 'package:notes_app/pages/archiveNoteView.dart';
import 'package:notes_app/pages/createnoteview.dart';
import 'package:notes_app/pages/editpage.dart';
import 'package:notes_app/pages/noteview.dart';
import 'package:notes_app/pages/pinNoteView.dart';
import 'package:notes_app/services/login_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/themes/theme_constants.dart';
import 'package:notes_app/utils/MyThemes.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late bool isLogIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getLoggedInState();
  }

  // bool isLogIn = false;

  // getLoggedInState() async {
  //   await LocalDataSaver.getLogData().then((value) {
  //     setState(() {
  //       isLogIn = value.toString() == "null";
  //       print("value : $value , isLogin : $isLogIn");
  //     });
  //   });
  // }
  // getLoggedInState() async {
  //   await LocalDataSaver.getLogData().then((value) {
  //     print("Is User Logged in : $value");
  //     setState(() {
  //       isLogIn = value!;
  //       print("is User Logged in : $isLogIn");
  //     });
  //   });
  //   print("User is logged in : $isLogIn");
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      routes: {
        MyRoutes.homeRoute: ((context) => const Home()),
        MyRoutes.allNoteRoute: ((context) => const AllNoteView()),
        MyRoutes.acrhiveNoteRoute: ((context) => const ArchiveNoteView()),
        MyRoutes.pinNoteRoute: ((context) => const PinNoteView()),
        MyRoutes.createNoteRoute: ((context) => CreateNoteView()),
        MyRoutes.loginRoute: ((context) => Login())
      },
      // initialRoute: (isLogIn) ? MyRoutes.loginRoute : MyRoutes.homeRoute,
      initialRoute: MyRoutes.loginRoute,
      theme: lightTheme,
      darkTheme: darkTheme,
      // home: isLogIn! ? const Home() : Login(),
    );
  }
}
