import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/pages/AllNotesView.dart';
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
    // await LocalDataSaver.getLogData().then((value) {
    //   print("Is User Logged in : $value");
    //   setState(() {
    //     isLogIn = value!;
    //     print("is User Logged in : $isLogIn");
    //   });
    // });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLogIn = preferences.getBool("isLogin")!;
    print("User is logged in : $isLogIn");
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
      initialRoute: (isLogIn) ? MyRoutes.allNoteRoute : MyRoutes.loginRoute,
      routes: {
        MyRoutes.homeRoute: ((context) => const Home()),
        MyRoutes.allNoteRoute: ((context) => const AllNoteView()),
        MyRoutes.acrhiveNoteRoute: ((context) => const ArchiveNoteView()),
        MyRoutes.pinNoteRoute: ((context) => const PinNoteView()),
        MyRoutes.createNoteRoute: ((context) => CreateNoteView()),
        MyRoutes.loginRoute: ((context) => Login())
      },
      theme: lightTheme,
      darkTheme: darkTheme,
      // home: isLogIn! ? const Home() : Login(),
    );
  }
}
