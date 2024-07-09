import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:realtime_chat/screens/screens.dart';
import 'package:realtime_chat/services/auth_service.dart';

class LoadingScreen extends StatelessWidget {
  static const String routerName = 'Loading';

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Cargando...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isAuthenticated = await authService.isLogged();

    if (isAuthenticated) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ContactsScreen(),
            transitionDuration: Duration(milliseconds: 0),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginScreen(),
            transitionDuration: Duration(milliseconds: 0),
          ));
    }
  }
}
