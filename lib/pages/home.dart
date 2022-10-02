import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/pages/createnoteview.dart';
import 'package:notes_app/pages/noteview.dart';
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
  bool isLoading = true;
  bool isLogin = false;
  bool isGrid = true;
  String? userImg;

  List<Note>? notesList = [];
  List<Note>? pinnotes = [];
  var uuid = const Uuid();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LocalDataSaver.getImg().then((value) {
      if (mounted) {
        setState(() {
          userImg = value;
        });
      }
    });
    getAllNotes();
    // getAllPinNotes();
  }

  Future MyQuery(int id) async {
    await NotesDatabse.instance.executeMyQuery(id);
  }

  Future createEntry(Note note) async {
    await NotesDatabse.instance.InsertEntry(note);
  }

  Future getAllNotes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getBool("isLogin");
    notesList = await NotesDatabse.instance.readAllNotes();
    // print(notesList);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future getAllPinNotes() async {
    notesList = await NotesDatabse.instance.readAllPinNotes();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget gridViewnotes() {
    return MasonryGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      mainAxisSpacing: 6,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      itemCount: notesList!.length,
      itemBuilder: (context, index) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(int.parse(notesList![index].color)),
                    border: Border.all(color: white.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteView(
                          note: notesList![index],
                        ),
                      ),
                    )
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        transitionOnUserGestures: true,
                        tag: notesList![index],
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(notesList![index].title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        notesList![index].content.length > 200
                            ? "${notesList![index].content.substring(0, 200)}..."
                            : notesList![index].content,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )) // ),
            );
      },
    );
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
            "EASY NOTES $isLogin",
            style: _textTheme.headline6,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    isGrid = !isGrid;
                  });
                },
                child: const Icon(
                  Icons.grid_view_outlined,
                  color: white,
                )),
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          backgroundColor: bgColor,
                          title: const Text(
                            "Are You sure to logout from this account?",
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
                  // signOut();
                  // LocalDataSaver.saveLoginData(false);
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => Login()));
                },
                child: CircleAvatar(
                    onBackgroundImageError: (Object, StackTrace) {
                      print("Ok + $StackTrace");
                    },
                    maxRadius: 20,
                    backgroundImage: NetworkImage(userImg.toString()))),
          ],
        ),
        body: Container(
          child: (!isLoading)
              ? SingleChildScrollView(
                  child: (isGrid)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "ALL",
                                  style: TextStyle(
                                      color: white.withOpacity(0.5),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              gridViewnotes(),
                            ])
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "List View",
                                style: TextStyle(
                                    color: white.withOpacity(0.5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListView.builder(
                                itemCount: notesList!.length,
                                itemBuilder: ((context, index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [Text(notesList![index].title)],
                                    ),
                                  );
                                }))
                          ],
                        ))
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.black54,
          elevation: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  tooltip: "View Archived Notes",
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.acrhiveNoteRoute);
                  },
                  icon: const Icon(
                    Icons.archive_outlined,
                  )),
              IconButton(
                  tooltip: "Pinned Notes",
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.push_pin_outlined,
                  )),
              IconButton(
                  tooltip: "Daily Schedule",
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.access_alarm,
                  )),
              IconButton(
                  tooltip: "Grid View",
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.grid_view_rounded,
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.createNoteRoute);
          },
          backgroundColor: const Color((0xffcafc01)),
          label: const Text("Add Note"),
          icon: const Icon(Icons.add),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
