import 'package:flutter/material.dart';

import '../../../services/hive_service.dart';
import '../../../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile =
        HiveService.getProfileBox()
            .getAt(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon profil',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),

          const SizedBox(height: 15),

          Center(
            child: Text(
              profile?.displayName ??
                  'Utilisateur',
              style: const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              profile?.email ??
                  'Aucun email',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.cloud,
              ),
              title: const Text(
                'Compte Cloud',
              ),
              subtitle: Text(
                profile?.cloudConnected ==
                        true
                    ? 'Connecté'
                    : 'Non connecté',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.person_outline,
              ),
              title: const Text(
                'Nom',
              ),
              subtitle: Text(
                profile?.displayName ??
                    'Utilisateur',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.email_outlined,
              ),
              title: const Text(
                'Email',
              ),
              subtitle: Text(
                profile?.email ??
                    'Aucun email',
              ),
            ),
          ),

          Card(
  child: ListTile(
    leading: const Icon(
      Icons.cloud_sync,
    ),
    title: const Text(
      'Synchroniser mes données',
    ),
    subtitle: const Text(
      'Disponible après connexion',
    ),
    onTap: () {},
  ),
),

Card(
  child: ListTile(
    leading: const Icon(
      Icons.login,
    ),
    title: const Text(
      'Se connecter avec Google',
    ),
    subtitle: const Text(
      'Sauvegarder et restaurer vos données',
    ),
   onTap: () async {
  final user = await AuthService.signInWithGoogle();

  if (user == null) return;

  final profile =
      HiveService.getProfileBox().getAt(0);

  if (profile != null) {
    profile.displayName =
        user.displayName ?? "Utilisateur";

    profile.email = user.email;

    profile.photoUrl = user.photoURL;

    profile.cloudConnected = true;

    await profile.save();
  }

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Bienvenue ${user.displayName ?? user.email}",
      ),
    ),
  );

  (context as Element).markNeedsBuild();
},
  ),
),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.photo_camera,
              ),
              title: const Text(
                'Photo de profil',
              ),
              subtitle: const Text(
                'Disponible bientôt',
              ),
            ),
          ),
        ],
      ),
    );
  }
}