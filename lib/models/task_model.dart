class Task {
  final String id;
  final String title;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.completed = false,
  });

  void toggleDone() {
    completed = !completed;
  }

  // create data from json
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['taskId'],
        title: json['title'],
        completed: json['done'] == 1,
      );

  // convert data to json
  Map<String, dynamic> toJson() => {
        'taskId': id,
        'title': title,
        'done': completed ? 1 : 0,
      };
}
