import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/providers/chat_settings_provider.dart';
import 'package:realtime_chat/screens/screens.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/chat_service.dart';
import 'package:realtime_chat/services/socket_service.dart';
import 'package:realtime_chat/share_preferences/share_preferences.dart';

void main() async {
  AppColors.whatsapp();
  // AppColors.telegram();

  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

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
        ChangeNotifierProvider(create: (_) => ChatSettingsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('es', 'ES'),
        ],
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
