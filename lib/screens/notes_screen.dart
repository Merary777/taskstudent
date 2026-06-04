import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/note_repository.dart';
import '../models/note_model.dart';
import '../l10n/app_localizations.dart';
import 'create_note_screen.dart';
import 'note_details_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteRepository _noteRepository = NoteRepository();
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await _noteRepository.getNotes();
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('notes')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? _buildEmptyState(l10n)
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return _buildNoteCard(note);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateNoteScreen()),
          );
          _loadNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            l10n.translate('empty_notes'),
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NoteDetailsScreen(noteId: note.id),
            ),
          );
          _loadNotes();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  note.content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('dd/MM/yy').format(note.updatedAt),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
