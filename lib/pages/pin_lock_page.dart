import 'package:flutter/material.dart';

import '../modules/dashboard/pages/dashboard_page.dart';
import '../services/hive_service.dart';

class PinLockPage extends StatefulWidget {
  const PinLockPage({super.key});

  @override
  State<PinLockPage> createState() =>
      _PinLockPageState();
}

class _PinLockPageState
    extends State<PinLockPage> {
  final TextEditingController
      pinController =
      TextEditingController();

  int failedAttempts = 0;

  Future<void> unlock() async {
    final profile =
        HiveService.getProfileBox()
            .getAt(0);

    if (profile == null) {
      return;
    }

    if (failedAttempts >= 5) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Trop de tentatives. Veuillez redémarrer l\'application.',
          ),
        ),
      );

      return;
    }

    if (pinController.text ==
        profile.pinCode) {
      profile.lastUnlockTime =
          DateTime.now();

      await profile.save();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const DashboardPage(),
        ),
      );
    } else {
      failedAttempts++;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Code PIN incorrect (${5 - failedAttempts} essais restants).',
          ),
        ),
      );

      pinController.clear();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(
            24,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(
                  height: 30,
                ),

                const Text(
                  'OneLife est protégé',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'Entrez votre code PIN',
                ),

                const SizedBox(
                  height: 30,
                ),

                TextField(
                  controller:
                      pinController,
                  keyboardType:
                      TextInputType
                          .number,
                  maxLength: 4,
                  obscureText: true,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    fontSize: 28,
                    letterSpacing: 10,
                  ),
                  decoration:
                      const InputDecoration(
                    border:
                        OutlineInputBorder(),
                    hintText:
                        '••••',
                  ),
                  onSubmitted: (_) =>
                      unlock(),
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton(
                    onPressed:
                        unlock,
                    child:
                        const Text(
                      'Déverrouiller',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}