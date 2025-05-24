class Task{
  late String id;
  late String? task;
  bool isChecked = false;
  Task({required this.id, required this.task, required this.isChecked});

  // this converts my Task class into a map for jsonencoding
  Map<String, dynamic> toJson(){
    return
      {
        'id': id,
        'task': task,
        'isChecked': isChecked
      };
  }
  // convert the JSON string into a Task class
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      task: json['task'] as String?,
      isChecked: json['isChecked'] as bool
    );
  }
}