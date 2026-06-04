import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../data/voice_note_repository.dart';
import '../models/voice_note_model.dart';

class CreateVoiceNoteScreen extends StatefulWidget {
  const CreateVoiceNoteScreen({super.key});

  @override
  State<CreateVoiceNoteScreen> createState() => _CreateVoiceNoteScreenState();
}

class _CreateVoiceNoteScreenState extends State<CreateVoiceNoteScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final VoiceNoteRepository _repository = VoiceNoteRepository();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speech.initialize();
    setState(() {});
  }

  void _listen() async {
    if (!_isListening) {
      var status = await Permission.microphone.status;
      if (status.isDenied) {
        status = await Permission.microphone.request();
      }

      if (status.isGranted) {
        bool available = await _speech.initialize();
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) => setState(() {
              _textController.text = val.recognizedWords;
            }),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de micrófono denegado')),
          );
        }
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _saveVoiceNote() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay texto transcrito para guardar')),
      );
      return;
    }

    final String title = _titleController.text.trim().isEmpty 
        ? 'Nota de Voz ${DateTime.now().hour}:${DateTime.now().minute}' 
        : _titleController.text.trim();

    final newNote = VoiceNote(
      id: const Uuid().v4(),
      title: title,
      transcribedText: _textController.text.trim(),
      createdAt: DateTime.now(),
    );

    await _repository.addVoiceNote(newNote);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota de voz guardada')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grabar Nota de Voz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'El texto transcrito aparecerá aquí...',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_isListening)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Escuchando...',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _listen,
                  backgroundColor: _isListening ? Colors.red : Colors.blue,
                  child: Icon(_isListening ? Icons.stop : Icons.mic),
                ),
                ElevatedButton.icon(
                  onPressed: _isListening ? null : _saveVoiceNote,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
