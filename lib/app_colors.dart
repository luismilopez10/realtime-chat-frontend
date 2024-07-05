import 'package:flutter/material.dart';

class AppColors {
  final Color appBarColor;
  final Color backgroundColor;
  final Color myMessageColor;
  final Color notMyMessageColor;
  final Color sendMessageColor;
  final Color textColor;
  final Color messageSeenColor;
  final Color textFieldBackgroundColor;
  final Color deactivatedColor;

  static AppColors? _instance;

  AppColors._({
    required this.appBarColor,
    required this.backgroundColor,
    required this.myMessageColor,
    required this.notMyMessageColor,
    required this.sendMessageColor,
    required this.textColor,
    required this.messageSeenColor,
    required this.textFieldBackgroundColor,
    required this.deactivatedColor,
  });

  factory AppColors.whatsapp() {
    _instance = AppColors._(
      // appBarColor: const Color(0xFF0B141B),
      appBarColor: const Color(0xFF1F2C34),
      backgroundColor: const Color(0xFF09141A),
      myMessageColor: const Color(0xFF005C4B),
      notMyMessageColor: const Color(0xFF202C33),
      sendMessageColor: const Color(0xFF21C15F),
      textColor: const Color(0xFFECE5DD),
      messageSeenColor: const Color(0xFF34B7F1),
      textFieldBackgroundColor: const Color(0xFF1F2C34),
      deactivatedColor: const Color(0xFF84959D),
    );
    return _instance!;
  }

  factory AppColors.telegram() {
    _instance = AppColors._(
      appBarColor: const Color(0xFF1F2C34),
      backgroundColor: const Color(0xFF09141A),
      myMessageColor: const Color(0xFF005C4B),
      notMyMessageColor: const Color(0xFF202C33),
      sendMessageColor: const Color(0xFF21C15F),
      textColor: const Color(0xFFECE5DD),
      messageSeenColor: const Color(0xFF34B7F1),
      textFieldBackgroundColor: const Color(0xFF1F2C34),
      deactivatedColor: const Color(0xFF84959D),
    );
    return _instance!;
  }

  static AppColors get instance {
    if (_instance == null) {
      throw Exception('AppColors has not been initialized');
    }
    return _instance!;
  }
}
