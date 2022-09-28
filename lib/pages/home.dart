import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/pages/createnoteview.dart';
import 'package:notes_app/pages/noteview.dart';
import 'package:notes_app/services/auth.dart';
import 'package:notes_app/services/db.dart';
import 'package:notes_app/services/firestore_db.dart';
import 'package:notes_app/widgets/MyDrawer.dart';
import 'package:notes_app/services/login_info.dart';
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
                                )))
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notesList![index].title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
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
    return SafeArea(
      child: Scaffold(
        drawer: const MyDrawer(),
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          backgroundColor: black,
          title: const Text("EASY NOTES"),
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
                  signOut();
                  LocalDataSaver.saveLoginData(false);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const ArchiveNoteView())));
                  },
                  icon: const Icon(
                    Icons.archive_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  tooltip: "Pinned Notes",
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.push_pin_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  tooltip: "Daily Schedule",
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.access_alarm,
                    color: Colors.white,
                  )),
              IconButton(
                  tooltip: "Grid View",
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.grid_view_rounded,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => CreateNoteView())));
          },
          backgroundColor: Colors.blue.shade300,
          // splashColor: Colors.gr,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
