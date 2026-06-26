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
          .currentUser!
          .uid;

  static CollectionReference get
      _collection => _firestore
          .collection('users')
          .doc(_uid)
          .collection('projects');

  static List<Project> getAllProjects() {
    return box.values.toList();
  }

  static Future<void> addProject(
    Project project,
  ) async {
    await box.put(
      project.id,
      project,
    );

    await _collection
        .doc(project.id)
        .set(
          project.toMap(),
        );
  }

  static Future<void> updateProject(
    Project project,
  ) async {
    await box.put(
      project.id,
      project,
    );

    await _collection
        .doc(project.id)
        .set(
          project.toMap(),
        );
  }

  static Future<void> deleteProject(
    String id,
  ) async {
    await box.delete(id);

    await _collection
        .doc(id)
        .delete();
  }

  static Project? getProject(
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
}