import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/pages/noteview.dart';
import 'package:notes_app/services/db.dart';

import '../models/myNoteModel.dart';
import '../utils/colors.dart';

class EditNoteView extends StatefulWidget {
  Note note;
  EditNoteView({required this.note});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late String newnoteTitle = '';
  late String newNoteDetail = '';
  late bool pin;

  Color color = Color(int.parse(black.value.toString()));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newnoteTitle = widget.note.title;
    newNoteDetail = widget.note.content;
    pin = widget.note.pin ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color.withOpacity(0.7),
        appBar: AppBar(
          backgroundColor: bgColor,
          title: const Text("Edit Note"),
          actions: [
            IconButton(
              onPressed: () {
                pickColor(context);
              },
              icon: const Icon(Icons.color_lens),
              splashRadius: 18,
            ),
            IconButton(
              onPressed: () async {
                await NotesDatabse.instance.updateNote(Note(widget.note.id,
                    pin: widget.note.pin,
                    isArchive: widget.note.isArchive,
                    uniqueId: widget.note.uniqueId,
                    title: newnoteTitle,
                    content: newNoteDetail,
                    color: color.value.toString(),
                    createdTime: widget.note.createdTime));

                if (!mounted) return;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(Icons.check),
              splashRadius: 18,
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Form(
                child: TextFormField(
                  initialValue: newnoteTitle,
                  onChanged: (value) {
                    setState(() {
                      newnoteTitle = value;
                    });
                  },
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 25,
                      )),
                  cursorColor: white,
                ),
              ),
              SizedBox(
                  height: 200,
                  child: Form(
                    child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            newNoteDetail = value;
                          });
                        },
                        initialValue: newNoteDetail,
                        keyboardType: TextInputType.multiline,
                        minLines: 50,
                        maxLines: null,
                        cursorColor: white,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Your Note",
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 17,
                                fontWeight: FontWeight.bold))),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorPicker() => BlockPicker(
      pickerColor: color,
      availableColors: const [
        Colors.red,
        Colors.pink,
        Colors.purple,
        Colors.deepPurple,
        Colors.indigo,
        Colors.blue,
        Colors.teal,
        Colors.amber,
        Colors.orange,
        Colors.deepOrange,
        Colors.brown,
        Colors.black,
      ],
      onColorChanged: (color) {
        print(color.value.toString());
        setState(() {
          this.color = Color(color.value);
        });
      });

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            backgroundColor: bgColor,
            title: const Text("Pick Color"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildColorPicker(),
                  TextButton(
                    child: const Text(
                      "Select",
                      style: TextStyle(fontSize: 20, color: white),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          )));
}
