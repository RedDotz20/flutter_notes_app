import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TodoItem> _todoList = <TodoItem>[];
  final TextEditingController _textFieldController = TextEditingController();

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
      body: ListView(children: _getItems()),
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

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(TodoItem(title: title, isDone: false));
    });
    _textFieldController.clear();
  }

  void _editTodoItem(int index) {
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
              onPressed: () {
                Navigator.of(context).pop();
                _updateTodoItem(index, editController.text);
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

  void _updateTodoItem(int index, String newTitle) {
    setState(() {
      _todoList[index].title = newTitle;
    });
  }

  void _deleteTodoItem(int index) {
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
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDelete(index);
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

  void _confirmDelete(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
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

  Future _displayDialog(BuildContext context) async {
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
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
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

  List<Widget> _getItems() {
    return List.generate(
      _todoList.length,
      (index) => _buildTodoItem(_todoList[index], index),
    );
  }
}

class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, required this.isDone});
}
