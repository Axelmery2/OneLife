import 'package:flutter/material.dart';

import '../app.dart';
import '../models/user_profile.dart';
import '../services/hive_service.dart';

class WelcomePage extends StatefulWidget {
const WelcomePage({super.key});

@override
State<WelcomePage> createState() =>
_WelcomePageState();
}

class _WelcomePageState
extends State<WelcomePage> {
final TextEditingController
nameController =
TextEditingController();

int currentStep = 0;

Future<void> continueApp() async {
if (nameController.text
.trim()
.isEmpty) {
return;
}

final profile =
    HiveService
        .getProfileBox()
        .getAt(0);

if (profile != null) {
  profile.displayName =
      nameController.text.trim();

  profile.firstLaunch = false;

  profile.cloudConnected =
      false;

  await profile.save();
}

if (!mounted) return;

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) =>
        const OneLifeApp(),
  ),
);

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
child: currentStep == 0
? Column(
mainAxisAlignment:
MainAxisAlignment
.center,
children: [
Image.asset(
  'assets/images/logo_onelife.png',
  height: 140,
),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Bienvenue sur OneLife',
                    textAlign:
                        TextAlign
                            .center,
                    style:
                        TextStyle(
                      fontSize:
                          28,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    'Une seule application pour organiser votre vie.',
                    textAlign:
                        TextAlign
                            .center,
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  SizedBox(
                    width:
                        double
                            .infinity,
                    child:
                        ElevatedButton(
                      onPressed:
                          () {
                        setState(
                          () {
                            currentStep =
                                1;
                          },
                        );
                      },
                      child:
                          const Text(
                        'Commencer',
                      ),
                    ),
                  ),
                ],
              )
            : currentStep == 1
                ? Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      const Text(
                        'Comment souhaitez-vous commencer ?',
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            TextStyle(
                          fontSize:
                              24,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                        height:
                            40,
                      ),

                      SizedBox(
                        width: double
                            .infinity,
                        child:
                            ElevatedButton.icon(
                          icon:
                              const Icon(
                            Icons
                                .login,
                          ),
                          label:
                              const Text(
                            'Continuer avec Google',
                          ),
                          onPressed:
                              () {
                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(
                              const SnackBar(
                                content:
                                    Text(
                                  'Connexion Google bientôt disponible.',
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                        height:
                            15,
                      ),

                      SizedBox(
                        width: double
                            .infinity,
                        child:
                            OutlinedButton(
                          onPressed:
                              () {
                            setState(
                              () {
                                currentStep =
                                    2;
                              },
                            );
                          },
                          child:
                              const Text(
                            'Continuer sans compte',
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      const Text(
                        'Comment devons-nous vous appeler ?',
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            TextStyle(
                          fontSize:
                              24,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                        height:
                            30,
                      ),

                      TextField(
                        controller:
                            nameController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Votre nom',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(
                        height:
                            20,
                      ),

                      SizedBox(
                        width: double
                            .infinity,
                        child:
                            ElevatedButton(
                          onPressed:
                              continueApp,
                          child:
                              const Text(
                            'Continuer',
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