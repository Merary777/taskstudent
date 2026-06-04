import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/task_repository.dart';
import '../data/subject_repository.dart';
import '../models/task_model.dart';
import '../models/priority.dart';
import '../models/subject_model.dart';
import '../l10n/app_localizations.dart';
import 'create_task_screen.dart';
import 'task_details_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

enum SortOption { dueDate, createdAt, priority, title }

class _TasksScreenState extends State<TasksScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  final SubjectRepository _subjectRepository = SubjectRepository();
  
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  List<Subject> _subjects = [];
  bool _isLoading = true;

  // Search and Filters
  final TextEditingController _searchController = TextEditingController();
  bool? _filterCompleted;
  Priority? _filterPriority;
  String? _filterSubjectId;
  SortOption _currentSort = SortOption.dueDate;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final tasks = await _taskRepository.getTasks();
    final subjects = await _subjectRepository.getSubjects();
    setState(() {
      _allTasks = tasks;
      _subjects = subjects;
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    
    List<Task> filtered = _allTasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(query);
      final matchesStatus = _filterCompleted == null || task.isCompleted == _filterCompleted;
      final matchesPriority = _filterPriority == null || task.priority == _filterPriority;
      final matchesSubject = _filterSubjectId == null || task.subjectId == _filterSubjectId;
      
      return matchesSearch && matchesStatus && matchesPriority && matchesSubject;
    }).toList();

    // Apply Sorting
    switch (_currentSort) {
      case SortOption.dueDate:
        filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case SortOption.createdAt:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.priority:
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortOption.title:
        filtered.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }

    setState(() {
      _filteredTasks = filtered;
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _filterCompleted = null;
      _filterPriority = null;
      _filterSubjectId = null;
      _currentSort = SortOption.dueDate;
    });
    _applyFilters();
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high: return Colors.red;
      case Priority.medium: return Colors.orange;
      case Priority.low: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('tasks')),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.translate('search_hint'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          if (_filterCompleted != null || _filterPriority != null || _filterSubjectId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Filtros activos', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(onPressed: _clearFilters, child: Text(l10n.translate('cancel'))),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                    ? _buildEmptyState(l10n)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredTasks.length,
                        itemBuilder: (context, index) {
                          return _buildTaskCard(_filteredTasks[index], l10n);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
          );
          _loadInitialData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filtrar Tareas', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  const Text('Estado'),
                  SegmentedButton<bool?>(
                    segments: [
                      const ButtonSegment(value: null, label: Text('Todos')),
                      ButtonSegment(value: false, label: Text(l10n.translate('pending_tasks'))),
                      const ButtonSegment(value: true, label: Text('Completadas')),
                    ],
                    selected: {_filterCompleted},
                    onSelectionChanged: (val) {
                      setModalState(() => _filterCompleted = val.first);
                      _applyFilters();
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.translate('tasks_by_priority')),
                  DropdownButton<Priority?>(
                    isExpanded: true,
                    value: _filterPriority,
                    hint: const Text('Todas las prioridades'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas')),
                      ...Priority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.getLocalizedName(context).toUpperCase()))),
                    ],
                    onChanged: (val) {
                      setModalState(() => _filterPriority = val);
                      _applyFilters();
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.translate('subjects')),
                  DropdownButton<String?>(
                    isExpanded: true,
                    value: _filterSubjectId,
                    hint: const Text('Todas las materias'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas')),
                      ..._subjects.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))),
                    ],
                    onChanged: (val) {
                      setModalState(() => _filterSubjectId = val);
                      _applyFilters();
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.translate('save')),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Fecha de entrega'),
              leading: Radio<SortOption>(
                value: SortOption.dueDate,
                groupValue: _currentSort,
                onChanged: (val) {
                  setState(() => _currentSort = val!);
                  _applyFilters();
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Fecha de creación'),
              leading: Radio<SortOption>(
                value: SortOption.createdAt,
                groupValue: _currentSort,
                onChanged: (val) {
                  setState(() => _currentSort = val!);
                  _applyFilters();
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Prioridad'),
              leading: Radio<SortOption>(
                value: SortOption.priority,
                groupValue: _currentSort,
                onChanged: (val) {
                  setState(() => _currentSort = val!);
                  _applyFilters();
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Alfabético (A-Z)'),
              leading: Radio<SortOption>(
                value: SortOption.title,
                groupValue: _currentSort,
                onChanged: (val) {
                  setState(() => _currentSort = val!);
                  _applyFilters();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            l10n.translate('empty_tasks'),
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, AppLocalizations l10n) {
    final subject = _subjects.firstWhere((s) => s.id == task.subjectId, orElse: () => Subject(id: '', name: 'N/A', color: Colors.grey));
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) async {
            await _taskRepository.toggleTaskCompletion(task.id);
            _loadInitialData();
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.name,
              style: TextStyle(color: subject.color, fontWeight: FontWeight.w600),
            ),
            Text(l10n.translate('due_date', params: {'date': DateFormat('dd/MM/yyyy').format(task.dueDate)})),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getPriorityColor(task.priority).withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getPriorityColor(task.priority)),
          ),
          child: Text(
            task.priority.getLocalizedName(context).toUpperCase(),
            style: TextStyle(
              color: _getPriorityColor(task.priority),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TaskDetailsScreen(taskId: task.id)),
          );
          _loadInitialData();
        },
      ),
    );
  }
}
