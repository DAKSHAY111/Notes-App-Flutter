import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'db.dart';
import 'package:notes_app/models/myNoteModel.dart';

class FireDB {
  //* Create Firebaseauth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //* Adding Note in Firebase

  createNewNoteFirestore(Note note) async {
    final User? currentUser = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(currentUser?.email)
        .collection("usernotes")
        .doc(note.uniqueId)
        .set({
      "Title": note.title,
      "Content": note.content,
      "uniqueId": note.uniqueId,
      "Date": note.createdTime,
      "color": note.color,
    }).then((_) {
      print("DATA ADDED SUCCESSFULLY");
    });
  }

  //* Read All Notes from Firebase

  getAllStoredNotes() async {
    final User? currentUser = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(currentUser!.email)
        .collection("usernotes")
        .orderBy("Date")
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        Map note = result.data();
        print(note);
        NotesDatabse.instance.InsertEntry(Note(
          0,
          title: note["Title"],
          uniqueId: note["uniqueId"],
          content: note["Content"],
          createdTime: ((note["Date"]) as Timestamp).toDate(),
          color: note["color"],
          pin: false,
          isArchive: false,
        )); //Add Notes In Database
      }
    });
  }

  //* Update Note in Firebase

  updateNoteFirestore(Note note) async {
    final User? currentUser = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(currentUser!.email)
        .collection("usernotes")
        .doc(note.uniqueId.toString())
        .update({"Title": note.title.toString(), "Content": note.content}).then(
            (_) {
      print("DATA ADDED SUCCESFULLY");
    });
  }

  //* Delete Note from Firebase

  deleteNoteFirestore(Note note) async {
    final User? currentUser = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(currentUser!.email.toString())
        .collection("usernotes")
        .doc(note.uniqueId.toString())
        .delete()
        .then((_) {
      print("DATA DELETED SUCCESSFULLY");
    });
  }
}
