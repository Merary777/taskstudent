import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/voice_note_repository.dart';
import '../models/voice_note_model.dart';
import '../l10n/app_localizations.dart';
import 'create_voice_note_screen.dart';

class VoiceNotesScreen extends StatefulWidget {
  const VoiceNotesScreen({super.key});

  @override
  State<VoiceNotesScreen> createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen> {
  final VoiceNoteRepository _repository = VoiceNoteRepository();
  List<VoiceNote> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await _repository.getVoiceNotes();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _deleteNote(String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('delete')),
        content: Text(l10n.translate('delete_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.translate('delete')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _repository.deleteVoiceNote(id);
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('voice_notes')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? _buildEmptyState(l10n)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return _buildVoiceNoteCard(note, l10n);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateVoiceNoteScreen()),
          );
          _loadNotes();
        },
        child: const Icon(Icons.mic),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mic_none, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            l10n.translate('empty_voice'),
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceNoteCard(VoiceNote note, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(note.transcribedText, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(note.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deleteNote(note.id),
        ),
        onTap: () => _showDetailsDialog(note),
      ),
    );
  }

  void _showDetailsDialog(VoiceNote note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(child: Text(note.transcribedText)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }
}
