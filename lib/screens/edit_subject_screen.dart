import 'package:flutter/material.dart';
import '../data/subject_repository.dart';
import '../models/subject_model.dart';

class EditSubjectScreen extends StatefulWidget {
  final Subject subject;

  const EditSubjectScreen({super.key, required this.subject});

  @override
  State<EditSubjectScreen> createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final _subjectRepository = SubjectRepository();
  late Color _selectedColor;

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.name);
    _selectedColor = widget.subject.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateSubject() async {
    if (_formKey.currentState!.validate()) {
      final updatedSubject = widget.subject.copyWith(
        name: _nameController.text.trim(),
        color: _selectedColor,
      );

      await _subjectRepository.updateSubject(updatedSubject);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Materia actualizada')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Materia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Materia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Selecciona un color:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedColor = color);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: _selectedColor == color
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateSubject,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
