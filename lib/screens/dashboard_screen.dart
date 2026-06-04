import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/task_repository.dart';
import '../data/subject_repository.dart';
import '../data/note_repository.dart';
import '../data/voice_note_repository.dart';
import '../models/task_model.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';
import 'tasks_screen.dart';
import 'subjects_screen.dart';
import 'notes_screen.dart';
import 'voice_notes_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TaskRepository _taskRepo = TaskRepository();
  final SubjectRepository _subjectRepo = SubjectRepository();
  final NoteRepository _noteRepo = NoteRepository();
  final VoiceNoteRepository _voiceNoteRepo = VoiceNoteRepository();

  int _pendingTasksCount = 0;
  int _totalSubjects = 0;
  int _totalNotes = 0;
  int _totalVoiceNotes = 0;
  List<Task> _upcomingTasks = [];
  String _displayName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final tasks = await _taskRepo.getTasks();
    final subjects = await _subjectRepo.getSubjects();
    final notes = await _noteRepo.getNotes();
    final voiceNotes = await _voiceNoteRepo.getVoiceNotes();
    final name = await AuthService().getDisplayName();

    final now = DateTime.now();
    final upcoming = tasks
        .where((t) => !t.isCompleted && t.dueDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    setState(() {
      _pendingTasksCount = tasks.where((t) => !t.isCompleted).length;
      _totalSubjects = subjects.length;
      _totalNotes = notes.length;
      _totalVoiceNotes = voiceNotes.length;
      _upcomingTasks = upcoming.take(3).toList();
      _displayName = name ?? 'Estudiante';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ).then((_) => _loadData()),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ).then((_) => _loadData()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('welcome', params: {'name': _displayName}),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.translate('what_to_do')),
                    const SizedBox(height: 24),
                    _buildStatGrid(l10n),
                    const SizedBox(height: 32),
                    _buildSectionTitle(l10n.translate('quick_access')),
                    const SizedBox(height: 12),
                    _buildQuickAccess(l10n),
                    const SizedBox(height: 32),
                    _buildSectionTitle(l10n.translate('upcoming_tasks')),
                    const SizedBox(height: 12),
                    _buildUpcomingTasks(l10n),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStatGrid(AppLocalizations l10n) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard(l10n.translate('tasks'), '$_pendingTasksCount ${l10n.translate('pending_tasks')}', Icons.task_alt, Colors.blue),
        _buildStatCard(l10n.translate('subjects'), '$_totalSubjects ${l10n.translate('registered_subjects')}', Icons.book_outlined, Colors.orange),
        _buildStatCard(l10n.translate('notes'), '$_totalNotes ${l10n.translate('saved_notes')}', Icons.note_alt_outlined, Colors.green),
        _buildStatCard(l10n.translate('voice_notes'), '$_totalVoiceNotes ${l10n.translate('recorded_voice')}', Icons.mic_none, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: color.withAlpha((0.1 * 255).toInt()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccess(AppLocalizations l10n) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildQuickCard(l10n.translate('tasks'), Icons.list_alt, Colors.blue, const TasksScreen()),
          _buildQuickCard(l10n.translate('subjects'), Icons.category_outlined, Colors.orange, const SubjectsScreen()),
          _buildQuickCard(l10n.translate('statistics'), Icons.bar_chart, Colors.red, const StatisticsScreen()),
          _buildQuickCard(l10n.translate('notes'), Icons.edit_note, Colors.green, const NotesScreen()),
          _buildQuickCard(l10n.translate('voice_notes'), Icons.record_voice_over, Colors.purple, const VoiceNotesScreen()),
        ],
      ),
    );
  }

  Widget _buildQuickCard(String title, IconData icon, Color color, Widget target) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => target),
        ).then((_) => _loadData()),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingTasks(AppLocalizations l10n) {
    if (_upcomingTasks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text(l10n.translate('no_upcoming'))),
        ),
      );
    }

    return Column(
      children: _upcomingTasks.map((task) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.event, color: Colors.blue),
            title: Text(task.title),
            subtitle: Text(l10n.translate('due_date', params: {'date': DateFormat('dd/MM/yyyy').format(task.dueDate)})),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TasksScreen()),
            ).then((_) => _loadData()),
          ),
        );
      }).toList(),
    );
  }
}
