import 'package:flutter/material.dart';

import '../models/saving.dart';
import '../services/saving_service.dart';
import '../widgets/add_saving_dialog.dart';
import 'saving_details_page.dart';
import '../../../core/utils/formatters.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() =>
      _SavingsPageState();
}

class _SavingsPageState
    extends State<SavingsPage> {
  List<Saving> savings = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadSavings();
  }

  void loadSavings() {
    setState(() {
      savings =
          SavingService.getAllSavings();

      savings.sort(
        (a, b) => b.createdAt.compareTo(
          a.createdAt,
        ),
      );
    });
  }

  List<Saving>
      getFilteredSavings() {
    if (searchQuery.isEmpty) {
      return savings;
    }

    return savings.where((s) {
      final query =
          searchQuery.toLowerCase();

      return s.title
          .toLowerCase()
          .contains(query);
    }).toList();
  }

  double getTotalTarget() {
    return savings.fold(
      0,
      (sum, s) =>
          sum + s.targetAmount,
    );
  }

  double getTotalSaved() {
    return savings.fold(
      0,
      (sum, s) =>
          sum + s.savedAmount,
    );
  }

  double getTotalRemaining() {
    return savings.fold(
      0,
      (sum, s) =>
          sum + s.remainingAmount,
    );
  }

  Future<void> addSaving(
    Map<String, dynamic> data,
  ) async {
    final saving = Saving(
      id: data['id'],
      title: data['title'],
      targetAmount:
          data['targetAmount'],
      savedAmount:
          data['savedAmount'],
      remainingAmount:
          data['remainingAmount'],
      createdAt:
          data['createdAt'],
      targetDate:
          data['targetDate'],
      history:
          List<String>.from(
        data['history'],
      ),
    );

    await SavingService.addSaving(
      saving,
    );

    loadSavings();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        getFilteredSavings();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Épargnes',
        ),
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
                  'Résumé Épargne',
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
                    getTotalSaved(),
                  ),
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
                          Formatters
                              .formatAmount(
                            getTotalTarget(),
                          ),
                        ),
                        const Text(
                          'Objectifs',
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          Formatters
                              .formatAmount(
                            getTotalRemaining(),
                          ),
                          style:
                              const TextStyle(
                            color:
                                Colors.red,
                          ),
                        ),
                        const Text(
                          'Reste',
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
                      'Aucune épargne',
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
                      final saving =
                          filtered[index];

                      final progress =
                          saving.targetAmount ==
                                  0
                              ? 0.0
                              : saving.savedAmount /
                                  saving.targetAmount;

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
                                    SavingDetailsPage(
                                  saving:
                                      saving,
                                ),
                              ),
                            );

                            loadSavings();
                          },

                          leading:
                              const CircleAvatar(
                            child: Icon(
                              Icons.savings,
                            ),
                          ),

                          title: Text(
                            saving.title,
                          ),

                          subtitle:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${(progress * 100).toStringAsFixed(0)} % atteint',
                              ),

                              const SizedBox(
                                height:
                                    5,
                              ),

                              LinearProgressIndicator(
                                value:
                                    progress,
                              ),
                            ],
                          ),

                          trailing:
                              Text(
                            Formatters
                                .formatAmount(
                              saving.savedAmount,
                            ),
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
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
                AddSavingDialog(
              onAdd:
                  addSaving,
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