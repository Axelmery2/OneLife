import 'package:flutter/material.dart';

import '../models/saving.dart';
import '../services/saving_service.dart';
import '../widgets/add_saving_dialog.dart';
import '../../../core/utils/formatters.dart';

class SavingDetailsPage extends StatefulWidget {
  final Saving saving;

  const SavingDetailsPage({
    super.key,
    required this.saving,
  });

  @override
  State<SavingDetailsPage> createState() =>
      _SavingDetailsPageState();
}

class _SavingDetailsPageState
    extends State<SavingDetailsPage> {
  late Saving saving;

  @override
  void initState() {
    super.initState();
    saving = widget.saving;
  }

  Future<void> deleteSaving() async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Suppression',
        ),
        content: const Text(
          'Voulez-vous supprimer cet objectif ?',
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

    await SavingService.deleteSaving(
      saving.id,
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  Future<void> addDeposit() async {
    final controller =
        TextEditingController();

    final amount =
        await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Ajouter un dépôt',
        ),
        content: TextField(
          controller: controller,
          keyboardType:
              TextInputType.number,
          decoration:
              const InputDecoration(
            labelText:
                'Montant',
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
    saving.remainingAmount) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
    SnackBar(
      content: Text(
        'Montant maximum autorisé : ${saving.remainingAmount.toStringAsFixed(0)} FCFA',
      ),
    ),
  );
  return;
}

   final newSaved =
    (saving.savedAmount + amount)
        .clamp(
          0.0,
          saving.targetAmount,
        )
        .toDouble();
    final newRemaining =
        saving.targetAmount -
            newSaved;

    final history =
        List<String>.from(
      saving.history,
    );

    history.add(
      '${Formatters.formatDateTime(DateTime.now())}\nDépôt : ${Formatters.formatAmount(amount)}',
    );

    final updated =
        saving.copyWith(
      savedAmount: newSaved,
      remainingAmount:
          newRemaining < 0
              ? 0
              : newRemaining,
      history: history,
    );

    await SavingService.updateSaving(
      updated,
    );

    setState(() {
      saving = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
   final double progress =
    saving.targetAmount == 0
        ? 0.0
        : (saving.savedAmount /
                saving.targetAmount)
            .clamp(0.0, 1.0)
            .toDouble();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails Épargne',
        ),
        actions: [
          IconButton(
            onPressed:
                deleteSaving,
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
              saving.title,
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

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
                      'Objectif : ${Formatters.formatAmount(saving.targetAmount)}',
                    ),

                    Text(
                      'Épargné : ${Formatters.formatAmount(saving.savedAmount)}',
                    ),

                    Text(
                      'Reste : ${Formatters.formatAmount(saving.remainingAmount)}',
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
                      '${(progress * 100).toStringAsFixed(0)} % atteint',
                    ),
                  ],
                ),
              ),
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

            ...saving.history.map(
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
                    addDeposit,
                icon: const Icon(
                  Icons.savings,
                ),
                label: const Text(
                  'Ajouter un dépôt',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}