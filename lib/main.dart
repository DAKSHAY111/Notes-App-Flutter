import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/pages/archiveNoteView.dart';
import 'package:notes_app/pages/createnoteview.dart';
import 'package:notes_app/pages/editpage.dart';
import 'package:notes_app/pages/noteview.dart';
import 'package:notes_app/services/login_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/utils/MyThemes.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home.dart';

Future<void> main() async {
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
  bool isLogIn = false;

  getLoggedInState() async {
    await LocalDataSaver.getLogData().then((value) {
      print("Is User Logged in : $value");
      setState(() {
        isLogIn = value!;
        print("is User Logged in : $isLogIn");
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoggedInState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        routes: {'/acrhiveNote': ((context) => const ArchiveNoteView())},
        theme: ThemeData(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.blue,
        ),
        home: isLogIn ? const Home() : Login());
  }
}
