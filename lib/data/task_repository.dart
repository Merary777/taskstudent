import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskRepository {
  static const String _tasksKey = 'tasks';

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson.map((t) => Task.fromJson(t)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((t) => t.toJson()).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(Task updatedTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveTasks(tasks);
  }

  Future<void> toggleTaskCompletion(String id) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      tasks[index] = tasks[index].copyWith(isCompleted: !tasks[index].isCompleted);
      await saveTasks(tasks);
    }
  }
}
