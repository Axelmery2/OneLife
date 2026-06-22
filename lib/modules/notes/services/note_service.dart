import 'package:hive/hive.dart';

import '../models/note.dart';
import '../../../services/hive_service.dart';

class NoteService {
  static Box<Note> get box =>
      Hive.box<Note>(
        HiveService.notesBox,
      );

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
  }

  static Future<void> updateNote(
    Note note,
  ) async {
    await box.put(
      note.id,
      note,
    );
  }

  static Future<void> deleteNote(
    String id,
  ) async {
    await box.delete(id);
  }

  static Note? getNote(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}