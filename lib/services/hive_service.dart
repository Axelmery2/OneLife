import 'package:hive_flutter/hive_flutter.dart';

import '../modules/debts/models/debt.dart';
import '../modules/creances/models/creance.dart';
import '../modules/finances/models/transaction.dart';
import '../modules/notes/models/note.dart';
import '../modules/savings/models/saving.dart';
import '../modules/projects/models/project.dart';
import '../modules/calendar/models/event.dart';

class HiveService {
  static const String settingsBox = 'settings';
  static const String transactionsBox = 'transactions';
  static const String savingsBox = 'savings';
  static const String debtsBox = 'debts';
  static const String receivablesBox = 'receivables';
  static const String notesBox = 'notes';
  static const String projectsBox = 'projects';
  static const String eventsBox = 'events';

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    if (!Hive.isBoxOpen(settingsBox)) {
      await Hive.openBox(settingsBox);
    }

    if (!Hive.isBoxOpen(transactionsBox)) {
      await Hive.openBox<Transaction>(
        transactionsBox,
      );
    }

    if (!Hive.isBoxOpen(debtsBox)) {
      await Hive.openBox<Debt>(
        debtsBox,
      );
    }

    if (!Hive.isBoxOpen(receivablesBox)) {
      await Hive.openBox<Creance>(
        receivablesBox,
      );
    }

    if (!Hive.isBoxOpen(notesBox)) {
      await Hive.openBox<Note>(
        notesBox,
      );
    }

    if (!Hive.isBoxOpen(savingsBox)) {
      await Hive.openBox<Saving>(
        savingsBox,
      );
    }

    if (!Hive.isBoxOpen(projectsBox)) {
      await Hive.openBox<Project>(
  projectsBox,
);
    }

    if (!Hive.isBoxOpen(eventsBox)) {
  await Hive.openBox<Event>(
    eventsBox,
  );
}

    _initialized = true;
  }

  static Box getSettingsBox() =>
      Hive.box(settingsBox);

  static Box<Transaction>
      getTransactionsBox() =>
          Hive.box<Transaction>(
            transactionsBox,
          );

  static Box<Debt> getDebtsBox() =>
      Hive.box<Debt>(
        debtsBox,
      );

  static Box<Creance>
      getReceivablesBox() =>
          Hive.box<Creance>(
            receivablesBox,
          );

  static Box<Note> getNotesBox() =>
      Hive.box<Note>(
        notesBox,
      );

  static Box<Saving>
      getSavingsBox() =>
          Hive.box<Saving>(
            savingsBox,
          );
static Box<Project>
    getProjectsBox() =>
        Hive.box<Project>(
          projectsBox,
        );

  static Box getEventsBox() =>
      Hive.box(eventsBox);
}