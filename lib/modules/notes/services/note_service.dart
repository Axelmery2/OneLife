import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../models/note.dart';

class NoteService {
  static Box<Note> get box =>
      HiveService.getNotesBox();

  static final FirebaseFirestore
      _firestore =
      FirebaseFirestore.instance;

  static String get _uid =>
      FirebaseAuth
          .instance
          .currentUser!
          .uid;

  static CollectionReference get
      _collection => _firestore
          .collection('users')
          .doc(_uid)
          .collection('notes');

  static List<Note> getAllNotes() {
    return box.values.toList();
  }

  static Future<void> addNote(
    Note note,
  ) async {
    await box.put(
      note.id,
      note,
    );

    await _collection
        .doc(note.id)
        .set(
          note.toMap(),
        );
  }

  static Future<void> updateNote(
    Note note,
  ) async {
    await box.put(
      note.id,
      note,
    );

    await _collection
        .doc(note.id)
        .set(
          note.toMap(),
        );
  }

  static Future<void> deleteNote(
    String id,
  ) async {
    await box.delete(id);

    await _collection
        .doc(id)
        .delete();
  }

  static Note? getNote(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> clearAll() async {
    await box.clear();
  }

  static Future<void>
      syncFromFirestore() async {
    final snapshot =
        await _collection.get();

    for (final doc
        in snapshot.docs) {
      final note =
          Note.fromMap(
        doc.data()
            as Map<String, dynamic>,
      );

      await box.put(
        note.id,
        note,
      );
    }
  }
}