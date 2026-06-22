import 'package:flutter/material.dart';

class AddNoteDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  final Map<String, dynamic>? note;

  const AddNoteDialog({
    super.key,
    required this.onAdd,
    this.note,
  });

  @override
  State<AddNoteDialog> createState() =>
      _AddNoteDialogState();
}

class _AddNoteDialogState
    extends State<AddNoteDialog> {
  late TextEditingController
      _titleController;

  late TextEditingController
      _contentController;

  bool isPinned = false;

  bool get isEditing =>
      widget.note != null;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(
      text:
          widget.note?['title'] ??
              '',
    );

    _contentController =
        TextEditingController(
      text:
          widget.note?['content'] ??
              '',
    );

    isPinned =
        widget.note?['isPinned'] ??
            false;
  }

  void saveNote() {
    final title =
        _titleController.text.trim();

    final content =
        _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez saisir un titre.',
          ),
        ),
      );
      return;
    }

    widget.onAdd({
      'id':
          widget.note?['id'] ??
              DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),

      'title': title,

      'content': content,

      'createdAt':
          widget.note?[
                  'createdAt'] ??
              DateTime.now(),

      'isPinned': isPinned,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing
            ? 'Modifier la note'
            : 'Ajouter une note',
      ),
      content:
          SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller:
                  _titleController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Titre *',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  _contentController,
              maxLines: 6,
              decoration:
                  const InputDecoration(
                labelText:
                    'Contenu',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            SwitchListTile(
              value: isPinned,
              onChanged: (value) {
                setState(() {
                  isPinned = value;
                });
              },
              title: const Text(
                'Épingler cette note',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child:
              const Text(
            'Annuler',
          ),
        ),
        ElevatedButton(
          onPressed: saveNote,
          child: Text(
            isEditing
                ? 'Modifier'
                : 'Ajouter',
          ),
        ),
      ],
    );
  }
}