// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/widgets/MasonaryGridView.dart';
import '../models/myNoteModel.dart';
import '../utils/colors.dart';
import 'noteview.dart';

class MySearchDelegate extends SearchDelegate {
  final List<Note> listNote;
  MySearchDelegate(this.listNote);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear))
    ];
    // TODO: implement buildActions
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(child: Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 100,
              color: white.withOpacity(0.5),
            ),
            const SizedBox(height: 10),
            Text(
              "Search Your Note",
              style: TextStyle(fontSize: 20, color: white.withOpacity(0.5)),
            )
          ],
        )),
      );
    }
    print("All Notes $listNote");

    final List<Note> suggestionList = listNote
        .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    print(suggestionList);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Search Result",
              style: TextStyle(
                  color: white.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
          MasoGridView(notesList: suggestionList)
          // MasonryGridView.count(
          //   physics: const NeverScrollableScrollPhysics(),
          //   crossAxisCount: 2,
          //   scrollDirection: Axis.vertical,
          //   mainAxisSpacing: 6,
          //   shrinkWrap: true,
          //   itemCount: suggestionList.length,
          //   itemBuilder: (context, index) {
          //     return ClipRRect(
          //         borderRadius: BorderRadius.circular(10),
          //         child: Container(
          //             margin:
          //                 const EdgeInsets.only(left: 8, right: 8, bottom: 5),
          //             padding: const EdgeInsets.all(10),
          //             decoration: BoxDecoration(
          //                 color: Color(int.parse(suggestionList[index].color))
          //                     .withOpacity(0.7),
          //                 border: Border.all(color: white.withOpacity(0.3)),
          //                 borderRadius: BorderRadius.circular(10)),
          //             child: InkWell(
          //               onTap: () => {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => NoteView(
          //                       note: suggestionList[index],
          //                     ),
          //                   ),
          //                 )
          //               },
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Hero(
          //                     transitionOnUserGestures: true,
          //                     tag: suggestionList[index],
          //                     child: Material(
          //                       type: MaterialType.transparency,
          //                       child: Text(suggestionList[index].title,
          //                           style: const TextStyle(
          //                               color: Colors.white, fontSize: 20)),
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 10,
          //                   ),
          //                   Text(
          //                     suggestionList[index].content.length > 200
          //                         ? "${suggestionList[index].content.substring(0, 200)}..."
          //                         : suggestionList[index].content,
          //                     style: const TextStyle(color: Colors.white),
          //                   )
          //                 ],
          //               ),
          //             )) // ),
          //         );
          //   },
          // ),
        ],
      ),
    );

    // TODO: implement buildSuggestions
  }
}
