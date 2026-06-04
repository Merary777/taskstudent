import 'package:shared_preferences/shared_preferences.dart';
import '../models/voice_note_model.dart';

class VoiceNoteRepository {
  static const String _voiceNotesKey = 'voice_notes';

  Future<List<VoiceNote>> getVoiceNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_voiceNotesKey) ?? [];
    return notesJson.map((n) => VoiceNote.fromJson(n)).toList();
  }

  Future<void> saveVoiceNotes(List<VoiceNote> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((n) => n.toJson()).toList();
    await prefs.setStringList(_voiceNotesKey, notesJson);
  }

  Future<void> addVoiceNote(VoiceNote note) async {
    final notes = await getVoiceNotes();
    notes.add(note);
    await saveVoiceNotes(notes);
  }

  Future<void> deleteVoiceNote(String id) async {
    final notes = await getVoiceNotes();
    notes.removeWhere((n) => n.id == id);
    await saveVoiceNotes(notes);
  }
}
