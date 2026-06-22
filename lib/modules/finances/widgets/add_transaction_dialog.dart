import 'package:flutter/material.dart';

class AddTransactionDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  final Map<String, dynamic>? transaction;

  const AddTransactionDialog({
    super.key,
    required this.onAdd,
    this.transaction,
  });

  @override
  State<AddTransactionDialog> createState() =>
      _AddTransactionDialogState();
}

class _AddTransactionDialogState
    extends State<AddTransactionDialog> {
  late TextEditingController
      _titleController;

  late TextEditingController
      _amountController;

  late TextEditingController
      _descriptionController;

  late String type;
  late String category;

  bool get isEditing =>
      widget.transaction != null;

  final List<String> revenus = [
    'Salaire',
    'Vente',
    'Prime',
    'Cadeau',
    'Autre',
  ];

  final List<String> depenses = [
    'Nourriture',
    'Transport',
    'Loyer',
    'Internet',
    'Santé',
    'Loisirs',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();

    type =
        widget.transaction?['type'] ??
        'revenu';

    category =
        widget.transaction?['category'] ??
        'Salaire';

    _titleController =
        TextEditingController(
      text:
          widget.transaction?['title'] ??
          '',
    );

    _amountController =
        TextEditingController(
      text: widget.transaction == null
          ? ''
          : widget.transaction!['amount']
              .toString(),
    );

    _descriptionController =
        TextEditingController(
      text:
          widget.transaction?[
                  'description'] ??
              '',
    );
  }

  void saveTransaction() {
    final title =
        _titleController.text.trim();

    final amountText =
        _amountController.text.trim();

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

    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez saisir un montant.',
          ),
        ),
      );
      return;
    }

    final amount =
        double.tryParse(amountText);

    if (amount == null ||
        amount <= 0) {
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
          widget.transaction?['id'] ??
              DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'description':
          _descriptionController.text
              .trim(),
      'createdAt':
          widget.transaction?[
                  'createdAt'] ??
              DateTime.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing
            ? 'Modifier transaction'
            : 'Nouvelle transaction',
      ),
      content:
          SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: type,
              decoration:
                  const InputDecoration(
                labelText: 'Type',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'revenu',
                  child: Text('Revenu'),
                ),
                DropdownMenuItem(
                  value: 'depense',
                  child: Text('Dépense'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  type = value!;

                  category =
                      type == 'revenu'
                          ? revenus.first
                          : depenses.first;
                });
              },
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  _titleController,
              decoration:
                  const InputDecoration(
                labelText: 'Titre',
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  _amountController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText: 'Montant',
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: category,
              decoration:
                  const InputDecoration(
                labelText: 'Catégorie',
              ),
              items: (type == 'revenu'
                      ? revenus
                      : depenses)
                  .map(
                    (item) =>
                        DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  _descriptionController,
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
          onPressed: () {
            Navigator.pop(context);
          },
          child:
              const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed:
              saveTransaction,
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