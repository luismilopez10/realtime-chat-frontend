import 'package:flutter/material.dart';

class AppColors {
  final Color green;
  final Color myMessageColor;
  final Color greenLight;
  final Color blueDark;
  final Color greyDark;
  final Color notMyMessageColor;
  final Color backgroundColor;
  final Color textColor;
  final Color messageSeen;

  static AppColors? _instance;

  AppColors._({
    required this.green,
    required this.myMessageColor,
    required this.greenLight,
    required this.blueDark,
    required this.greyDark,
    required this.notMyMessageColor,
    required this.backgroundColor,
    required this.textColor,
    required this.messageSeen,
  });

  factory AppColors.whatsapp() {
    _instance = AppColors._(
      green: const Color(0xFF25D366),
      myMessageColor: const Color(0xFF005C4B),
      greenLight: const Color(0xFF21C15F),
      blueDark: const Color(0xFF0B141B),
      greyDark: const Color(0xFF1F2C34),
      notMyMessageColor: const Color(0xFF202C33),
      backgroundColor: const Color(0xFF09141A),
      textColor: const Color(0xFFECE5DD),
      messageSeen: const Color(0xFF34B7F1),
    );
    return _instance!;
  }

  // factory AppColors.telegram() {
  //   _instance = AppColors._(
  //     green: const Color.fromARGB(255, 37, 162, 211),
  //     greenLight: const Color.fromARGB(255, 81, 33, 193),
  //     blueDark: const Color(0xFF0B141B),
  //   );
  //   return _instance!;
  // }

  static AppColors get instance {
    if (_instance == null) {
      throw Exception('AppColors has not been initialized');
    }
    return _instance!;
  }
}
