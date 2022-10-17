import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/myNoteModel.dart';
import '../pages/noteview.dart';
import '../utils/colors.dart';

class MasoGridView extends StatefulWidget {
  final List<Note> notesList;

  MasoGridView({super.key, required this.notesList});

  @override
  State<MasoGridView> createState() => _MasoGridViewState();
}

class _MasoGridViewState extends State<MasoGridView> {
  @override
  Widget build(BuildContext context) {
    List<Note> notesList = widget.notesList;

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
}
