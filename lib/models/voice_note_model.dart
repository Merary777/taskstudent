import 'dart:convert';

class VoiceNote {
  final String id;
  final String title;
  final String transcribedText;
  final DateTime createdAt;

  VoiceNote({
    required this.id,
    required this.title,
    required this.transcribedText,
    required this.createdAt,
  });

  VoiceNote copyWith({
    String? id,
    String? title,
    String? transcribedText,
    DateTime? createdAt,
  }) {
    return VoiceNote(
      id: id ?? this.id,
      title: title ?? this.title,
      transcribedText: transcribedText ?? this.transcribedText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'transcribedText': transcribedText,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory VoiceNote.fromMap(Map<String, dynamic> map) {
    return VoiceNote(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      transcribedText: map['transcribedText'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory VoiceNote.fromJson(String source) =>
      VoiceNote.fromMap(json.decode(source));
}
