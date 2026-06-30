import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../widgets/add_transaction_dialog.dart';


class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() =>
      _FinancesPageState();
}

class _FinancesPageState
    extends State<FinancesPage> {
  List<Transaction> transactions = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() {
  setState(() {
    transactions =
        TransactionService
            .getAllTransactions();

    transactions.sort(
      (a, b) => b.createdAt.compareTo(
        a.createdAt,
      ),
    );
  });
}

  List<Transaction>
      getFilteredTransactions() {
    if (searchQuery.isEmpty) {
      return transactions;
    }

    return transactions.where((t) {
      final query =
          searchQuery.toLowerCase();

      return t.title
              .toLowerCase()
              .contains(query) ||
          t.category
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  Future<void> addTransaction(
    Map<String, dynamic> data,
  ) async {
    final transaction =
        Transaction(
      id: data['id'],
      title: data['title'],
      amount: data['amount'],
      type: data['type'],
      category: data['category'],
      description:
          data['description'],
      createdAt:
          data['createdAt'],
    );

    await TransactionService
        .addTransaction(
      transaction,
    );

    loadTransactions();
  }

  Future<void> deleteTransaction(
    Transaction transaction,
  ) async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:
            const Text('Suppression'),
        content: const Text(
          'Voulez-vous supprimer cette transaction ?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child:
                const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child:
                const Text('Supprimer'),
          ),
        ],
      ),
    );

    

    if (confirm != true) return;

    await TransactionService
        .deleteTransaction(
      transaction.id,
    );

    loadTransactions();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Transaction supprimée',
        ),
      ),
    );
  }
  Future<void> editTransaction(
  Transaction transaction,
) async {
  await showDialog(
    context: context,
    builder: (_) => AddTransactionDialog(
      transaction: {
        'id': transaction.id,
        'title': transaction.title,
        'amount': transaction.amount,
        'type': transaction.type,
        'category': transaction.category,
        'description':
            transaction.description,
        'createdAt':
            transaction.createdAt,
      },
      onAdd: (data) async {
        final updatedTransaction =
            transaction.copyWith(
          title: data['title'],
          amount: data['amount'],
          type: data['type'],
          category: data['category'],
          description:
              data['description'],
        );

        await TransactionService
            .updateTransaction(
          updatedTransaction,
        );

        loadTransactions();

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Transaction modifiée',
            ),
          ),
        );
      },
    ),
  );
}

  Color getColor(
    Transaction transaction,
  ) {
    return transaction.type ==
            'revenu'
        ? Colors.green
        : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final revenus =
        TransactionService
            .getTotalRevenus();

    final depenses =
        TransactionService
            .getTotalDepenses();

    final solde =
        TransactionService
            .getSolde();

    final filteredTransactions =
        getFilteredTransactions();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Finances'),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Padding(
            padding:
                const EdgeInsets.all(
              12,
            ),
            child: TextField(
              decoration:
                  InputDecoration(
                hintText:
                    'Rechercher...',
                prefixIcon:
                    const Icon(
                  Icons.search,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value;
                });
              },
            ),
          ),

          Container(
            width: double.infinity,
            margin:
                const EdgeInsets.all(
              12,
            ),
            padding:
                const EdgeInsets.all(
              16,
            ),
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Column(
              children: [

                const Text(
                  'Solde actuel',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

               Text(
  '${solde.toStringAsFixed(0)} FCFA',
  style: const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
),

                const SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceAround,
                  children: [

                    Column(
                      children: [
                        const Text(
                          'Revenus',
                        ),
                        Text(
                          '${revenus.toStringAsFixed(0)} FCFA',
                          style:
                              const TextStyle(
                            color:
                                Colors.green,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const Text(
                          'Dépenses',
                        ),
                        Text(
                          '${depenses.toStringAsFixed(0)} FCFA',
                          style:
                              const TextStyle(
                            color:
                                Colors.red,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child:
                filteredTransactions
                        .isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune transaction',
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            filteredTransactions
                                .length,
                        itemBuilder:
                            (
                              context,
                              index,
                            ) {
                          final t =
                              filteredTransactions[
                                  index];

                          return Card(
                            margin:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  12,
                              vertical:
                                  6,
                            ),
                            child:
                                ListTile(
                              leading:
                                  CircleAvatar(
                                backgroundColor:
                                    getColor(
                                  t,
                                ),
                                child: Icon(
                                  t.type ==
                                          'revenu'
                                      ? Icons
                                          .arrow_downward
                                      : Icons
                                          .arrow_upward,
                                  color: Colors
                                      .white,
                                ),
                              ),
                              title: Text(
                                t.title,
                              ),
                              subtitle: Column(
                                mainAxisSize:
                                    MainAxisSize
                                        .min,
  crossAxisAlignment:
      CrossAxisAlignment.start,
  children: [
    Text(t.category),
    Text(
      '${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    ),
  ],
),
                           trailing: SizedBox(
  width: 130,
  child: Row(
    children: [
      Expanded(
        child: Text(
          '${t.amount.toStringAsFixed(0)} FCFA',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.blue,
        ),
        onPressed: () {
          editTransaction(t);
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          deleteTransaction(t);
        },
      ),
    ],
  ),
),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) =>
                AddTransactionDialog(
              onAdd:
                  addTransaction,
            ),
          );
        },
        child:
            const Icon(Icons.add),
      ),
    );
  }
}