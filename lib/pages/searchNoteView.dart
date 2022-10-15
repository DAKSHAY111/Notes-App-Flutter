// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import '../models/myNoteModel.dart';
// import '../services/db.dart';
// import '../utils/colors.dart';
// import 'NoteView.dart';

// class SearchView extends StatefulWidget {
//   const SearchView({Key? key}) : super(key: key);

//   @override
//   _SearchViewState createState() => _SearchViewState();
// }

// class _SearchViewState extends State<SearchView> {
//   List<int> SearchResultIDs = [];
//   List<Note?> SearchResultNotes = [];

//   bool isLoading = false;

//   void SearchResults(String query) async {
//     SearchResultNotes.clear();
//     setState(() {
//       isLoading = true;
//     });
//     final ResultIds =
//         await NotesDatabse.instance.getNoteString(query); //= [1,2,3,4,5]
//     List<Note?> SearchResultNotesLocal = []; //[nOTE1, nOTE2]
//     ResultIds.forEach((element) async {
//       final SearchNote = await NotesDatabse.instance.readOneNote(element);
//       SearchResultNotesLocal.add(SearchNote);
//       setState(() {
//         SearchResultNotes.add(SearchNote);
//       });
//     });

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: bgColor,
//         body: SingleChildScrollView(
//           child: SafeArea(
//               child: Container(
//             decoration: BoxDecoration(color: white.withOpacity(0.1)),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.arrow_back_outlined),
//                       color: white,
//                     ),
//                     Expanded(
//                       child: TextField(
//                         textInputAction: TextInputAction.search,
//                         style: TextStyle(color: Colors.white),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           disabledBorder: InputBorder.none,
//                           hintText: "Search Your Notes",
//                           hintStyle: TextStyle(
//                               color: white.withOpacity(0.5), fontSize: 16),
//                         ),
//                         onSubmitted: (value) {
//                           setState(() {
//                             SearchResults(value.toLowerCase());
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 isLoading
//                     ? Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                         ),
//                       )
//                     : NoteSectionAll()
//               ],
//             ),
//           )),
//         ));
//   }

//   Widget NoteSectionAll() {
//     return Container(
//         child: Column(
//       children: [
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 "SEARCH RESULTS",
//                 style: TextStyle(
//                     color: white.withOpacity(0.5),
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 15,
//             ),
//             child: MasonryGridView.count(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: SearchResultNotes.length,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 crossAxisCount: 2,
//                 itemBuilder: (context, index) => InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     NoteView(note: SearchResultNotes[index])));
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: white.withOpacity(0.4)),
//                             borderRadius: BorderRadius.circular(7)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(SearchResultNotes[index]!.title,
//                                 style: TextStyle(
//                                     color: white,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold)),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               SearchResultNotes[index]!.content.length > 250
//                                   ? "${SearchResultNotes[index]!.content.substring(0, 250)}..."
//                                   : SearchResultNotes[index]!.content,
//                               style: TextStyle(color: white),
//                             )
//                           ],
//                         ),
//                       ),
//                     ))),
//       ],
//     ));
//   }
// }
