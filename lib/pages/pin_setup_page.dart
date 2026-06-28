import 'package:flutter/material.dart';

import '../services/hive_service.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() =>
      _PinSetupPageState();
}

class _PinSetupPageState
    extends State<PinSetupPage> {
  final pinController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  bool loading = false;

  int autoLockMinutes = 5;

  Future<void> savePin() async {
    if (pinController.text.length != 4) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Le code PIN doit contenir 4 chiffres.',
          ),
        ),
      );
      return;
    }

    if (pinController.text !=
        confirmController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Les deux codes PIN sont différents.',
          ),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final profile =
        HiveService.getProfileBox()
            .getAt(0);

    if (profile != null) {
      profile.pinEnabled = true;
      profile.pinCode =
          pinController.text;

      profile.autoLockMinutes =
          autoLockMinutes;

      await profile.save();
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Code PIN enregistré avec succès.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final profile =
        HiveService.getProfileBox()
            .getAt(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          profile?.pinEnabled == true
              ? 'Modifier le code PIN'
              : 'Configurer le code PIN',
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            const Icon(
              Icons.lock,
              size: 90,
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              profile?.pinEnabled == true
                  ? 'Choisissez votre nouveau code PIN'
                  : 'Choisissez un code PIN à 4 chiffres',
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            TextField(
              controller:
                  pinController,
              keyboardType:
                  TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    'Code PIN',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  confirmController,
              keyboardType:
                  TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    'Confirmer le code PIN',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            DropdownButtonFormField<int>(
              value: autoLockMinutes,
              decoration:
                  const InputDecoration(
                labelText:
                    'Verrouillage automatique',
                border:
                    OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text(
                    'Immédiatement',
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(
                    '1 minute',
                  ),
                ),
                DropdownMenuItem(
                  value: 5,
                  child: Text(
                    '5 minutes',
                  ),
                ),
                DropdownMenuItem(
                  value: 15,
                  child: Text(
                    '15 minutes',
                  ),
                ),
                DropdownMenuItem(
                  value: 30,
                  child: Text(
                    '30 minutes',
                  ),
                ),
                DropdownMenuItem(
                  value: -1,
                  child: Text(
                    'Jamais',
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  autoLockMinutes =
                      value ?? 5;
                });
              },
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : savePin,
                child:
                    loading
                        ? const CircularProgressIndicator()
                        : Text(
                            profile?.pinEnabled ==
                                    true
                                ? 'Modifier le PIN'
                                : 'Activer le PIN',
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}