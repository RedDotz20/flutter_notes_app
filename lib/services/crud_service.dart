import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/api.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['tasks'];
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> createTodo(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTodo(int id, String newTitle) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api.php'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'id': id, 'title': newTitle}), //? Pass both id and title
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTodo(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
