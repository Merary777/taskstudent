import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/note_repository.dart';
import '../models/note_model.dart';
import 'edit_note_screen.dart';

class NoteDetailsScreen extends StatefulWidget {
  final String noteId;

  const NoteDetailsScreen({super.key, required this.noteId});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final NoteRepository _noteRepository = NoteRepository();
  Note? _note;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    setState(() => _isLoading = true);
    final notes = await _noteRepository.getNotes();
    try {
      _note = notes.firstWhere((n) => n.id == widget.noteId);
    } catch (_) {
      _note = null;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _deleteNote() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Nota'),
        content: const Text('¿Estás seguro de que deseas eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _noteRepository.deleteNote(widget.noteId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nota eliminada')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_note == null) {
      return const Scaffold(body: Center(child: Text('Nota no encontrada')));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditNoteScreen(note: _note!),
                ),
              );
              _loadNote();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _note!.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Actualizado: ${DateFormat('dd MMMM yyyy, HH:mm').format(_note!.updatedAt)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const Divider(height: 48),
            Text(
              _note!.content,
              style: const TextStyle(fontSize: 18, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
