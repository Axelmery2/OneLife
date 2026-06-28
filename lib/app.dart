import 'package:flutter/material.dart';

import 'modules/dashboard/pages/dashboard_page.dart';
import 'pages/pin_lock_page.dart';
import 'services/hive_service.dart';

class OneLifeApp extends StatelessWidget {
  const OneLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneLife',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const AppRouter(),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final profile =
        HiveService.getProfileBox().getAt(0);

    if (profile == null) {
      return const DashboardPage();
    }

    if (!profile.pinEnabled) {
      return const DashboardPage();
    }

    // Ne jamais verrouiller automatiquement
    if (profile.autoLockMinutes == -1) {
      return const DashboardPage();
    }

    // Jamais déverrouillé auparavant
    if (profile.lastUnlockTime == null) {
      return const PinLockPage();
    }

    final minutesSinceUnlock =
        DateTime.now()
            .difference(
              profile.lastUnlockTime!,
            )
            .inMinutes;

    // Temps dépassé → demander le PIN
    if (minutesSinceUnlock >=
        profile.autoLockMinutes) {
      return const PinLockPage();
    }

    // Sinon accès direct
    return const DashboardPage();
  }
}