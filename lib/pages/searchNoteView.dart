import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchNoteView extends StatefulWidget {
  const SearchNoteView({super.key});

  @override
  State<SearchNoteView> createState() => _SearchNoteViewState();
}

class _SearchNoteViewState extends State<SearchNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("SearchView"),
    );
  }
}
