import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<String> _todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ToDo"),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(todo),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteTodoDialog(index);
              },
            ),
            onTap: () {
              _editTodoDialog(todo, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodoDialog() {
    String todo = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add ToDo'),
          content: TextField(
            onChanged: (value) {
              todo = value;
            },
            decoration: const InputDecoration(hintText: "ToDo content"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (todo.isNotEmpty) {
                  setState(() {
                    _todos.add(todo);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editTodoDialog(String oldTodo, int index) {
    String todo = oldTodo;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit ToDo'),
          content: TextField(
            controller: TextEditingController(text: oldTodo),
            onChanged: (value) {
              todo = value;
            },
            decoration: const InputDecoration(hintText: "ToDo content"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _todos[index] = todo;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodoDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete ToDo'),
          content: const Text('Are you sure you want to delete this ToDo?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _todos.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
