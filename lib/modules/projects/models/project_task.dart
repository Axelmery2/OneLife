import 'package:hive/hive.dart';

part 'project_task.g.dart';

@HiveType(typeId: 7)
class ProjectTask extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool completed;

  ProjectTask({
    required this.title,
    this.completed = false,
  });
}