// ignore: file_names
class NoteFields {
  static const String id = "id";
  static const String uniqueId = "uniqueId";
  static const String pin = "pin";
  static const String isArchive = "isArchive";
  static const String title = "title";
  static const String content = "content";
  static const String color = "color";
  static const String createdTime = "createdTime";
  static const String tableName = "Notes";
  static final List<String> values = [id, pin, title, content, createdTime];
}

class Note {
  final int? id;
  final bool pin;
  final bool isArchive;
  final String title;
  final String uniqueId;
  final String content;
  final String color;
  final DateTime createdTime;

  Note(
    this.id, {
    required this.pin,
    required this.isArchive,
    required this.title,
    required this.uniqueId,
    required this.content,
    required this.color,
    required this.createdTime,
  });

  static Note fromJson(Map<String, dynamic> Json) {
    return Note(Json[NoteFields.id] as int?,
        // pin: Json[NoteFields.pin] ?? 0,
        pin: Json[NoteFields.pin] == 1,
        isArchive: Json[NoteFields.isArchive] == 1,
        title: Json[NoteFields.title] as String,
        uniqueId: Json[NoteFields.uniqueId] as String,
        content: Json[NoteFields.content] as String,
        color: Json[NoteFields.color] as String,
        createdTime: DateTime.parse(Json[NoteFields.createdTime] as String));
  }

  Map<String, dynamic> toJson() {
    return {
      // NoteFields.id: id,
      NoteFields.pin: pin ? 1 : 0,
      NoteFields.isArchive: pin ? 1 : 0,
      NoteFields.title: title,
      NoteFields.uniqueId: uniqueId,
      NoteFields.content: content,
      NoteFields.color: color,
      NoteFields.createdTime: createdTime.toIso8601String()
    };
  }

  Note copy({
    int? id,
    bool? pin,
    String? title,
    String? content,
    String? color,
    DateTime? createdTime,
  }) {
    return Note(id ?? this.id,
        pin: pin ?? this.pin,
        isArchive: isArchive ?? this.isArchive,
        title: title ?? this.title,
        uniqueId: title ?? this.uniqueId,
        content: content ?? this.content,
        color: color ?? this.color,
        createdTime: createdTime ?? this.createdTime);
  }
}
