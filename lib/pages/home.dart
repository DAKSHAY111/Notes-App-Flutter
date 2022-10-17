import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/pages/AllNotesView.dart';
import 'package:notes_app/pages/SearchPageView.dart';
import 'package:notes_app/pages/createnoteview.dart';
import 'package:notes_app/pages/noteview.dart';
import 'package:notes_app/pages/pinNoteView.dart';
import 'package:notes_app/services/auth.dart';
import 'package:notes_app/services/db.dart';
import 'package:notes_app/services/firestore_db.dart';
import 'package:notes_app/utils/routes.dart';
import 'package:notes_app/widgets/MyDrawer.dart';
import 'package:notes_app/services/login_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:notes_app/pages/archiveNoteView.dart';

import '../models/myNoteModel.dart';
import '../utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notesList = [];
  bool isLoading = true;
  late bool? isLogin = false;
  bool isGrid = true;
  String userImg =
      "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg";
  int currentIndex = 0;

  final screens = [
    const AllNoteView(),
    const ArchiveNoteView(),
    const PinNoteView(),
  ];

  @override
  void initState() {
    super.initState();
    getUserProfileImage();
    getAllNotes();
  }

  Future<void> getUserProfileImage() async {
    userImg = await LocalDataSaver.getImg();
    print(userImg);
  }

  Future getAllNotes() async {
    notesList = await NotesDatabse.instance.readAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        drawer: const MyDrawer(),
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          backgroundColor: black,
          title: Text(
            "EASY NOTES",
            style: _textTheme.headline6,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: MySearchDelegate(notesList));
                },
                icon: const Icon(Icons.search)),
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          backgroundColor: bgColor,
                          title: const Text(
                            "Are You sure to logout from this account ? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  signOut();
                                  await LocalDataSaver.saveLoginData(false);
                                  if (!mounted) return;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                ))
                          ],
                        );
                      }));
                },
                child: CircleAvatar(
                  onBackgroundImageError: (object, stackTrace) {
                    print("Ok + $StackTrace");
                  },
                  maxRadius: 18,
                  backgroundImage: NetworkImage(userImg.toString()),
                )),
          ],
        ),
        // body: IndexedStack(index: currentIndex, children: screens),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            unselectedItemColor: white,
            selectedItemColor: const Color((0xffcafc01)),
            currentIndex: currentIndex,
            onTap: (value) => setState(() => currentIndex = value),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archive Notes'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.push_pin_outlined), label: 'Pin Notes')
            ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.createNoteRoute);
          },
          backgroundColor: const Color((0xffcafc01)),
          label: const Text("Add Note"),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
