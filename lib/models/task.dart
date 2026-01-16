class Task {
  int? id;
  String title;
  int priority;
  DateTime? dueDate;
  String? note;
  bool isDone;

  Task({
    required this.title,
    this.id,
    this.priority = 3,
    this.dueDate,
    this.note,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'priority': priority,
    'dueDate': dueDate?.toIso8601String(),
    'note': note,
    'isDone': isDone ? 1 : 0,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    priority: map['priority'],
    dueDate:
    map['dueDate'] != null ? DateTime.tryParse(map['dueDate']) : null,
    note: map['note'],
    isDone: map['isDone'] == 1,
  );
}