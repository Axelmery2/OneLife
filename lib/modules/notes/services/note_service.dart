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

  static Note? getNote(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> addNote(
    Note note,
  ) async {
    // Sauvegarde locale immédiate
    await box.put(
      note.id,
      note,
    );

    // Synchronisation cloud
    if (_collection != null) {
      _collection!
          .doc(note.id)
          .set(note.toMap())
          .catchError((e) {
        print(
          'Erreur sync ajout note : $e',
        );
      });
    }
  }

  static Future<void> updateNote(
    Note note,
  ) async {
    // Mise à jour locale immédiate
    await box.put(
      note.id,
      note,
    );

    // Synchronisation cloud
    if (_collection != null) {
      _collection!
          .doc(note.id)
          .set(note.toMap())
          .catchError((e) {
        print(
          'Erreur sync modification note : $e',
        );
      });
    }
  }

  static Future<void> deleteNote(
    String id,
  ) async {
    // Suppression locale immédiate
    await box.delete(id);

    // Suppression cloud
    if (_collection != null) {
      _collection!
          .doc(id)
          .delete()
          .catchError((e) {
        print(
          'Erreur suppression note : $e',
        );
      });
    }
  }

  static Future<void>
      syncFromFirestore() async {
    if (_collection == null) {
      return;
    }

    try {
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
    } catch (e) {
      print(
        'Erreur synchronisation notes : $e',
      );
    }
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}