import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/pages/editpage.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/utils/colors.dart';
import '../models/myNoteModel.dart';
import '../services/db.dart';

class NoteView extends StatefulWidget {
  Note note;
  NoteView({required this.note});
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.note.color.runtimeType);
    print(widget.note.color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(widget.note.color)).withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Easy Notes"),
        actions: [
          IconButton(
              icon: Icon(
                  widget.note.pin ? Icons.push_pin : Icons.push_pin_outlined),
              splashRadius: 18,
              onPressed: () async {
                await NotesDatabse.instance.pinNote(Note(widget.note.id,
                    pin: (widget.note.pin) ? false : true,
                    isArchive: widget.note.isArchive,
                    title: widget.note.title,
                    uniqueId: widget.note.uniqueId,
                    content: widget.note.content,
                    color: widget.note.color,
                    createdTime: widget.note.createdTime));
                if (!mounted) return;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              }),
          IconButton(
              onPressed: () async {
                await NotesDatabse.instance.delteNote(widget.note);
                if (!mounted) return;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              splashRadius: 18,
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () async {
                await NotesDatabse.instance.archiveNote(Note(widget.note.id,
                    pin: widget.note.pin,
                    isArchive: (widget.note.isArchive) ? false : true,
                    title: widget.note.title,
                    uniqueId: widget.note.uniqueId,
                    content: widget.note.content,
                    color: widget.note.color,
                    createdTime: widget.note.createdTime));
                if (!mounted) return;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: Icon((widget.note.isArchive)
                  ? Icons.archive
                  : Icons.archive_outlined)),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => EditNoteView(note: widget.note))));
            },
            icon: const Icon(Icons.edit),
            splashRadius: 18,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            transitionOnUserGestures: true,
            tag: widget.note,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                widget.note.title,
                style: const TextStyle(fontSize: 25, color: white),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            DateFormat('hh:mm a | dd-MM-yyyy').format(widget.note.createdTime),
            style: const TextStyle(fontSize: 11, color: white),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.note.content,
            style: const TextStyle(fontSize: 15, color: white),
          ),
        ]),
      ),
    );
  }
}
