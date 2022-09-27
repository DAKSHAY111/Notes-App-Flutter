import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ArchieveNoteView extends StatefulWidget {
  const ArchieveNoteView({super.key});

  @override
  State<ArchieveNoteView> createState() => _ArchieveNoteViewState();
}

class _ArchieveNoteViewState extends State<ArchieveNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Archive Note"),
    );
  }
}
