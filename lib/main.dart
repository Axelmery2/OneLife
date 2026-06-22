import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(DebtAdapter());
  }

  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CreanceAdapter());
  }

  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(TransactionAdapter());
  }

  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(NoteAdapter());
  }

  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(SavingAdapter());
  }

  if (!Hive.isAdapterRegistered(8)) {
  Hive.registerAdapter(
    ProjectExpenseAdapter(),
  );
}

  if (!Hive.isAdapterRegistered(6)) {
  Hive.registerAdapter(
    ProjectAdapter(),
  );
  Hive.registerAdapter(
  EventAdapter(),
);
}

Hive.registerAdapter(
  ProjectTaskAdapter(),
);
  await HiveService.init();

  runApp(
    const OneLifeApp(),
  );
}