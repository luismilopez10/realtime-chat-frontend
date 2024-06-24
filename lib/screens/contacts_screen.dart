import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  static const String routerName = 'Home';

  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}
