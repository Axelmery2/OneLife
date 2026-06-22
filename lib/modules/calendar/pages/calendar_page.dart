import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/event.dart';
import '../services/event_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() =>
      _CalendarPageState();
}

class _CalendarPageState
    extends State<CalendarPage> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  void loadEvents() {
    setState(() {
      events =
          EventService.getAllEvents();
    });
  }

  Future<void> addEvent() async {
    final titleController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

    DateTime selectedDate =
        DateTime.now();

    final result =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:
            const Text('Nouvel événement'),
        content: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller:
                  titleController,
              decoration:
                  const InputDecoration(
                labelText: 'Titre',
              ),
            ),
            TextField(
              controller:
                  descriptionController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Description',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              false,
            ),
            child:
                const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),
            child:
                const Text('Ajouter'),
          ),
        ],
      ),
    );

    if (result != true) return;

    final event = Event(
      id: const Uuid().v4(),
      title:
          titleController.text,
      description:
          descriptionController.text,
      date: selectedDate,
    );

    await EventService.addEvent(
      event,
    );

    loadEvents();
  }

  Future<void> deleteEvent(
    Event event,
  ) async {
    await EventService.deleteEvent(
      event.id,
    );

    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Calendrier'),
      ),
      body: events.isEmpty
          ? const Center(
              child: Text(
                'Aucun événement',
              ),
            )
          : ListView.builder(
              itemCount:
                  events.length,
              itemBuilder:
                  (context, index) {
                final event =
                    events[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                    8,
                  ),
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.event,
                    ),
                    title:
                        Text(event.title),
                    subtitle: Text(
                      '${event.date.day}/${event.date.month}/${event.date.year}\n${event.description}',
                    ),
                    trailing:
                        IconButton(
                      icon:
                          const Icon(
                        Icons.delete,
                        color:
                            Colors.red,
                      ),
                      onPressed: () =>
                          deleteEvent(
                        event,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: addEvent,
        child:
            const Icon(Icons.add),
      ),
    );
  }
}