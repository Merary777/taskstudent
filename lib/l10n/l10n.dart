import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('es'),
    const Locale('en'),
    const Locale('fr'),
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'Español';
    }
  }
}
