import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/task_repository.dart';
import '../models/priority.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final TaskRepository _taskRepo = TaskRepository();
  int _completed = 0;
  int _pending = 0;
  Map<Priority, int> _byPriority = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tasks = await _taskRepo.getTasks();
    setState(() {
      _completed = tasks.where((t) => t.isCompleted).length;
      _pending = tasks.where((t) => !t.isCompleted).length;
      _byPriority = {
        Priority.high: tasks.where((t) => t.priority == Priority.high).length,
        Priority.medium: tasks.where((t) => t.priority == Priority.medium).length,
        Priority.low: tasks.where((t) => t.priority == Priority.low).length,
      };
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 24),
                  const Text('Progreso de Tareas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildPieChart(),
                  const SizedBox(height: 32),
                  const Text('Tareas por Prioridad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildPriorityBars(),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard() {
    final total = _completed + _pending;
    final percent = total == 0 ? 0 : (_completed / total * 100).round();

    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Productividad', style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('$percent%', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const Text('de tareas completadas', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            CircularProgressIndicator(
              value: total == 0 ? 0 : _completed / total,
              backgroundColor: Colors.white24,
              color: Colors.white,
              strokeWidth: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final total = _completed + _pending;
    if (total == 0) return const Center(child: Text('No hay datos suficientes'));

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: _completed.toDouble(),
              title: '$_completed',
              color: Colors.green,
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              value: _pending.toDouble(),
              title: '$_pending',
              color: Colors.orange,
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildPriorityBars() {
    return Column(
      children: [
        _buildProgressBar('Alta', _byPriority[Priority.high] ?? 0, Colors.red),
        const SizedBox(height: 12),
        _buildProgressBar('Media', _byPriority[Priority.medium] ?? 0, Colors.orange),
        const SizedBox(height: 12),
        _buildProgressBar('Baja', _byPriority[Priority.low] ?? 0, Colors.green),
      ],
    );
  }

  Widget _buildProgressBar(String label, int count, Color color) {
    final total = _completed + _pending;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text('$count')],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: total == 0 ? 0 : count / total,
          color: color,
          backgroundColor: color.withAlpha(50),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
