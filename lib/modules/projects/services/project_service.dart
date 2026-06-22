import 'package:hive/hive.dart';

import '../models/project.dart';
import '../../../services/hive_service.dart';

class ProjectService {
  static Box<Project> get box =>
      Hive.box<Project>(
        HiveService.projectsBox,
      );

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
  }

  static Future<void> updateProject(
    Project project,
  ) async {
    await box.put(
      project.id,
      project,
    );
  }

  static Future<void> deleteProject(
    String id,
  ) async {
    await box.delete(id);
  }

  static Project? getProject(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}