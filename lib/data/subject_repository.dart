import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subject_model.dart';

class SubjectRepository {
  static const String _subjectsKey = 'subjects';

  Future<List<Subject>> getSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getStringList(_subjectsKey);
    
    if (subjectsJson == null) {
      // Return default subjects if none are saved
      return [
        Subject(id: '1', name: 'Matemáticas', color: Colors.blue),
        Subject(id: '2', name: 'Historia', color: Colors.brown),
        Subject(id: '3', name: 'Ciencias', color: Colors.green),
        Subject(id: '4', name: 'Literatura', color: Colors.purple),
        Subject(id: '5', name: 'Inglés', color: Colors.orange),
      ];
    }
    
    return subjectsJson.map((s) => Subject.fromJson(s)).toList();
  }

  Future<void> saveSubjects(List<Subject> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((s) => s.toJson()).toList();
    await prefs.setStringList(_subjectsKey, subjectsJson);
  }

  Future<bool> addSubject(Subject subject) async {
    final subjects = await getSubjects();
    if (subjects.any((s) => s.name.toLowerCase() == subject.name.toLowerCase())) {
      return false; // Duplicate name
    }
    subjects.add(subject);
    await saveSubjects(subjects);
    return true;
  }

  Future<void> updateSubject(Subject updatedSubject) async {
    final subjects = await getSubjects();
    final index = subjects.indexWhere((s) => s.id == updatedSubject.id);
    if (index != -1) {
      subjects[index] = updatedSubject;
      await saveSubjects(subjects);
    }
  }

  Future<void> deleteSubject(String id) async {
    final subjects = await getSubjects();
    subjects.removeWhere((s) => s.id == id);
    await saveSubjects(subjects);
  }

  Future<Subject?> getSubjectById(String? id) async {
    if (id == null) return null;
    final subjects = await getSubjects();
    try {
      return subjects.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
