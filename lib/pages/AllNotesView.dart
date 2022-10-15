import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/myNoteModel.dart';
import '../services/db.dart';
import '../services/login_info.dart';
import '../utils/colors.dart';
import 'noteview.dart';

class AllNoteView extends StatefulWidget {
  const AllNoteView({super.key});

  @override
  State<AllNoteView> createState() => _AllNoteViewState();
}

class _AllNoteViewState extends State<AllNoteView> {
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
    getAllPinNotes();
  }

  Future getAllNotes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLogin = preferences.getBool("isLogin")!;
    notesList = await NotesDatabse.instance.readAllNotes();
    // print(notesList);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future getAllPinNotes() async {
    pinnotes = await NotesDatabse.instance.readAllPinNotes();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget gridViewnotes(List<Note>? notesList) {
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
                    color: Color(int.parse(notesList[index].color))
                        .withOpacity(0.7),
                    border: Border.all(color: white.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteView(
                          note: notesList[index],
                        ),
                      ),
                    )
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        transitionOnUserGestures: true,
                        tag: notesList[index],
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(notesList[index].title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        notesList[index].content.length > 200
                            ? "${notesList[index].content.substring(0, 200)}..."
                            : notesList[index].content,
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
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        child: (!isLoading)
            ? SingleChildScrollView(
                child: (isGrid)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            (pinnotes!.isNotEmpty)
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Pinned",
                                      style: TextStyle(
                                          color: white.withOpacity(0.5),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                            gridViewnotes(pinnotes),
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
                            gridViewnotes(notesList),
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
                      ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueGrey,
                ),
              ),
      ),
    );
  }
}
