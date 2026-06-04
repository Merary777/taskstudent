import 'dart:convert';
import 'priority.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String? subjectId;
  final Priority priority;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.subjectId,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? subjectId,
    Priority? priority,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subjectId: subjectId ?? this.subjectId,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subjectId': subjectId,
      'priority': priority.name,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      subjectId: map['subjectId'],
      priority: Priority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => Priority.medium,
      ),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] ?? 0),
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
