import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'services/hive_service.dart';

import 'modules/debts/models/debt.dart';
import 'modules/creances/models/creance.dart';
import 'modules/finances/models/transaction.dart';
import 'modules/notes/models/note.dart';
import 'modules/savings/models/saving.dart';

import 'modules/projects/models/project.dart';
import 'modules/projects/models/project_task.dart';
import 'modules/projects/models/project_expense.dart';

import 'modules/calendar/models/event.dart';

import 'models/user_profile.dart';
import 'pages/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  // =========================
  // Enregistrement Hive
  // =========================

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(
      DebtAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(
      CreanceAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(
      TransactionAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(
      NoteAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(
      SavingAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(
      ProjectAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(
      ProjectTaskAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(
      ProjectExpenseAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(
      EventAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(
      UserProfileAdapter(),
    );
  }

  // =========================
  // Initialisation Hive
  // =========================

  await HiveService.init();

  final profileBox =
      HiveService.getProfileBox();

  if (profileBox.isEmpty) {
    await profileBox.add(
      UserProfile(
        displayName: '',
        firstLaunch: true,
        cloudConnected: false,
        email: null,
      ),
    );
  }

  final profile =
      profileBox.getAt(0);

  runApp(
    profile != null &&
            profile.firstLaunch
        ? const MaterialApp(
            debugShowCheckedModeBanner:
                false,
            home: WelcomePage(),
          )
        : const OneLifeApp(),
  );
}