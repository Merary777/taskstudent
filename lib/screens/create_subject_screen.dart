import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/subject_repository.dart';
import '../models/subject_model.dart';

class CreateSubjectScreen extends StatefulWidget {
  const CreateSubjectScreen({super.key});

  @override
  State<CreateSubjectScreen> createState() => _CreateSubjectScreenState();
}

class _CreateSubjectScreenState extends State<CreateSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectRepository = SubjectRepository();
  Color _selectedColor = Colors.blue;

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
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveSubject() async {
    if (_formKey.currentState!.validate()) {
      final newSubject = Subject(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        color: _selectedColor,
      );

      final success = await _subjectRepository.addSubject(newSubject);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Materia creada exitosamente')),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ya existe una materia con ese nombre'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Materia'),
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
                onPressed: _saveSubject,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Guardar Materia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
