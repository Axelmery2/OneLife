import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../models/creance.dart';

class CreanceService {
  static Box<Creance> get box =>
      HiveService.getReceivablesBox();

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
        .collection('creances');
  }

  static List<Creance>
      getAllCreances() {
    return box.values.toList();
  }

  static Creance? getCreance(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> addCreance(
    Creance creance,
  ) async {
    // Sauvegarde locale immédiate
    await box.put(
      creance.id,
      creance,
    );

    // Synchronisation cloud en arrière-plan
    if (_collection != null) {
      _collection!
          .doc(creance.id)
          .set(creance.toMap())
          .catchError((e) {
        print(
          'Erreur sync ajout créance : $e',
        );
      });
    }
  }

  static Future<void> updateCreance(
    Creance creance,
  ) async {
    // Mise à jour locale immédiate
    await box.put(
      creance.id,
      creance,
    );

    // Synchronisation cloud
    if (_collection != null) {
      _collection!
          .doc(creance.id)
          .set(creance.toMap())
          .catchError((e) {
        print(
          'Erreur sync modification créance : $e',
        );
      });
    }
  }

  static Future<void> deleteCreance(
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
        final creance =
            Creance.fromMap(
          doc.data()
              as Map<String, dynamic>,
        );

        await box.put(
          creance.id,
          creance,
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