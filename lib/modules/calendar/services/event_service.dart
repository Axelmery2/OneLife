import 'package:hive/hive.dart';

import '../models/event.dart';

class EventService {
  static const String boxName = 'events';

  static Box<Event> get _box =>
      Hive.box<Event>(boxName);

  static List<Event> getAllEvents() {
    final events = _box.values.toList();

    events.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    return events;
  }

  static Future<void> addEvent(
    Event event,
  ) async {
    await _box.put(
      event.id,
      event,
    );
  }

  static Future<void> updateEvent(
    Event event,
  ) async {
    await _box.put(
      event.id,
      event,
    );
  }

  static Future<void> deleteEvent(
    String id,
  ) async {
    await _box.delete(id);
  }
}