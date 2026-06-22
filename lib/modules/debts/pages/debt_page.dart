import 'package:flutter/material.dart';

import '../models/debt.dart';
import '../services/debt_service.dart';
import '../widgets/add_debt_dialog.dart';
import 'debt_details_page.dart';
import '../../../core/utils/formatters.dart';

class DebtsPage extends StatefulWidget {
  const DebtsPage({super.key});

  @override
  State<DebtsPage> createState() =>
      _DebtsPageState();
}

class _DebtsPageState
    extends State<DebtsPage> {
  List<Debt> debts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadDebts();
  }

  void loadDebts() {
    setState(() {
      debts = DebtService.getAllDebts();

      debts.sort(
        (a, b) => b.createdAt.compareTo(
          a.createdAt,
        ),
      );
    });
  }

  String getStatus(
    Debt debt,
  ) {
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

  Color getStatusColor(
    String status,
  ) {
    switch (status) {
      case 'Soldée':
        return Colors.green;

      case 'En retard':
        return Colors.red;

      default:
        return Colors.blue;
    }
  }

  List<Debt> getFilteredDebts() {
    if (searchQuery.isEmpty) {
      return debts;
    }

    return debts.where((d) {
      final query =
          searchQuery.toLowerCase();

      return d.name
              .toLowerCase()
              .contains(query) ||
          d.phone
              .toLowerCase()
              .contains(query) ||
          d.totalAmount
              .toString()
              .contains(query) ||
          getStatus(d)
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  double getTotalRemaining() {
    return debts.fold(
      0,
      (sum, d) =>
          sum + d.remainingAmount,
    );
  }

  int getInProgressCount() {
    return debts
        .where(
          (d) =>
              getStatus(d) ==
              'En cours',
        )
        .length;
  }

  int getLateCount() {
    return debts
        .where(
          (d) =>
              getStatus(d) ==
              'En retard',
        )
        .length;
  }

  int getPaidCount() {
    return debts
        .where(
          (d) =>
              getStatus(d) ==
              'Soldée',
        )
        .length;
  }

  Future<void> addDebt(
    Map<String, dynamic> data,
  ) async {
    final debt = Debt(
      id: data['id'],
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
      createdAt:
          data['createdAt'],
      dueDate:
          data['dueDate'],
      history:
          List<String>.from(
        data['history'],
      ),
    );

    await DebtService.addDebt(
      debt,
    );

    loadDebts();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        getFilteredDebts();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Dettes',
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          if (getLateCount() > 0)
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.all(
                12,
              ),
              padding:
                  const EdgeInsets.all(
                12,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Colors.redAccent,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: Text(
                '⚠️ ${getLateCount()} dette(s) en retard',
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

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
              color:
                  Colors.white,
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Résumé des dettes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  Formatters.formatAmount(
                    getTotalRemaining(),
                  ),
                  style:
                      const TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.red,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${getInProgressCount()}',
                        ),
                        const Text(
                          'En cours',
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${getLateCount()}',
                          style:
                              const TextStyle(
                            color:
                                Colors.red,
                          ),
                        ),
                        const Text(
                          'Retard',
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${getPaidCount()}',
                          style:
                              const TextStyle(
                            color:
                                Colors.green,
                          ),
                        ),
                        const Text(
                          'Soldées',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Aucune dette',
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        filtered.length,
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      final debt =
                          filtered[index];

                      final status =
                          getStatus(
                        debt,
                      );

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal:
                              12,
                          vertical: 6,
                        ),
                        child:
                            ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DebtDetailsPage(
                                  debt:
                                      debt,
                                ),
                              ),
                            );

                            loadDebts();
                          },
                          leading:
                              const CircleAvatar(
                            child: Icon(
                              Icons.handshake,
                            ),
                          ),
                          title: Text(
                            debt.name,
                          ),
                          subtitle:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                debt.phone,
                              ),
                              Text(
                                'Reste : ${Formatters.formatAmount(debt.remainingAmount)}',
                              ),
                            ],
                          ),
                          trailing:
                              Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  10,
                              vertical: 6,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  getStatusColor(
                                status,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                            child:
                                Text(
                              status,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) =>
                AddDebtDialog(
              onAdd:
                  addDebt,
            ),
          );
        },
        child:
            const Icon(
          Icons.add,
        ),
      ),
    );
  }
}