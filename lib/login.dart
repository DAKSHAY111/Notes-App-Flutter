import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/services/firestore_db.dart';
import 'package:notes_app/services/login_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login To App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(Buttons.Google, onPressed: () async {
              await signInWithGoogle();
              final User? currentUser = _auth.currentUser;
              // print(await LocalDataSaver.saveLoginData(true));
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setBool("isLogin", true);
              await LocalDataSaver.saveImg(currentUser!.photoURL.toString());
              await LocalDataSaver.saveMail(currentUser.email.toString());
              await LocalDataSaver.saveName(currentUser.displayName.toString());
              await LocalDataSaver.setSync(true);
              if (!mounted) return;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => const Home())));
            })
          ],
        ),
      ),
    );
  }
}
