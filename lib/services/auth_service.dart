import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_profile.dart';

import '../modules/debts/services/debt_service.dart';
import '../modules/creances/services/creance_service.dart';
import '../modules/notes/services/note_service.dart';
import '../modules/savings/services/saving_service.dart';
import '../modules/projects/services/project_service.dart';
import '../modules/finances/services/transaction_service.dart';
import '../modules/calendar/services/event_service.dart';

import 'hive_service.dart';

class AuthService {
  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final GoogleSignIn _googleSignIn =
      GoogleSignIn();

  static User? get currentUser =>
      _auth.currentUser;

  static bool get isLoggedIn =>
      _auth.currentUser != null;

  static Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account =
          await _googleSignIn.signIn();

      if (account == null) {
        return null;
      }

      final GoogleSignInAuthentication auth =
          await account.authentication;

      final credential =
          GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCredential =
          await _auth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;

      if (user == null) {
        return null;
      }

      // Initialisation Hive
      await HiveService.init();

      // Ouvre les boxes du compte connecté
      await HiveService.openUserBoxes();

      // Synchronisation
      try {
        await DebtService.syncFromFirestore();
        await CreanceService.syncFromFirestore();
        await NoteService.syncFromFirestore();
        await SavingService.syncFromFirestore();
        await ProjectService.syncFromFirestore();
        await TransactionService.syncFromFirestore();
        await EventService.syncFromFirestore();
      } catch (e) {
        print(
          'Erreur synchronisation : $e',
        );
      }

      // Mise à jour Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'displayName':
            user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl':
            user.photoURL ?? '',
        'createdAt':
            FieldValue.serverTimestamp(),
        'lastLogin':
            FieldValue.serverTimestamp(),
        'appVersion': '1.0.0',
      }, SetOptions(merge: true));

      final box =
          HiveService.getProfileBox();

      UserProfile profile;

      if (box.isEmpty) {
        profile = UserProfile(
          displayName:
              user.displayName ??
                  'Utilisateur',
          firstLaunch: false,
          cloudConnected: true,
          email: user.email,
          photoUrl: user.photoURL,
          appVersion: '1.0.0',
        );

        await box.add(profile);
      } else {
        profile = box.getAt(0)!;

        profile.displayName =
            user.displayName ??
                profile.displayName;

        profile.email = user.email;

        profile.photoUrl =
            user.photoURL;

        profile.cloudConnected = true;

        profile.firstLaunch = false;

        await profile.save();
      }

      return user;
    } catch (e) {
      print(
        'Erreur Google Sign-In : $e',
      );

      return null;
    }
  }

  static Future<void> signOut() async {
    final box =
        HiveService.getProfileBox();

    if (box.isNotEmpty) {
      final profile = box.getAt(0);

      if (profile != null) {
        profile.cloudConnected =
            false;

        profile.pinEnabled = false;
        profile.pinCode = null;

        await profile.save();
      }
    }

    await _googleSignIn.signOut();
    await _auth.signOut();

    // Retour au mode invité
    await HiveService.reset();
    await HiveService.init();
    await HiveService.openUserBoxes();
  }
}