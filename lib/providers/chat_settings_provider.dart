import 'package:flutter/material.dart';

import 'package:emoji_regex/emoji_regex.dart';
import 'package:realtime_chat/share_preferences/share_preferences.dart';

enum UserFontSize {
  Small,
  Medium,
  Large,
}

class ChatSettingsProvider extends ChangeNotifier {
  double getTextFontSize(String text) {
    final userFontSize = Preferences.userFontSize;

    switch (userFontSize) {
      case UserFontSize.Small:
        return _getSmallFontSize(text);
      case UserFontSize.Medium:
        return _getMediumFontSize(text);
      case UserFontSize.Large:
        return _getLargeFontSize(text);
    }
  }

  bool _isOnlyEmojis(String text) {
    final emojiRegExp = emojiRegex();
    final emojiMatches = emojiRegExp.allMatches(text);

    return emojiMatches.length == text.runes.length;
  }

  double _getSmallFontSize(String text) {
    if (!_isOnlyEmojis(text)) {
      return 16.0;
    }

    switch (text.runes.length) {
      case 1:
        return 30.0;
      case 2:
        return 26.0;
      case 3:
        return 24.0;
      default:
        return 20.0;
    }
  }

  double _getMediumFontSize(String text) {
    if (!_isOnlyEmojis(text)) {
      return 18.0;
    }

    switch (text.runes.length) {
      case 1:
        return 34.0;
      case 2:
        return 30.0;
      case 3:
        return 28.0;
      default:
        return 24.0;
    }
  }

  double _getLargeFontSize(String text) {
    if (!_isOnlyEmojis(text)) {
      return 22.0;
    }

    switch (text.runes.length) {
      case 1:
        return 40.0;
      case 2:
        return 36.0;
      case 3:
        return 32.0;
      default:
        return 30.0;
    }
  }
}
