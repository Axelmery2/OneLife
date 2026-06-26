import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../models/event.dart';

class EventService {
  static Box<Event> get box =>
      HiveService.getEventsBox();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static String get _uid =>
      FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference get _collection =>
      _firestore
          .collection('users')
          .doc(_uid)
          .collection('events');

  static List<Event> getAllEvents() {
    final events = box.values.toList();

    events.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    return events;
  }

  static Future<void> addEvent(
    Event event,
  ) async {
    await box.put(
      event.id,
      event,
    );

    await _collection
        .doc(event.id)
        .set(
          event.toMap(),
        );
  }

  static Future<void> updateEvent(
    Event event,
  ) async {
    await box.put(
      event.id,
      event,
    );

    await _collection
        .doc(event.id)
        .set(
          event.toMap(),
        );
  }

  static Future<void> deleteEvent(
    String id,
  ) async {
    await box.delete(id);

    await _collection
        .doc(id)
        .delete();
  }

  static Event? getEvent(
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

    for (final doc in snapshot.docs) {
      final event = Event.fromMap(
        doc.data()
            as Map<String, dynamic>,
      );

      await box.put(
        event.id,
        event,
      );
    }
  }
}