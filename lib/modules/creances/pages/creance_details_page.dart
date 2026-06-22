import 'package:flutter/material.dart';

import '../models/creance.dart';
import '../services/creance_service.dart';
import '../widgets/add_creance_dialog.dart';
import '../../../core/utils/formatters.dart';

class CreanceDetailsPage extends StatefulWidget {
  final Creance creance;

  const CreanceDetailsPage({
    super.key,
    required this.creance,
  });

  @override
  State<CreanceDetailsPage> createState() =>
      _CreanceDetailsPageState();
}

class _CreanceDetailsPageState
    extends State<CreanceDetailsPage> {
  late Creance creance;

  @override
  void initState() {
    super.initState();
    creance = widget.creance;
  }

  String getStatus() {
    if (creance.remainingAmount <= 0) {
      return 'Soldée';
    }

    if (creance.dueDate != null &&
        DateTime.now().isAfter(
          creance.dueDate!,
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

  Future<void> deleteCreance() async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Suppression',
        ),
        content: const Text(
          'Voulez-vous supprimer cette créance ?',
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

    await CreanceService.deleteCreance(
  creance.id,
);

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text(
      'Créance supprimée',
    ),
  ),
);

Navigator.pop(context, true);
  }

  Future<void> editCreance() async {
    await showDialog(
      context: context,
      builder: (_) => AddCreanceDialog(
        creance: {
          'id': creance.id,
          'name': creance.name,
          'phone': creance.phone,
          'description':
              creance.description,
          'totalAmount':
              creance.totalAmount,
          'paidAmount':
              creance.paidAmount,
          'createdAt':
              creance.createdAt,
          'dueDate':
              creance.dueDate,
          'history':
              creance.history,
        },
        onAdd: (data) async {
          final updated =
              creance.copyWith(
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

          await CreanceService
              .updateCreance(
            updated,
          );

          setState(() {
            creance = updated;
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
          'Ajouter un paiement',
        ),
        content: TextField(
          controller: controller,
          keyboardType:
              TextInputType.number,
          decoration:
              const InputDecoration(
            labelText:
                'Montant payé',
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

   if (amount > creance.remainingAmount) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Le montant dépasse le reste à payer (${Formatters.formatAmount(creance.remainingAmount)})',
      ),
    ),
  );

  return;
}

    final newPaid =
        creance.paidAmount + amount;

    final newRemaining =
        creance.totalAmount -
            newPaid;

    final history =
        List<String>.from(
      creance.history,
    );

    history.add(
  '${Formatters.formatDateTime(DateTime.now())}\nPaiement reçu : ${Formatters.formatAmount(amount)}',
);

    final updated =
        creance.copyWith(
      paidAmount: newPaid,
      remainingAmount:
          newRemaining < 0
              ? 0
              : newRemaining,
      history: history,
    );

    await CreanceService
        .updateCreance(updated);

    setState(() {
      creance = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        creance.totalAmount == 0
            ? 0.0
            : creance.paidAmount /
                creance.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails Créance',
        ),
        actions: [
          IconButton(
            onPressed:
                editCreance,
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed:
                deleteCreance,
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
              creance.name,
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
              creance.phone,
            ),

            if (creance.dueDate != null) ...[
  const SizedBox(height: 8),

  Text(
    'Date limite : '
    '${creance.dueDate!.day.toString().padLeft(2, '0')}/'
    '${creance.dueDate!.month.toString().padLeft(2, '0')}/'
    '${creance.dueDate!.year}',
    style: const TextStyle(
      fontWeight: FontWeight.w500,
    ),
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
  'Total : ${Formatters.formatAmount(creance.totalAmount)}',
),

Text(
  'Payé : ${Formatters.formatAmount(creance.paidAmount)}',
),

Text(
  'Reste : ${Formatters.formatAmount(creance.remainingAmount)}',
  style: const TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
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
                      '${(progress * 100).toStringAsFixed(0)} % récupéré',
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

            Text(
              'Description',
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(
              creance.description
                      .isEmpty
                  ? 'Aucune description'
                  : creance.description,
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

            ...creance.history.map(
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
                    creance.remainingAmount <=
                            0
                        ? null
                        : addPayment,
                icon: const Icon(
                  Icons.payments,
                ),
                label: const Text(
                  'Ajouter un paiement',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}