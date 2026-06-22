import 'package:flutter/material.dart';

import '../models/debt.dart';
import '../services/debt_service.dart';
import '../widgets/add_debt_dialog.dart';
import '../../../core/utils/formatters.dart';

class DebtDetailsPage extends StatefulWidget {
  final Debt debt;

  const DebtDetailsPage({
    super.key,
    required this.debt,
  });

  @override
  State<DebtDetailsPage> createState() =>
      _DebtDetailsPageState();
}

class _DebtDetailsPageState
    extends State<DebtDetailsPage> {
  late Debt debt;

  @override
  void initState() {
    super.initState();
    debt = widget.debt;
  }

  String getStatus() {
    if (debt.remainingAmount <= 0) {
      return 'Soldée';
    }

    if (debt.dueDate != null &&
        DateTime.now().isAfter(
          debt.dueDate!,
        )) {
      return 'En retard';
    }

    return 'En cours';
  }

  Color getStatusColor() {
    switch (getStatus()) {
      case 'Soldée':
        return Colors.green;

      case 'En retard':
        return Colors.red;

      default:
        return Colors.blue;
    }
  }

  Future<void> deleteDebt() async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Suppression',
        ),
        content: const Text(
          'Voulez-vous supprimer cette dette ?',
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

    await DebtService.deleteDebt(
      debt.id,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Dette supprimée',
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  Future<void> editDebt() async {
    await showDialog(
      context: context,
      builder: (_) => AddDebtDialog(
        debt: {
          'id': debt.id,
          'name': debt.name,
          'phone': debt.phone,
          'description':
              debt.description,
          'totalAmount':
              debt.totalAmount,
          'paidAmount':
              debt.paidAmount,
          'createdAt':
              debt.createdAt,
          'dueDate':
              debt.dueDate,
          'history':
              debt.history,
        },
        onAdd: (data) async {
          final updated =
              debt.copyWith(
            name: data['name'],
            phone: data['phone'],
            description:
                data['description'],
            totalAmount:
                data['totalAmount'],
            paidAmount:
                data['paidAmount'],
            remainingAmount:
                data['remainingAmount'],
            dueDate:
                data['dueDate'],
            history:
                List<String>.from(
              data['history'],
            ),
          );

          await DebtService
              .updateDebt(
            updated,
          );

          setState(() {
            debt = updated;
          });
        },
      ),
    );
  }

  Future<void> addPayment() async {
    final controller =
        TextEditingController();

    final amount =
        await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Ajouter un remboursement',
        ),
        content: TextField(
          controller: controller,
          keyboardType:
              TextInputType.number,
          decoration:
              const InputDecoration(
            labelText:
                'Montant remboursé',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
            ),
            child:
                const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                double.tryParse(
                  controller.text,
                ),
              );
            },
            child:
                const Text('Valider'),
          ),
        ],
      ),
    );

    if (amount == null ||
        amount <= 0) {
      return;
    }

    if (amount >
        debt.remainingAmount) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Le montant dépasse le reste à payer (${Formatters.formatAmount(debt.remainingAmount)})',
          ),
        ),
      );

      return;
    }

    final newPaid =
        debt.paidAmount + amount;

    final newRemaining =
        debt.totalAmount -
            newPaid;

    final history =
        List<String>.from(
      debt.history,
    );

    history.add(
      '${Formatters.formatDateTime(DateTime.now())}\nRemboursement effectué : ${Formatters.formatAmount(amount)}',
    );

    final updated =
        debt.copyWith(
      paidAmount: newPaid,
      remainingAmount:
          newRemaining < 0
              ? 0
              : newRemaining,
      history: history,
    );

    await DebtService.updateDebt(
      updated,
    );

    setState(() {
      debt = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        debt.totalAmount == 0
            ? 0.0
            : debt.paidAmount /
                debt.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails Dette',
        ),
        actions: [
          IconButton(
            onPressed:
                editDebt,
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed:
                deleteDebt,
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              debt.name,
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
              debt.phone,
            ),

            if (debt.dueDate != null) ...[
              const SizedBox(
                height: 8,
              ),
              Text(
                'Date limite : '
                '${debt.dueDate!.day.toString().padLeft(2, '0')}/'
                '${debt.dueDate!.month.toString().padLeft(2, '0')}/'
                '${debt.dueDate!.year}',
              ),
            ],

            const SizedBox(
              height: 20,
            ),

            Card(
              child: Padding(
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
                      'Total : ${Formatters.formatAmount(debt.totalAmount)}',
                    ),
                    Text(
                      'Remboursé : ${Formatters.formatAmount(debt.paidAmount)}',
                    ),
                    Text(
                      'Reste : ${Formatters.formatAmount(debt.remainingAmount)}',
                      style:
                          const TextStyle(
                        color:
                            Colors.red,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    LinearProgressIndicator(
                      value:
                          progress,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      '${(progress * 100).toStringAsFixed(0)} % remboursé',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Chip(
              label: Text(
                getStatus(),
              ),
              backgroundColor:
                  getStatusColor(),
              labelStyle:
                  const TextStyle(
                color:
                    Colors.white,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              'Description',
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(
              debt.description.isEmpty
                  ? 'Aucune description'
                  : debt.description,
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Historique',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            ...debt.history.map(
              (e) => Card(
                child: ListTile(
                  leading:
                      const Icon(
                    Icons.history,
                  ),
                  title: Text(e),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton.icon(
                onPressed:
                    debt.remainingAmount <=
                            0
                        ? null
                        : addPayment,
                icon: const Icon(
                  Icons.payments,
                ),
                label: const Text(
                  'Ajouter un remboursement',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}