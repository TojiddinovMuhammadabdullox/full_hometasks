import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<String> _notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes"),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteNoteDialog(index);
              },
            ),
            onTap: () {
              _editNoteDialog(note, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNoteDialog() {
    String note = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: TextField(
            onChanged: (value) {
              note = value;
            },
            decoration: const InputDecoration(hintText: "Note content"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (note.isNotEmpty) {
                  setState(() {
                    _notes.add(note);
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

  void _editNoteDialog(String oldNote, int index) {
    String note = oldNote;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: TextEditingController(text: oldNote),
            onChanged: (value) {
              note = value;
            },
            decoration: const InputDecoration(hintText: "Note content"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _notes[index] = note;
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

  void _deleteNoteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _notes.removeAt(index);
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
