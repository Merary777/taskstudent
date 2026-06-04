import 'package:flutter/material.dart';
import '../data/subject_repository.dart';
import '../models/subject_model.dart';
import 'create_subject_screen.dart';
import 'edit_subject_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final SubjectRepository _subjectRepository = SubjectRepository();
  List<Subject> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    final subjects = await _subjectRepository.getSubjects();
    setState(() {
      _subjects = subjects;
      _isLoading = false;
    });
  }

  Future<void> _deleteSubject(Subject subject) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Materia'),
        content: Text('¿Estás seguro de que deseas eliminar "${subject.name}"?'),
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
      await _subjectRepository.deleteSubject(subject.id);
      _loadSubjects();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Materia eliminada')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subjects.isEmpty
              ? const Center(child: Text('No hay materias creadas'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: subject.color,
                        ),
                        title: Text(subject.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => EditSubjectScreen(subject: subject),
                                  ),
                                );
                                _loadSubjects();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteSubject(subject),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateSubjectScreen()),
          );
          _loadSubjects();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
