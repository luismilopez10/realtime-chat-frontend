import 'package:shared_preferences/shared_preferences.dart';

import 'package:realtime_chat/providers/chat_settings_provider.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static UserFontSize _userFontSize = UserFontSize.Medium;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static UserFontSize get userFontSize {
    final userFontSize = _prefs.getInt('userFontSize') ?? _userFontSize;
    switch (userFontSize) {
      case 0:
        return UserFontSize.Small;
      case 1:
        return UserFontSize.Medium;
      case 2:
        return UserFontSize.Large;
      default:
        return UserFontSize.Medium;
    }
  }

  static set userFontSize(UserFontSize value) {
    _userFontSize = value;

    final int valueToStore;

    switch (value) {
      case UserFontSize.Small:
        valueToStore = 0;
      case UserFontSize.Medium:
        valueToStore = 1;
      case UserFontSize.Large:
        valueToStore = 2;
      default:
        valueToStore = 1;
    }

    _prefs.setInt('userFontSize', valueToStore);
  }
}
