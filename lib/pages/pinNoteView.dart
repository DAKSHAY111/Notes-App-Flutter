import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/widgets/MasonaryGridView.dart';
import 'package:uuid/uuid.dart';
import '../models/myNoteModel.dart';
import '../services/db.dart';
import '../utils/colors.dart';
import 'noteview.dart';

class PinNoteView extends StatefulWidget {
  const PinNoteView({super.key});

  @override
  State<PinNoteView> createState() => _PinNoteViewState();
}

class _PinNoteViewState extends State<PinNoteView> {
  bool isLoading = true;
  bool isGrid = true;
  String? googleProfileimg;
  List<Note>? notesList = [];
  var uuid = const Uuid();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPinNotes();
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
                    Text(notesList![index].title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20)),
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
              ),
            ) // ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                                  "Pin Notes",
                                  style: TextStyle(
                                      color: white.withOpacity(0.5),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              MasoGridView(
                                notesList: notesList!,
                              )
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
      ),
    );
  }
}
