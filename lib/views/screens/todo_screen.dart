import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Map<String, dynamic>> _todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showResults();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(
              todo['title'],
              style: TextStyle(
                decoration: todo['isCompleted']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: todo['isCompleted'],
                  onChanged: (value) {
                    setState(() {
                      todo['isCompleted'] = value!;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteTodoDialog(index);
                  },
                ),
              ],
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
    String title = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            onChanged: (value) {
              title = value;
            },
            decoration: const InputDecoration(hintText: "Todo title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    _todos.add({'title': title, 'isCompleted': false});
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

  void _editTodoDialog(Map<String, dynamic> todo, int index) {
    String title = todo['title'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: TextField(
            controller: TextEditingController(text: title),
            onChanged: (value) {
              title = value;
            },
            decoration: const InputDecoration(hintText: "Todo title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    _todos[index]['title'] = title;
                  });
                }
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
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
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
          ],
        );
      },
    );
  }

  void _showResults() {
    int completed = _todos.where((todo) => todo['isCompleted']).length;
    int notCompleted = _todos.length - completed;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Todo Results'),
          content: Text('Completed: $completed\nNot Completed: $notCompleted'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
