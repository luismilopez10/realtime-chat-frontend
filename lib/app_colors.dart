import 'package:flutter/material.dart';

class AppColors {
  final Color primaryColor;
  final Color secondaryColor;
  final Color appBarColor;
  final Color backgroundColor;
  final Color myMessageColor;
  final Color notMyMessageColor;
  final Color sendMessageColor;
  final Color textColor;
  final Color messageTimeTextColor;
  final Color dateHeaderBackgroundColor;
  final Color dateHeaderTextColor;
  final Color messageSeenColor;
  final Color textFieldBackgroundColor;
  final Color deactivatedColor;

  static AppColors? _instance;

  AppColors._({
    required this.primaryColor,
    required this.secondaryColor,
    required this.appBarColor,
    required this.backgroundColor,
    required this.myMessageColor,
    required this.notMyMessageColor,
    required this.sendMessageColor,
    required this.textColor,
    required this.messageTimeTextColor,
    required this.dateHeaderBackgroundColor,
    required this.dateHeaderTextColor,
    required this.messageSeenColor,
    required this.textFieldBackgroundColor,
    required this.deactivatedColor,
  });

  factory AppColors.whatsapp() {
    _instance = AppColors._(
      primaryColor: const Color(0xFF21C15F),
      secondaryColor: const Color(0xFF34B7F1),
      appBarColor: const Color(0xFF1F2C34),
      backgroundColor: const Color(0xFF09141A),
      myMessageColor: const Color(0xFF134D37),
      notMyMessageColor: const Color(0xFF1D282E),
      sendMessageColor: const Color(0xFF21C063),
      textColor: const Color(0xFFF0F0F0),
      messageTimeTextColor: const Color(0xFFAAAAAA),
      dateHeaderBackgroundColor: const Color(0xFF1D282E),
      dateHeaderTextColor: const Color(0xFFBEBEBE),
      messageSeenColor: const Color(0xFF34B7F1),
      textFieldBackgroundColor: const Color(0xFF1F2C34),
      deactivatedColor: const Color(0xFF84959D),
    );
    return _instance!;
  }

  factory AppColors.telegram() {
    _instance = AppColors._(
      primaryColor: const Color(0xFF24A1DE),
      secondaryColor: const Color(0xFF34B7F1),
      appBarColor: const Color(0xFF1F2C34),
      backgroundColor: const Color(0xFF09141A),
      myMessageColor: const Color(0xFF166186),
      notMyMessageColor: const Color(0xFF1D282E),
      sendMessageColor: const Color(0xFF24A1DE),
      textColor: const Color(0xFFF0F0F0),
      messageTimeTextColor: const Color(0xFFAAAAAA),
      dateHeaderBackgroundColor: const Color(0xFF1D282E),
      dateHeaderTextColor: const Color(0xFFBEBEBE),
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
