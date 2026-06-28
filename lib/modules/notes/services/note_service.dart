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
          .currentUser
          ?.uid ??
      'guest';

  static CollectionReference?
      get _collection {
    if (FirebaseAuth
            .instance
            .currentUser ==
        null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('notes');
  }

  static List<Note> getAllNotes() {
    return box.values.toList();
  }

  static Future<void> addNote(
    Note note,
  ) async {
    // Sauvegarde locale
    await box.put(
      note.id,
      note,
    );

    // Sauvegarde cloud si connecté
    if (_collection != null) {
      await _collection!
          .doc(note.id)
          .set(
            note.toMap(),
          );
    }
  }

  static Future<void> updateNote(
    Note note,
  ) async {
    // Mise à jour locale
    await box.put(
      note.id,
      note,
    );

    // Mise à jour cloud
    if (_collection != null) {
      await _collection!
          .doc(note.id)
          .set(
            note.toMap(),
          );
    }
  }

  static Future<void> deleteNote(
    String id,
  ) async {
    // Suppression locale
    await box.delete(id);

    // Suppression cloud
    if (_collection != null) {
      await _collection!
          .doc(id)
          .delete();
    }
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
    if (_collection == null) {
      return;
    }

    final snapshot =
        await _collection!.get();

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