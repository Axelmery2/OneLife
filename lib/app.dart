import 'package:flutter/material.dart';

import 'modules/dashboard/pages/dashboard_page.dart';



class OneLifeApp extends StatelessWidget {
  const OneLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneLife',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      home: const DashboardPage(),
    );
  }
}