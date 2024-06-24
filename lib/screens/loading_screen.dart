import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  static const String routerName = 'Loading';

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading'),
      ),
      body: const Center(
        child: Text('LoadingScreen'),
      ),
    );
  }
}
