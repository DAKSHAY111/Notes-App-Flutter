import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes_app/models/myNoteModel.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/services/db.dart';
import 'package:uuid/uuid.dart';
import '../utils/colors.dart';
import '../widgets/colorPicker.dart';

class CreateNoteView extends StatefulWidget {
  // const CreateNoteView({super.key});

  @override
  State<CreateNoteView> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  late bool pin;
  var uuid = Uuid();
  Color color = Color(int.parse(black.value.toString()));

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title.dispose();
    content.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pin = false;
    print(color.toString().runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: const Text("Add Note"),
          actions: [
            IconButton(
              onPressed: () {
                pickColor(context);
              },
              icon: const Icon(Icons.color_lens),
              splashRadius: 18,
            ),
            IconButton(
                icon: Icon(pin ? Icons.push_pin : Icons.push_pin_outlined),
                splashRadius: 18,
                onPressed: () {
                  setState(() {
                    pin = !pin;
                  });
                }),
            IconButton(
              onPressed: () async {
                if (content.text.isEmpty || title.text.isEmpty) {
                  const snackbar = SnackBar(
                    content: Text("Please Provide title and Note"),
                    backgroundColor: Colors.red,
                    shape: StadiumBorder(),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                } else {
                  await NotesDatabse.instance.InsertEntry(Note(1,
                      pin: pin,
                      isArchive: false,
                      title: title.text.trim(),
                      uniqueId: uuid.v1(),
                      content: content.text.trim(),
                      color: color.value.toString(),
                      createdTime: DateTime.now()));
                  if (!mounted) return;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: ((context) => const Home())));
                }
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
              TextField(
                controller: title,
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
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
                        fontWeight: FontWeight.bold)),
                cursorColor: white,
              ),
              SizedBox(
                  height: 200,
                  child: TextField(
                      controller: content,
                      keyboardType: TextInputType.multiline,
                      minLines: 50,
                      maxLines: null,
                      cursorColor: white,
                      style: const TextStyle(fontSize: 17, color: Colors.white),
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
                              fontWeight: FontWeight.bold)))),
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
            title: const Text(
              "Pick Color",
              style: TextStyle(color: white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildColorPicker(),
                  TextButton(
                    child: const Text(
                      "Select",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          )));
}
