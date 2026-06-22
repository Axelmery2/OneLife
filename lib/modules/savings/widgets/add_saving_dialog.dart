import 'package:flutter/material.dart';

class AddSavingDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  final Map<String, dynamic>? saving;

  const AddSavingDialog({
    super.key,
    required this.onAdd,
    this.saving,
  });

  @override
  State<AddSavingDialog> createState() =>
      _AddSavingDialogState();
}

class _AddSavingDialogState
    extends State<AddSavingDialog> {
  late TextEditingController
      _titleController;

  late TextEditingController
      _targetController;

  DateTime? _targetDate;

  bool get isEditing =>
      widget.saving != null;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(
      text:
          widget.saving?['title'] ??
              '',
    );

    _targetController =
        TextEditingController(
      text: widget.saving == null
          ? ''
          : widget
              .saving!['targetAmount']
              .toString(),
    );

    _targetDate =
        widget.saving?['targetDate'];
  }

  Future<void> selectDate() async {
    final pickedDate =
        await showDatePicker(
      context: context,
      initialDate:
          _targetDate ??
              DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _targetDate = pickedDate;
      });
    }
  }

  void saveSaving() {
    final title =
        _titleController.text.trim();

    final amountText =
        _targetController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez saisir un objectif.',
          ),
        ),
      );
      return;
    }

    final targetAmount =
        double.tryParse(amountText);

    if (targetAmount == null ||
        targetAmount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Montant invalide.',
          ),
        ),
      );
      return;
    }

    widget.onAdd({
      'id':
          widget.saving?['id'] ??
              DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),

      'title': title,

      'targetAmount':
          targetAmount,

      'savedAmount':
          widget.saving?[
                  'savedAmount'] ??
              0.0,

      'remainingAmount':
          targetAmount -
              (widget.saving?[
                      'savedAmount'] ??
                  0.0),

      'createdAt':
          widget.saving?[
                  'createdAt'] ??
              DateTime.now(),

      'targetDate':
          _targetDate,

      'history':
          widget.saving?[
                  'history'] ??
              [
                'Objectif créé le ${DateTime.now()}'
              ],
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing
            ? 'Modifier l’objectif'
            : 'Nouvel objectif',
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
                    'Nom de l’objectif',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  _targetController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    'Montant cible',
              ),
            ),

            const SizedBox(
              height: 20,
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
                  _targetDate == null
                      ? 'Date cible'
                      : '${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year}',
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
              saveSaving,
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