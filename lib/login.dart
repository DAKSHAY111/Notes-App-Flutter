import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/services/login_info.dart';
import 'services/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Box? Box1;
  late bool isLogin;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBox();
  }

  void createBox() async {
    Box1 = await Hive.openBox('Login');
    getData();
  }

  void getData() async {
    if (await LocalDataSaver.getLogData()) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => const Home())));
    }
  }

  // void checkLogin() async {
  //   var isLogin = await LocalDataSaver.getLogData();
  //   if (!mounted) return;
  //   if (isLogin!) {
  //     Navigator.popAndPushNamed(context, MyRoutes.homeRoute);
  //   }
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 6,
                      child: Image.asset(
                        "assets/images/Logo.png",
                      ),
                    ),
                    const SizedBox(height: 100),
                    const Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    const SizedBox(height: 100),
                    SignInButton(Buttons.Google, onPressed: () async {
                      await signInWithGoogle();
                      final User? currentUser = _auth.currentUser;

                      //* Save Locally that user is logged in
                      await LocalDataSaver.saveLoginData(true);

                      //* Save user's Details Locally
                      await LocalDataSaver.saveImg(
                          currentUser!.photoURL.toString());
                      await LocalDataSaver.saveMail(
                          currentUser.email.toString());
                      await LocalDataSaver.saveName(
                          currentUser.displayName.toString());
                      await LocalDataSaver.setSync(true);

                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const Home()),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
