import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(title: l10n.translate('appearance')),
          SwitchListTile(
            title: Text(l10n.translate('dark_mode')),
            value: settings.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              settings.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            secondary: const Icon(Icons.brightness_4_outlined),
          ),
          const Divider(),
          _SettingsSection(title: l10n.translate('language')),
          ListTile(
            title: Text(l10n.translate('select_language')),
            subtitle: Text(L10n.getLanguageName(settings.locale.languageCode)),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, settings),
          ),
          const Divider(),
          const _SettingsSection(title: 'Account'),
          ListTile(
            title: Text(l10n.translate('logout'), style: const TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsService settings) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('select_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: L10n.all.map((locale) {
            return ListTile(
              title: Text(L10n.getLanguageName(locale.languageCode)),
              onTap: () {
                settings.setLocale(locale);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  const _SettingsSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
