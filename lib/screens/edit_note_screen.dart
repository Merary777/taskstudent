import 'package:flutter/material.dart';
import '../data/note_repository.dart';
import '../models/note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _noteRepository = NoteRepository();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _updateNote() async {
    if (_formKey.currentState!.validate()) {
      final updatedNote = widget.note.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        updatedAt: DateTime.now(),
      );

      await _noteRepository.updateNote(updatedNote);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nota actualizada')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _updateNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Título',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const Divider(),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe algo...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La nota no puede estar vacía';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
