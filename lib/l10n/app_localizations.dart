import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'es': {
      'login_title': 'TaskStudent',
      'user_label': 'Usuario',
      'password_label': 'Contraseña',
      'login_button': 'Iniciar Sesión',
      'login_error': 'Usuario o contraseña incorrectos',
      'user_required': 'Por favor ingresa tu usuario',
      'password_required': 'Por favor ingresa tu contraseña',
      'welcome': '¡Bienvenido, {name}!',
      'what_to_do': 'Aquí tienes un resumen de tu actividad.',
      'tasks': 'Tareas',
      'subjects': 'Materias',
      'notes': 'Notas',
      'voice_notes': 'Notas de Voz',
      'settings': 'Ajustes',
      'profile': 'Perfil',
      'statistics': 'Estadísticas',
      'logout': 'Cerrar Sesión',
      'pending_tasks': 'tareas pendientes',
      'registered_subjects': 'materias registradas',
      'saved_notes': 'notas guardadas',
      'recorded_voice': 'grabadas',
      'quick_access': 'Accesos Rápidos',
      'upcoming_tasks': 'Próximas Tareas',
      'no_upcoming': 'No hay tareas próximas.',
      'due_date': 'Vence: {date}',
      'edit_profile': 'Editar Perfil',
      'display_name': 'Nombre a mostrar',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'delete': 'Eliminar',
      'edit': 'Editar',
      'priority_high': 'Alta',
      'priority_medium': 'Media',
      'priority_low': 'Baja',
      'language': 'Idioma',
      'appearance': 'Apariencia',
      'dark_mode': 'Modo Oscuro',
      'select_language': 'Seleccionar Idioma',
      'empty_tasks': 'No tienes tareas pendientes',
      'empty_notes': 'Aún no tienes notas',
      'empty_voice': 'No hay notas de voz grabadas',
      'search_hint': 'Buscar tareas...',
      'productivity': 'Productividad',
      'completed_tasks_label': 'de tareas completadas',
      'tasks_progress': 'Progreso de Tareas',
      'tasks_by_priority': 'Tareas por Prioridad',
      'total_tasks': 'Total de Tareas',
      'joined_date': 'Fecha de Ingreso',
      'today': 'Hoy',
      'delete_confirmation': '¿Estás seguro de que deseas eliminar esto?',
    },
    'en': {
      'login_title': 'TaskStudent',
      'user_label': 'Username',
      'password_label': 'Password',
      'login_button': 'Login',
      'login_error': 'Incorrect username or password',
      'user_required': 'Please enter your username',
      'password_required': 'Please enter your password',
      'welcome': 'Welcome, {name}!',
      'what_to_do': 'Here is a summary of your activity.',
      'tasks': 'Tasks',
      'subjects': 'Subjects',
      'notes': 'Notes',
      'voice_notes': 'Voice Notes',
      'settings': 'Settings',
      'profile': 'Profile',
      'statistics': 'Statistics',
      'logout': 'Logout',
      'pending_tasks': 'pending tasks',
      'registered_subjects': 'registered subjects',
      'saved_notes': 'saved notes',
      'recorded_voice': 'recorded',
      'quick_access': 'Quick Access',
      'upcoming_tasks': 'Upcoming Tasks',
      'no_upcoming': 'No upcoming tasks.',
      'due_date': 'Due: {date}',
      'edit_profile': 'Edit Profile',
      'display_name': 'Display Name',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'priority_high': 'High',
      'priority_medium': 'Medium',
      'priority_low': 'Low',
      'language': 'Language',
      'appearance': 'Appearance',
      'dark_mode': 'Dark Mode',
      'select_language': 'Select Language',
      'empty_tasks': 'No pending tasks',
      'empty_notes': 'No notes yet',
      'empty_voice': 'No voice notes recorded',
      'search_hint': 'Search tasks...',
      'productivity': 'Productivity',
      'completed_tasks_label': 'of tasks completed',
      'tasks_progress': 'Tasks Progress',
      'tasks_by_priority': 'Tasks by Priority',
      'total_tasks': 'Total Tasks',
      'joined_date': 'Joined Date',
      'today': 'Today',
      'delete_confirmation': 'Are you sure you want to delete this?',
    },
    'fr': {
      'login_title': 'TaskStudent',
      'user_label': 'Utilisateur',
      'password_label': 'Mot de passe',
      'login_button': 'Connexion',
      'login_error': 'Utilisateur ou mot de passe incorrect',
      'user_required': 'Veuillez entrer votre utilisateur',
      'password_required': 'Veuillez entrer votre mot de passe',
      'welcome': 'Bienvenue, {name} !',
      'what_to_do': 'Voici un résumé de votre activité.',
      'tasks': 'Tâches',
      'subjects': 'Matières',
      'notes': 'Notes',
      'voice_notes': 'Notes Vocales',
      'settings': 'Paramètres',
      'profile': 'Profil',
      'statistics': 'Statistiques',
      'logout': 'Déconnexion',
      'pending_tasks': 'tâches en attente',
      'registered_subjects': 'matières enregistrées',
      'saved_notes': 'notes sauvegardées',
      'recorded_voice': 'enregistrées',
      'quick_access': 'Accès Rapide',
      'upcoming_tasks': 'Tâches à Venir',
      'no_upcoming': 'Pas de tâches à venir.',
      'due_date': 'Échéance : {date}',
      'edit_profile': 'Modifier le Profil',
      'display_name': 'Nom d\'affichage',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      'priority_high': 'Haute',
      'priority_medium': 'Moyenne',
      'priority_low': 'Faible',
      'language': 'Langue',
      'appearance': 'Apparence',
      'dark_mode': 'Mode Sombre',
      'select_language': 'Choisir la Langue',
      'empty_tasks': 'Pas de tâches en attente',
      'empty_notes': 'Pas encore de notes',
      'empty_voice': 'Pas de notes vocales enregistrées',
      'search_hint': 'Rechercher des tâches...',
      'productivity': 'Productivité',
      'completed_tasks_label': 'des tâches terminées',
      'tasks_progress': 'Progression des Tâches',
      'tasks_by_priority': 'Tâches par Priorité',
      'total_tasks': 'Total des Tâches',
      'joined_date': 'Date d\'inscription',
      'today': 'Aujourd\'hui',
      'delete_confirmation': 'Êtes-vous sûr de vouloir supprimer ceci ?',
    },
  };

  String translate(String key, {Map<String, String>? params}) {
    String value = _localizedValues[locale.languageCode]?[key] ?? key;
    if (params != null) {
      params.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    return value;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => Future.value(AppLocalizations(locale));

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
