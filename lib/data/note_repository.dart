import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class NoteRepository {
  static const String _notesKey = 'notes';

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];
    return notesJson.map((n) => Note.fromJson(n)).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((n) => n.toJson()).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }

  Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.add(note);
    await saveNotes(notes);
  }

  Future<void> updateNote(Note updatedNote) async {
    final notes = await getNotes();
    final index = notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      await saveNotes(notes);
    }
  }

  Future<void> deleteNote(String id) async {
    final notes = await getNotes();
    notes.removeWhere((n) => n.id == id);
    await saveNotes(notes);
  }
}
