import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/screens/screens.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/chat_service.dart';
import 'package:realtime_chat/services/socket_service.dart';

void main() async {
  AppColors.whatsapp();
  // AppColors.telegram();

  WidgetsFlutterBinding.ensureInitialized();
  // Se Obtiene la configuración regional predeterminada del dispositivo
  String locale = PlatformDispatcher.instance.locale.toString();
  await initializeDateFormatting(locale, null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(
          //     seedColor: AppColors.instance.sendMessageColor),
          useMaterial3: true,
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}
