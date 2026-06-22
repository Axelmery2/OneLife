import 'package:flutter/material.dart';

import '../models/creance.dart';
import '../services/creance_service.dart';
import '../widgets/add_creance_dialog.dart';
import 'creance_details_page.dart';

class CreancesPage extends StatefulWidget {
  const CreancesPage({super.key});

  @override
  State<CreancesPage> createState() =>
      _CreancesPageState();
}

class _CreancesPageState
    extends State<CreancesPage> {
  List<Creance> creances = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadCreances();
  }

  void loadCreances() {
    setState(() {
      creances =
          CreanceService.getAllCreances();

      creances.sort(
        (a, b) => b.createdAt.compareTo(
          a.createdAt,
        ),
      );
    });
  }

  String getStatus(
    Creance creance,
  ) {
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

  List<Creance>
      getFilteredCreances() {
    if (searchQuery.isEmpty) {
      return creances;
    }

    return creances.where((c) {
      final query =
          searchQuery.toLowerCase();

      return c.name
              .toLowerCase()
              .contains(query) ||
          c.phone
              .toLowerCase()
              .contains(query) ||
          c.totalAmount
              .toString()
              .contains(query) ||
          getStatus(c)
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  double getTotalRemaining() {
    return creances.fold(
      0,
      (sum, c) =>
          sum + c.remainingAmount,
    );
  }

  int getInProgressCount() {
    return creances
        .where(
          (c) =>
              getStatus(c) ==
              'En cours',
        )
        .length;
  }

  int getLateCount() {
    return creances
        .where(
          (c) =>
              getStatus(c) ==
              'En retard',
        )
        .length;
  }

  int getPaidCount() {
    return creances
        .where(
          (c) =>
              getStatus(c) ==
              'Soldée',
        )
        .length;
  }

  Future<void> addCreance(
    Map<String, dynamic> data,
  ) async {
    final creance = Creance(
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

    await CreanceService.addCreance(
      creance,
    );

    loadCreances();
  }

  Future<void> deleteCreance(
    Creance creance,
  ) async {
    await CreanceService
        .deleteCreance(
      creance.id,
    );

    loadCreances();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        getFilteredCreances();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Mes Créances',
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
                '⚠️ ${getLateCount()} créance(s) en retard',
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
                  'Résumé des créances',
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
                  '${getTotalRemaining().toStringAsFixed(0)} FCFA',
                  style:
                      const TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.green,
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
                      'Aucune créance',
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
                      final creance =
                          filtered[index];

                      final status =
                          getStatus(
                        creance,
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CreanceDetailsPage(
                                  creance:
                                      creance,
                                ),
                              ),
                            ).then(
                              (_) =>
                                  loadCreances(),
                            );
                          },
                          leading:
                              const CircleAvatar(
                            child: Icon(
                              Icons.payments,
                            ),
                          ),
                          title: Text(
                            creance.name,
                          ),
                          subtitle:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                creance.phone,
                              ),
                              Text(
                                'Reste : ${creance.remainingAmount.toStringAsFixed(0)} FCFA',
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
                AddCreanceDialog(
              onAdd:
                  addCreance,
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