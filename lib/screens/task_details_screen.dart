import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/task_repository.dart';
import '../data/subject_repository.dart';
import '../models/task_model.dart';
import '../models/priority.dart';
import '../models/subject_model.dart';
import 'edit_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  final SubjectRepository _subjectRepository = SubjectRepository();
  Task? _task;
  Subject? _subject;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final tasks = await _taskRepository.getTasks();
    try {
      _task = tasks.firstWhere((t) => t.id == widget.taskId);
      if (_task != null) {
        _subject = await _subjectRepository.getSubjectById(_task!.subjectId);
      }
    } catch (_) {
      _task = null;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
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
      await _taskRepository.deleteTask(widget.taskId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea eliminada')),
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

    if (_task == null) {
      return const Scaffold(body: Center(child: Text('Tarea no encontrada')));
    }

    final dateFormat = DateFormat('dd MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Tarea'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditTaskScreen(task: _task!),
                ),
              );
              _loadData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _task!.isCompleted,
                  onChanged: (value) async {
                    await _taskRepository.toggleTaskCompletion(_task!.id);
                    _loadData();
                  },
                ),
                Expanded(
                  child: Text(
                    _task!.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: _task!.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoRow(
              Icons.book_outlined,
              'Materia',
              _subject?.name ?? 'Sin materia',
              color: _subject?.color,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.priority_high,
              'Prioridad',
              _task!.priority.name.toUpperCase(),
              color: _getPriorityColor(_task!.priority),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.calendar_today,
              'Fecha de entrega',
              dateFormat.format(_task!.dueDate),
            ),
            const Divider(height: 48),
            Text(
              'Descripción',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _task!.description.isEmpty
                  ? 'Sin descripción'
                  : _task!.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
