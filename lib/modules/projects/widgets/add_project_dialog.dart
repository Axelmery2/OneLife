import 'package:flutter/material.dart';
import '../models/project_task.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  final Map<String, dynamic>? project;

  const AddProjectDialog({
    super.key,
    required this.onAdd,
    this.project,
  });

  @override
  State<AddProjectDialog> createState() =>
      _AddProjectDialogState();
}

class _AddProjectDialogState
    extends State<AddProjectDialog> {

  late TextEditingController
      _titleController;

  late TextEditingController
      _descriptionController;

  late TextEditingController
      _budgetController;

  DateTime? _deadline;

  bool get isEditing =>
      widget.project != null;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(
      text:
          widget.project?['title'] ??
              '',
    );

    _descriptionController =
        TextEditingController(
      text:
          widget.project?['description'] ??
              '',
    );

    _budgetController =
        TextEditingController(
      text: widget.project == null
          ? ''
          : widget
              .project!['budget']
              .toString(),
    );

    _deadline =
        widget.project?['deadline'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final pickedDate =
        await showDatePicker(
      context: context,
      initialDate:
          _deadline ??
              DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _deadline = pickedDate;
      });
    }
  }

  void saveProject() {
    final title =
        _titleController.text.trim();

    final description =
        _descriptionController.text
            .trim();

    final budget =
        double.tryParse(
      _budgetController.text.trim(),
    );

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

    if (budget == null ||
        budget <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez saisir un budget valide supérieur à 0.',
          ),
        ),
      );
      return;
    }

    widget.onAdd({
      'id':
          widget.project?['id'] ??
              DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),

      'title': title,

      'description':
          description,

      'budget': budget,

      'spentAmount':
          widget.project?[
                  'spentAmount'] ??
              0.0,

      'progress':
          widget.project?[
                  'progress'] ??
              0,

      'status':
          widget.project?[
                  'status'] ??
              'En cours',

      'createdAt':
          widget.project?[
                  'createdAt'] ??
              DateTime.now(),

      'deadline':
          _deadline,

      'tasks':
          widget.project?[
                  'tasks'] ??
              <ProjectTask>[],
    });

    Navigator.pop(context);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: Text(
        isEditing
            ? 'Modifier Projet'
            : 'Nouveau Projet',
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
                    'Titre',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  _descriptionController,
              maxLines: 4,
              decoration:
                  const InputDecoration(
                labelText:
                    'Description',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  _budgetController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration:
                  const InputDecoration(
                labelText:
                    'Budget',
                hintText:
                    'Ex: 500000',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            SizedBox(
              width:
                  double.infinity,
              child:
                  OutlinedButton.icon(
                onPressed:
                    selectDate,
                icon: const Icon(
                  Icons.calendar_month,
                ),
                label: Text(
                  _deadline == null
                      ? 'Date limite'
                      : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(
            context,
          ),
          child:
              const Text(
            'Annuler',
          ),
        ),
        ElevatedButton(
          onPressed:
              saveProject,
          child: Text(
            isEditing
                ? 'Modifier'
                : 'Créer',
          ),
        ),
      ],
    );
  }
}