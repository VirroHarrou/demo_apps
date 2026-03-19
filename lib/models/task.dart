class Task {
  final String id;
  String title;
  String description;
  DateTime deadline;
  bool isCompleted;
  bool isFailed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
    this.isFailed = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'deadline': deadline.toIso8601String(),
    'isCompleted': isCompleted,
    'isFailed': isFailed,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    deadline: DateTime.parse(json['deadline']),
    isCompleted: json['isCompleted'],
    isFailed: json['isFailed'],
  );
}
