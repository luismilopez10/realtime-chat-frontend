import 'package:flutter/material.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/screens/screens.dart';

void main() {
  AppColors.whatsapp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ContactsScreen(),
    );
  }
}
