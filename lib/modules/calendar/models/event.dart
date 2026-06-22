import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 9)
class Event extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime date;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });
}