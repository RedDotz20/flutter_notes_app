class Todo {
  late int id;
  late String title;
  late bool completed; // Keep the data type as bool

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] == 1, // Convert to boolean
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'completed': completed ? 1 : 0, // Convert bool to tinyint(1)
      };
}

class TodoItem {
  late int id;
  late String title;
  late bool isDone;

  TodoItem({
    required this.id,
    required this.title,
    required this.isDone,
  });

  factory TodoItem.fromTodo(Todo todo) => TodoItem(
        id: todo.id,
        title: todo.title,
        isDone: todo.completed,
      );
}
