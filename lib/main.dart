import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'services/settings_service.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsService(),
      child: const TaskStudentApp(),
    ),
  );
}

class TaskStudentApp extends StatelessWidget {
  const TaskStudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);

    return MaterialApp(
      title: 'TaskStudent',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
