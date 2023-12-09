import 'package:flutter/material.dart';
import '../services/crud_service.dart';
import '../models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService('http://your_php_server');
  final TextEditingController _textFieldController = TextEditingController();
  List<TodoItem> _todoList = <TodoItem>[];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final List<Todo> fetchedTodos = await apiService.getTodos();
    setState(() {
      _todoList = fetchedTodos.map((todo) => TodoItem.fromTodo(todo)).toList();
    });
  }

  Future<void> _addTodoItem(String title) async {
    await apiService.createTodo(title);
    _textFieldController.clear();
    _loadTodos();
  }

  Future<void> _editTodoItem(int index) async {
    TextEditingController editController =
        TextEditingController(text: _todoList[index].title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Edit task here'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('UPDATE'),
              onPressed: () async {
                Navigator.of(context).pop();
                await apiService.updateTodo(
                  _todoList[index].id,
                  editController.text,
                );
                _loadTodos();
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _deleteTodoItem(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('DELETE'),
              onPressed: () async {
                Navigator.of(context).pop();
                await apiService.deleteTodo(_todoList[index].id);
                _loadTodos();
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _toggleDone(int index) {
    setState(() {
      _todoList[index].isDone = !_todoList[index].isDone;
    });
  }

  Widget _buildTodoItem(TodoItem todoItem, int index) {
    return ListTile(
      leading: Checkbox(
        value: todoItem.isDone,
        onChanged: (value) => _toggleDone(index),
      ),
      title: Text(
        todoItem.title,
        style: TextStyle(
          fontSize: 16,
          color: todoItem.isDone ? Colors.green : Colors.white,
          fontWeight: FontWeight.bold,
          decoration: todoItem.isDone
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          decorationColor: Colors.white,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _editTodoItem(index),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTodoItem(index),
          ),
        ],
      ),
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Task'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Enter task here'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ADD'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _addTodoItem(_textFieldController.text);
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'TODO-LIST',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
          children: _todoList
              .map((todo) => _buildTodoItem(todo, _todoList.indexOf(todo)))
              .toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Add Item',
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
