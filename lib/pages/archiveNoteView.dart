import 'package:flutter/material.dart';
import 'package:notes_app/services/db.dart';
import 'package:notes_app/widgets/MasonaryGridView.dart';
import 'package:notes_app/services/login_info.dart';
import 'package:uuid/uuid.dart';

import '../models/myNoteModel.dart';
import '../utils/colors.dart';

class ArchiveNoteView extends StatefulWidget {
  const ArchiveNoteView({super.key});

  @override
  State<ArchiveNoteView> createState() => _ArchiveNoteViewState();
}

class _ArchiveNoteViewState extends State<ArchiveNoteView> {
  bool isLoading = true;
  bool isGrid = true;

  List<Note>? notesList = [];
  var uuid = const Uuid();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllArchiveNotes();
  }

  Future getAllArchiveNotes() async {
    notesList = await NotesDatabse.instance.readAllArchiveNotes();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: (!isLoading)
              ? SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Archive Notes ",
                          style: TextStyle(
                              color: white.withOpacity(0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      MasoGridView(
                        notesList: notesList!,
                      )
                    ]))
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
        ),
      ),
    );
  }
}
