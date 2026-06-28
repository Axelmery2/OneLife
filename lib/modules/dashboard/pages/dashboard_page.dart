import 'package:flutter/material.dart';

import '../widgets/dashboard_card.dart';

import '../../debts/pages/debt_page.dart';
import '../../creances/pages/creances_page.dart';
import '../../finances/pages/finances_page.dart';
import '../../finances/services/transaction_service.dart';
import '../../notes/pages/notes_page.dart';


import '../../savings/pages/savings_page.dart';

import '../../projects/pages/projects_page.dart';
import '../../calendar/pages/calendar_page.dart';
import '../../settings/pages/settings_page.dart';

import '../../../services/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../pages/pin_lock_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(
      this,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
      this,
    );

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state ==
        AppLifecycleState.resumed) {
      final profile =
          HiveService.getProfileBox()
              .getAt(0);

      if (profile == null) return;

      if (!profile.pinEnabled) return;

      if (profile.autoLockMinutes ==
          -1) return;

      if (profile.lastUnlockTime ==
          null) return;

      final minutes =
          DateTime.now()
              .difference(
                profile.lastUnlockTime!,
              )
              .inMinutes;

      if (minutes >=
          profile.autoLockMinutes) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const PinLockPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final solde =
        TransactionService.getSolde();

    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'OneLife',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
          ValueListenableBuilder(
  valueListenable:
      HiveService.getProfileBox()
          .listenable(),
  builder: (
    context,
    box,
    child,
  ) {
    final profile =
        box.getAt(0);

    return Text(
      'Bonjour ${profile?.displayName ?? "Utilisateur"} 👋',
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  },
),
            const SizedBox(height: 5),

            Text(
              'Bienvenue dans OneLife',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF1E40AF),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'SOLDE GLOBAL',
                    style: TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    '${solde.toStringAsFixed(0)} FCFA',
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 36,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                DashboardCard(
                  icon: Icons
                      .account_balance_wallet,
                  title: 'Finances',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FinancesPage(),
                      ),
                    );
                  },
                ),

               DashboardCard(
  icon: Icons.savings,
  title: 'Épargne',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const SavingsPage(),
      ),
    );
  },
),

                DashboardCard(
                  icon: Icons.handshake,
                  title: 'Dettes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const DebtsPage(),
                      ),
                    );
                  },
                ),

                DashboardCard(
                  icon: Icons.payments,
                  title: 'Créances',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CreancesPage(),
                      ),
                    );
                  },
                ),

                DashboardCard(
  icon: Icons.rocket_launch,
  title: 'Projets',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ProjectsPage(),
      ),
    );
  },
),

               DashboardCard(
  icon: Icons.note_alt,
  title: 'Notes',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotesPage(),
      ),
    );
  },
),

               DashboardCard(
  icon: Icons.calendar_month,
  title: 'Calendrier',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CalendarPage(),
      ),
    );
  },
),
                DashboardCard(
  icon: Icons.settings,
  title: 'Paramètres',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const SettingsPage(),
      ),
    );
  },
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}