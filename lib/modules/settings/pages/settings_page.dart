import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paramètres',
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),

          const CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Center(
            child: Text(
              'Utilisateur OneLife',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          ListTile(
            leading: const Icon(
              Icons.person_outline,
            ),
            title: const Text(
              'Profil',
            ),
            subtitle: const Text(
              'Informations utilisateur',
            ),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(
              Icons.dark_mode,
            ),
            title: const Text(
              'Mode sombre',
            ),
            subtitle: const Text(
              'Disponible en V2',
            ),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(
              Icons.backup,
            ),
            title: const Text(
              'Sauvegarde',
            ),
            subtitle: const Text(
              'Disponible en V2',
            ),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(
              Icons.info_outline,
            ),
            title: const Text(
              'À propos',
            ),
            subtitle: const Text(
              'OneLife V1',
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName:
                    'OneLife',
                applicationVersion:
                    '1.0.0',
                applicationLegalese:
                    '© OneLife',
              );
            },
          ),
        ],
      ),
    );
  }
}