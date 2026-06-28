import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 10)
class UserProfile extends HiveObject {
  @HiveField(0)
  String displayName;

  @HiveField(1)
  bool firstLaunch;

  @HiveField(2)
  bool cloudConnected;

  @HiveField(3)
  String? email;

  @HiveField(4)
  String? photoUrl;

  @HiveField(5)
  String appVersion;

  // =========================
  // Sécurité
  // =========================

  @HiveField(6)
  bool pinEnabled;

  @HiveField(7)
  String? pinCode;

  // Temps avant redemande du PIN
  // 0 = immédiatement
  // -1 = jamais
  @HiveField(8)
  int autoLockMinutes;

  // Dernier déverrouillage réussi
  @HiveField(9)
  DateTime? lastUnlockTime;

  UserProfile({
    required this.displayName,
    required this.firstLaunch,
    required this.cloudConnected,
    this.email,
    this.photoUrl,
    this.appVersion = '1.0.0',

    // Sécurité
    this.pinEnabled = false,
    this.pinCode,

    // Verrouillage automatique
    this.autoLockMinutes = 5,
    this.lastUnlockTime,
  });
}