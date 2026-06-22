import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/note_service.dart';
import '../widgets/add_note_dialog.dart';

class NoteDetailsPage extends StatefulWidget {
  final Note note;

  const NoteDetailsPage({
    super.key,
    required this.note,
  });

  @override
  State<NoteDetailsPage> createState() =>
      _NoteDetailsPageState();
}

class _NoteDetailsPageState
    extends State<NoteDetailsPage> {
  late Note note;

  @override
  void initState() {
    super.initState();
    note = widget.note;
  }

  Future<void> deleteNote() async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Suppression',
        ),
        content: const Text(
          'Voulez-vous supprimer cette note ?',
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
                const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await NoteService.deleteNote(
      note.id,
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  Future<void> togglePinned() async {
    final updated =
        note.copyWith(
      isPinned: !note.isPinned,
    );

    await NoteService.updateNote(
      updated,
    );

    setState(() {
      note = updated;
    });
  }

  Future<void> editNote() async {
    await showDialog(
      context: context,
      builder: (_) => AddNoteDialog(
        note: {
          'id': note.id,
          'title': note.title,
          'content': note.content,
          'createdAt':
              note.createdAt,
          'isPinned':
              note.isPinned,
        },
        onAdd: (data) async {
          final updated =
              note.copyWith(
            title: data['title'],
            content:
                data['content'],
            isPinned:
                data['isPinned'],
          );

          await NoteService
              .updateNote(
            updated,
          );

          setState(() {
            note = updated;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Détail Note'),
        actions: [
          IconButton(
            onPressed:
                togglePinned,
            icon: Icon(
              note.isPinned
                  ? Icons.push_pin
                  : Icons
                      .push_pin_outlined,
            ),
          ),
          IconButton(
            onPressed: editNote,
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed:
                deleteNote,
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
              note.title,
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Créée le ${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
              style:
                  const TextStyle(
                color:
                    Colors.grey,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child:
                  SingleChildScrollView(
                child: Text(
                  note.content
                          .isEmpty
                      ? 'Aucun contenu'
                      : note.content,
                  style:
                      const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}