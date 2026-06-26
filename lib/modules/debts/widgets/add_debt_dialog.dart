import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDebtDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  final Map<String, dynamic>? debt;

  const AddDebtDialog({
    super.key,
    required this.onAdd,
    this.debt,
  });

  @override
  State<AddDebtDialog> createState() =>
      _AddDebtDialogState();
}

class _AddDebtDialogState
    extends State<AddDebtDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  DateTime? _dueDate;

  bool get isEditing =>
      widget.debt != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.debt?['name'] ?? '',
    );

    _phoneController = TextEditingController(
      text: widget.debt?['phone'] ?? '',
    );

    _amountController = TextEditingController(
      text: widget.debt == null
          ? ''
          : widget.debt!['totalAmount']
              .toString(),
    );

    _descriptionController =
        TextEditingController(
      text:
          widget.debt?['description'] ?? '',
    );

    _dueDate = widget.debt?['dueDate'];
  }

  Future<void> selectDueDate() async {
    final pickedDate =
        await showDatePicker(
      context: context,
      initialDate:
          _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void saveDebt() {
    final name =
        _nameController.text.trim();

    final phone =
        _phoneController.text.trim();

    final amountText =
        _amountController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez saisir le nom.',
          ),
        ),
      );
      return;
    }

    if (phone.isNotEmpty) {
      if (!RegExp(
        r'^(01|05|07)[0-9]{8}$',
      ).hasMatch(phone)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Numéro invalide. Exemple : 0701234567',
            ),
          ),
        );
        return;
      }
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

    final user = FirebaseAuth.instance.currentUser;

    widget.onAdd({
      'id':
          widget.debt?['id'] ??
              DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),
      'userId': user?.uid,
      'userEmail': user?.email,

      'name': name,

      'phone': phone,

      'description':
          _descriptionController.text
              .trim(),

      'totalAmount': amount,

      'paidAmount':
          widget.debt?['paidAmount'] ??
              0.0,

      'remainingAmount':
          widget.debt == null
              ? amount
              : amount -
                  (widget.debt![
                      'paidAmount']),

      'createdAt':
          widget.debt?[
                  'createdAt'] ??
              DateTime.now(),

      'dueDate': _dueDate,

      'history':
          widget.debt?[
                  'history'] ??
              [
                'Dette créée le ${DateTime.now()}'
              ],
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing
            ? 'Modifier la dette'
            : 'Ajouter une dette',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller:
                  _nameController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Nom de la personne *',
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  _phoneController,
              keyboardType:
                  TextInputType.phone,
              decoration:
                  const InputDecoration(
                labelText:
                    'Téléphone',
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
                labelText:
                    'Montant *',
              ),
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

            const SizedBox(height: 20),

            SizedBox(
              width:
                  double.infinity,
              child:
                  OutlinedButton.icon(
                onPressed:
                    selectDueDate,
                icon: const Icon(
                  Icons.calendar_month,
                ),
                label: Text(
                  _dueDate == null
                      ? 'Choisir une date limite'
                      : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                ),
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
          onPressed: saveDebt,
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