import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../models/project.dart';

class ProjectService {
  static Box<Project> get box =>
      HiveService.getProjectsBox();

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
        .collection('projects');
  }

  static List<Project>
      getAllProjects() {
    return box.values.toList();
  }

  static Future<void> addProject(
    Project project,
  ) async {
    // Sauvegarde locale
    await box.put(
      project.id,
      project,
    );

    // Sauvegarde cloud
    if (_collection != null) {
      await _collection!
          .doc(project.id)
          .set(
            project.toMap(),
          );
    }
  }

  static Future<void> updateProject(
    Project project,
  ) async {
    // Mise à jour locale
    await box.put(
      project.id,
      project,
    );

    // Mise à jour cloud
    if (_collection != null) {
      await _collection!
          .doc(project.id)
          .set(
            project.toMap(),
          );
    }
  }

  static Future<void> deleteProject(
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

  static Project? getProject(
    String id,
  ) {
    return box.get(id);
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
      final project =
          Project.fromMap(
        doc.data()
            as Map<String, dynamic>,
      );

      await box.put(
        project.id,
        project,
      );
    }
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}