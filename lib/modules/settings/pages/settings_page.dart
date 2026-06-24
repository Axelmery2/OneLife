import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user_profile.dart';
import '../../../services/hive_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../profile/pages/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {
  String version = '...';

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  Future<void> loadVersion() async {
    final info =
        await PackageInfo.fromPlatform();

    setState(() {
      version = info.version;
    });
  }
  

 
  Future<void> openWhatsApp(
  String message,
) async {
  final url = Uri.parse(
    'https://wa.me/2250565992019?text=${Uri.encodeComponent(message)}',
  );

  await launchUrl(
    url,
    mode:
        LaunchMode.externalApplication,
  );
}
Future<void> checkUpdate() async {
  try {
    print('Début vérification');

    final doc = await FirebaseFirestore
        .instance
        .collection('updates')
        .doc('app')
        .get();

    print('Document trouvé : ${doc.exists}');
    print(doc.data());

    final data = doc.data();

    if (data == null) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Erreur'),
          content: Text(
            'Aucune donnée trouvée dans Firestore.',
          ),
        ),
      );

      return;
    }

    final latestVersion =
        data['latestVersion'];

    final updateMessage =
        data['updateMessage'];

    final apkUrl =
        data['apkUrl'];

    final info =
        await PackageInfo.fromPlatform();

    final currentVersion =
        info.version;

    print(
      'Version actuelle : $currentVersion',
    );

    print(
      'Version Firebase : $latestVersion',
    );

    if (currentVersion ==
        latestVersion) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Vous utilisez déjà la dernière version.',
          ),
        ),
      );

      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          '🚀 Mise à jour disponible',
        ),
        content: Text(
          updateMessage,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
            ),
            child: const Text(
              'Plus tard',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(
                context,
              );

              await launchUrl(
                Uri.parse(apkUrl),
                mode: LaunchMode
                    .externalApplication,
              );
            },
            child: const Text(
              'Télécharger',
            ),
          ),
        ],
      ),
    );
  } catch (e) {
    print('Erreur : $e');

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Erreur',
        ),
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
}
@override
  Widget build(BuildContext context) {
    final profile =
    HiveService.getProfileBox()
        .getAt(0);
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

          ListTile(
  leading: const Icon(
    Icons.cloud_outlined,
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
  onTap: () {},
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

          Center(
  child: Text(
    profile?.displayName ??
        'Utilisateur',
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
    Icons.person,
  ),
  title: const Text(
    'Profil',
  ),
  subtitle: const Text(
    'Voir mon profil',
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ProfilePage(),
      ),
    );
  },
),

          ListTile(
  leading: const Icon(
    Icons.person_outline,
  ),
  title: const Text(
    'Modifier mon nom',
  ),
  subtitle: Text(
    profile?.displayName ??
        'Utilisateur',
  ),
  onTap: () async {
    final controller =
        TextEditingController(
      text:
          profile?.displayName,
    );

    await showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
        title: const Text(
          'Modifier le nom',
        ),
        content: TextField(
          controller:
              controller,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
            ),
            child: const Text(
              'Annuler',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (profile != null) {
                profile
                        .displayName =
                    controller.text;

                await profile
                    .save();
              }

              if (mounted) {
                setState(() {});
              }

              Navigator.pop(
                context,
              );
            },
            child: const Text(
              'Enregistrer',
            ),
          ),
        ],
      ),
    );
  },
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
    Icons.system_update,
  ),
  title: const Text(
    'Vérifier les mises à jour',
  ),
  subtitle: Text(
    'Version $version',
  ),
  onTap: checkUpdate,
),

       

 

         ListTile(
  leading: const Icon(
    Icons.support_agent,
  ),
  title: const Text(
    'Support WhatsApp',
  ),
  onTap: () {
    
    
    openWhatsApp(
      'Bonjour OneLife, j’ai besoin d’aide.',
    );
  },
),

ListTile(
  leading: const Icon(
    Icons.lightbulb_outline,
  ),
  title: const Text(
    'Proposer une amélioration',
  ),
  onTap: () {
    openWhatsApp(
      'Bonjour, j’ai une suggestion pour OneLife.',
    );
  },
),

ListTile(
  leading: const Icon(
    Icons.bug_report_outlined,
  ),
  title: const Text(
    'Signaler un bug',
  ),
  onTap: () {
    openWhatsApp(
      'Bonjour, je souhaite signaler un bug sur OneLife.',
    );
  },
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
      applicationName: 'OneLife',
      applicationVersion: version,
      applicationLegalese: '© OneLife',
    );
  },
),
],
      ),
    );
  }
}
  
