import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/services/firestore_db.dart';
import 'package:notes_app/services/login_info.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? username, userEmail, userImg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalDataSaver.getName().then((value) {
      if (mounted) {
        print("loaded + $value");
        setState(() {
          username = value;
        });
      }
    });
    LocalDataSaver.getEmail().then((value) {
      if (mounted) {
        print("loaded + $value");
        setState(() {
          userEmail = value;
        });
      }
    });
    LocalDataSaver.getImg().then((value) {
      if (mounted) {
        print("loaded + $value");
        setState(() {
          userImg = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        children: [
          DrawerHeader(
              curve: Curves.bounceOut,
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                accountName: Text(username ?? "User Name"),
                accountEmail: Text(userEmail ?? "User Email"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userImg ??
                      "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
                ),
              )),
          ListTile(
            leading: Icon(
              Icons.lightbulb_outline_rounded,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "Notes",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.archive_outlined,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "Achieve",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "Settings",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
          ListTile(
            onTap: () async {
              await FireDB().getAllStoredNotes();
              if (!mounted) return;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => const Home())));
            },
            leading: Icon(
              Icons.backup_outlined,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "Backup Notes",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "About Us",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
