import 'package:flutter/material.dart';
import 'package:notes_app/widgets/MasonaryGridView.dart';
import 'package:uuid/uuid.dart';

import '../models/myNoteModel.dart';
import '../services/db.dart';
import '../services/login_info.dart';
import '../utils/colors.dart';

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
    notesList = await NotesDatabse.instance.readAllNotes();
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
                            MasoGridView(
                              notesList: pinnotes!,
                            ),
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
                            MasoGridView(notesList: notesList!),
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
