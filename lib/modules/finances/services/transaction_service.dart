import 'package:cloud_firestore/cloud_firestore.dart'
    hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../models/transaction.dart';

class TransactionService {
  static Box<Transaction> get box =>
      HiveService.getTransactionsBox();

  static final FirebaseFirestore
      _firestore =
      FirebaseFirestore.instance;

  static String get _uid =>
      FirebaseAuth
          .instance
          .currentUser
          ?.uid ??
      'guest';

  static CollectionReference?
      get _collection {
    if (FirebaseAuth
            .instance
            .currentUser ==
        null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(_uid)
        .collection(
          'transactions',
        );
  }

  static List<Transaction>
      getAllTransactions() {
    final transactions =
        box.values.toList();

    transactions.sort(
      (a, b) => b.createdAt
          .compareTo(
        a.createdAt,
      ),
    );

    return transactions;
  }

  static Transaction?
      getTransaction(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void>
      addTransaction(
    Transaction transaction,
  ) async {
    // Sauvegarde locale immédiate
    await box.put(
      transaction.id,
      transaction,
    );

    // Synchronisation cloud
    if (_collection != null) {
      _collection!
          .doc(
            transaction.id,
          )
          .set(
            transaction.toMap(),
          )
          .catchError((e) {
        print(
          'Erreur sync ajout transaction : $e',
        );
      });
    }
  }

  static Future<void>
      updateTransaction(
    Transaction transaction,
  ) async {
    // Mise à jour locale immédiate
    await box.put(
      transaction.id,
      transaction,
    );

    // Synchronisation cloud
    if (_collection != null) {
      _collection!
          .doc(
            transaction.id,
          )
          .set(
            transaction.toMap(),
          )
          .catchError((e) {
        print(
          'Erreur sync modification transaction : $e',
        );
      });
    }
  }

  static Future<void>
      deleteTransaction(
    String id,
  ) async {
    // Suppression locale immédiate
    await box.delete(id);

    // Suppression cloud
    if (_collection != null) {
      _collection!
          .doc(id)
          .delete()
          .catchError((e) {
        print(
          'Erreur suppression transaction : $e',
        );
      });
    }
  }

  static Future<void>
      syncFromFirestore() async {
    if (_collection == null) {
      return;
    }

    try {
      final snapshot =
          await _collection!.get();

      for (final doc
          in snapshot.docs) {
        final transaction =
            Transaction.fromMap(
          doc.data()
              as Map<String,
                  dynamic>,
        );

        await box.put(
          transaction.id,
          transaction,
        );
      }
    } catch (e) {
      print(
        'Erreur synchronisation transactions : $e',
      );
    }
  }

  static double
      getTotalRevenus() {
    return box.values
        .where(
          (t) =>
              t.type ==
              'revenu',
        )
        .fold(
          0.0,
          (sum, t) =>
              sum + t.amount,
        );
  }

  static double
      getTotalDepenses() {
    return box.values
        .where(
          (t) =>
              t.type ==
              'depense',
        )
        .fold(
          0.0,
          (sum, t) =>
              sum + t.amount,
        );
  }

  static double getSolde() {
    return getTotalRevenus() -
        getTotalDepenses();
  }

  static Future<void>
      clearAll() async {
    await box.clear();
  }
}