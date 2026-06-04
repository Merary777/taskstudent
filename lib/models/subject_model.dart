import 'package:flutter/material.dart';
import 'dart:convert';

class Subject {
  final String id;
  final String name;
  final Color color;

  Subject({
    required this.id,
    required this.name,
    required this.color,
  });

  Subject copyWith({
    String? id,
    String? name,
    Color? color,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.toARGB32(),
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      color: Color(map['color'] ?? 0xFF000000),
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) => Subject.fromMap(json.decode(source));
}
