import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

enum Priority {
  low,
  medium,
  high;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case Priority.low:
        return l10n.translate('priority_low');
      case Priority.medium:
        return l10n.translate('priority_medium');
      case Priority.high:
        return l10n.translate('priority_high');
    }
  }
}
