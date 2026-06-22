import 'package:flutter/material.dart';

class AddExpenseDialog extends StatefulWidget {
  final Function(
    String title,
    double amount,
    String description,
  ) onAdd;

  const AddExpenseDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddExpenseDialog> createState() =>
      _AddExpenseDialogState();
}

class _AddExpenseDialogState
    extends State<AddExpenseDialog> {
  final titleController =
      TextEditingController();

  final amountController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  void save() {
    final title =
        titleController.text.trim();

    final amount =
        double.tryParse(
              amountController.text,
            ) ??
            0;

    final description =
        descriptionController.text
            .trim();

    if (title.isEmpty ||
        amount <= 0) {
      return;
    }

    widget.onAdd(
      title,
      amount,
      description,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Nouvelle dépense',
      ),
      content:
          SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller:
                  titleController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Nom',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  amountController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    'Montant',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  descriptionController,
              maxLines: 3,
              decoration:
                  const InputDecoration(
                labelText:
                    'Description',
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
          onPressed: save,
          child:
              const Text(
            'Ajouter',
          ),
        ),
      ],
    );
  }
}