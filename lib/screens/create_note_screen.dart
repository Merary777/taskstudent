import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/note_repository.dart';
import '../models/note_model.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteRepository = NoteRepository();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final newNote = Note(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await _noteRepository.addNote(newNote);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nota guardada')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
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
