import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../models/event.dart';

class EventService {
  static Box<Event> get box =>
      HiveService.getEventsBox();

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
        .collection('events');
  }

  static List<Event> getAllEvents() {
    final events =
        box.values.toList();

    events.sort(
      (a, b) =>
          a.date.compareTo(
            b.date,
          ),
    );

    return events;
  }

  static Event? getEvent(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> addEvent(
    Event event,
  ) async {
    // Sauvegarde locale immédiate
    await box.put(
      event.id,
      event,
    );

    // Synchronisation cloud en arrière-plan
    if (_collection != null) {
      _collection!
          .doc(event.id)
          .set(event.toMap())
          .catchError((e) {
        print(
          'Erreur sync ajout événement : $e',
        );
      });
    }
  }

  static Future<void> updateEvent(
    Event event,
  ) async {
    // Mise à jour locale immédiate
    await box.put(
      event.id,
      event,
    );

    // Synchronisation cloud
    if (_collection != null) {
      _collection!
          .doc(event.id)
          .set(event.toMap())
          .catchError((e) {
        print(
          'Erreur sync modification événement : $e',
        );
      });
    }
  }

  static Future<void> deleteEvent(
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
          'Erreur suppression cloud : $e',
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
        final event =
            Event.fromMap(
          doc.data()
              as Map<String, dynamic>,
        );

        await box.put(
          event.id,
          event,
        );
      }
    } catch (e) {
      print(
        'Erreur synchronisation Firestore : $e',
      );
    }
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}