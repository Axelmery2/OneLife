import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/note_service.dart';
import '../widgets/add_note_dialog.dart';
import 'note_details_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() =>
      _NotesPageState();
}

class _NotesPageState
    extends State<NotesPage> {
  List<Note> notes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() {
    setState(() {
      notes =
          NoteService.getAllNotes();

      notes.sort((a, b) {
        if (a.isPinned &&
            !b.isPinned) {
          return -1;
        }

        if (!a.isPinned &&
            b.isPinned) {
          return 1;
        }

        return b.createdAt.compareTo(
          a.createdAt,
        );
      });
    });
  }

  List<Note> getFilteredNotes() {
    if (searchQuery.isEmpty) {
      return notes;
    }

    return notes.where((note) {
      final query =
          searchQuery.toLowerCase();

      return note.title
              .toLowerCase()
              .contains(query) ||
          note.content
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  Future<void> addNote(
    Map<String, dynamic> data,
  ) async {
    final note = Note(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      createdAt:
          data['createdAt'],
      isPinned:
          data['isPinned'],
    );

    await NoteService.addNote(
      note,
    );

    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        getFilteredNotes();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Notes',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(
              12,
            ),
            child: TextField(
              decoration:
                  InputDecoration(
                hintText:
                    'Rechercher...',
                prefixIcon:
                    const Icon(
                  Icons.search,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value;
                });
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Aucune note',
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        filtered.length,
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      final note =
                          filtered[index];

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal:
                              12,
                          vertical: 6,
                        ),
                        child:
                            ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NoteDetailsPage(
                                  note:
                                      note,
                                ),
                              ),
                            );

                            loadNotes();
                          },
                          leading: Icon(
                            note.isPinned
                                ? Icons
                                    .push_pin
                                : Icons
                                    .note,
                            color:
                                note.isPinned
                                    ? Colors
                                        .orange
                                    : null,
                          ),
                          title: Text(
                            note.title,
                          ),
                          subtitle: Text(
                            note.content,
                            maxLines: 2,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) =>
                AddNoteDialog(
              onAdd:
                  addNote,
            ),
          );
        },
        child:
            const Icon(
          Icons.add,
        ),
      ),
    );
  }
}