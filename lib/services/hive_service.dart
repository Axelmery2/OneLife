import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modules/debts/models/debt.dart';
import '../modules/creances/models/creance.dart';
import '../modules/finances/models/transaction.dart';
import '../modules/notes/models/note.dart';
import '../modules/savings/models/saving.dart';
import '../modules/projects/models/project.dart';
import '../modules/calendar/models/event.dart';
import '../models/user_profile.dart';

class HiveService {
  static String get currentUid =>
      FirebaseAuth.instance.currentUser?.uid ??
      'guest';

  static const String settingsBox = 'settings';
  static const String profileBox = 'profile';

  static const String transactionsBox =
      'transactions';

  static const String savingsBox =
      'savings';

  static const String debtsBox = 'debts';

  static const String receivablesBox =
      'receivables';

  static const String notesBox = 'notes';

  static const String projectsBox =
      'projects';

  static const String eventsBox = 'events';

  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }

    if (!Hive.isBoxOpen(settingsBox)) {
      await Hive.openBox(settingsBox);
    }

    if (!Hive.isBoxOpen(profileBox)) {
      await Hive.openBox<UserProfile>(
        profileBox,
      );
    }

    if (!Hive.isBoxOpen(
      '${transactionsBox}_$currentUid',
    )) {
      await Hive.openBox<Transaction>(
        '${transactionsBox}_$currentUid',
      );
    }

    if (!Hive.isBoxOpen(
      '${debtsBox}_$currentUid',
    )) {
      await Hive.openBox<Debt>(
        '${debtsBox}_$currentUid',
      );
    }

    if (!Hive.isBoxOpen(
      '${receivablesBox}_$currentUid',
    )) {
      await Hive.openBox<Creance>(
        '${receivablesBox}_$currentUid',
      );
    }

    if (!Hive.isBoxOpen(
      '${notesBox}_$currentUid',
    )) {
      await Hive.openBox<Note>(
        '${notesBox}_$currentUid',
      );
    }

    if (!Hive.isBoxOpen(
      '${savingsBox}_$currentUid',
    )) {
      await Hive.openBox<Saving>(
        '${savingsBox}_$currentUid',
      );
    }

    if (!Hive.isBoxOpen(
      '${projectsBox}_$currentUid',
    )) {
      await Hive.openBox<Project>(
        '${projectsBox}_$currentUid',
      );
    }

    if (!Hive.isBoxOpen(
      '${eventsBox}_$currentUid',
    )) {
      await Hive.openBox<Event>(
        '${eventsBox}_$currentUid',
      );
    }
  }

  static Box getSettingsBox() =>
      Hive.box(settingsBox);

  static Box<UserProfile>
      getProfileBox() =>
          Hive.box<UserProfile>(
            profileBox,
          );

  static Box<Transaction>
      getTransactionsBox() =>
          Hive.box<Transaction>(
            '${transactionsBox}_$currentUid',
          );

  static Box<Debt> getDebtsBox() =>
      Hive.box<Debt>(
        '${debtsBox}_$currentUid',
      );

  static Box<Creance>
      getReceivablesBox() =>
          Hive.box<Creance>(
            '${receivablesBox}_$currentUid',
          );

  static Box<Note> getNotesBox() =>
      Hive.box<Note>(
        '${notesBox}_$currentUid',
      );

  static Box<Saving>
      getSavingsBox() =>
          Hive.box<Saving>(
            '${savingsBox}_$currentUid',
          );

  static Box<Project>
      getProjectsBox() =>
          Hive.box<Project>(
            '${projectsBox}_$currentUid',
          );

  static Box<Event>
      getEventsBox() =>
          Hive.box<Event>(
            '${eventsBox}_$currentUid',
          );

  static Future<void> reset() async {
    await Hive.close();
    _initialized = false;
  }
}