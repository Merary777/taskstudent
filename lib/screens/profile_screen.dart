import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../data/task_repository.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _authService = AuthService();
  String _username = '';
  int _completed = 0;
  int _total = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final username = await _authService.getUsername();
    final displayName = await _authService.getDisplayName();
    final tasks = await TaskRepository().getTasks();
    setState(() {
      _username = username ?? 'Usuario';
      _nameController.text = displayName ?? _username;
      _total = tasks.length;
      _completed = tasks.where((t) => t.isCompleted).length;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isNotEmpty) {
      await _authService.updateDisplayName(_nameController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('save'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('profile')),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: l10n.translate('display_name'),
                      border: const OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text('@$_username', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildProfileItem(Icons.task_alt, l10n.translate('completed_tasks_label'), '$_completed'),
                  _buildProfileItem(Icons.list, l10n.translate('total_tasks'), '$_total'),
                  _buildProfileItem(Icons.calendar_today, l10n.translate('joined_date'), l10n.translate('today')),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
