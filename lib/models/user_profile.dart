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

  UserProfile({
    required this.displayName,
    required this.firstLaunch,
    required this.cloudConnected,
    this.email,
    this.photoUrl,
    this.appVersion = '1.0.0',
  });
}