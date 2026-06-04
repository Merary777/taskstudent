import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../data/task_repository.dart';
import '../data/subject_repository.dart';
import '../models/task_model.dart';
import '../models/priority.dart';
import '../models/subject_model.dart';
import '../l10n/app_localizations.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _taskRepository = TaskRepository();
  final _subjectRepository = SubjectRepository();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  Priority _selectedPriority = Priority.medium;
  String? _selectedSubjectId;
  List<Subject> _subjects = [];
  bool _isLoadingSubjects = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final subjects = await _subjectRepository.getSubjects();
    setState(() {
      _subjects = subjects;
      if (subjects.isNotEmpty) {
        _selectedSubjectId = subjects.first.id;
      }
      _isLoadingSubjects = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    final l10n = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      if (_selectedSubjectId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una materia')),
        );
        return;
      }

      final newTask = Task(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        subjectId: _selectedSubjectId!,
        priority: _selectedPriority,
        dueDate: _selectedDate,
        createdAt: DateTime.now(),
      );

      await _taskRepository.addTask(newTask);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.translate('save'))),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Tarea'),
      ),
      body: _isLoadingSubjects
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.translate('user_required'); // Reusing for title
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSubjectId,
                      decoration: InputDecoration(
                        labelText: l10n.translate('subjects'),
                        border: const OutlineInputBorder(),
                      ),
                      items: _subjects.map((Subject subject) {
                        return DropdownMenuItem<String>(
                          value: subject.id,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: subject.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(subject.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedSubjectId = value);
                      },
                      validator: (value) => value == null ? 'Selecciona una materia' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Priority>(
                      value: _selectedPriority,
                      decoration: InputDecoration(
                        labelText: l10n.translate('tasks_by_priority'),
                        border: const OutlineInputBorder(),
                      ),
                      items: Priority.values.map((Priority priority) {
                        return DropdownMenuItem<Priority>(
                          value: priority,
                          child: Text(priority.getLocalizedName(context).toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedPriority = value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Fecha de entrega'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                      trailing: const Icon(Icons.calendar_today),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(l10n.translate('save')),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
