// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Database _database;
  final TextEditingController _textEditingController = TextEditingController();
  final List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, content TEXT)',
        );
      },
      version: 1,
    );
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final List<Map<String, dynamic>> notes = await _database.query('notes');
    setState(() {
      _notes.clear();
      _notes.addAll(notes);
    });
  }

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
            title: Text(note['content']),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteNoteDialog(context, note['id']);
              },
            ),
            onTap: () {
              _editNoteDialog(context, note);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNoteDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addNoteDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: TextField(
            controller: _textEditingController,
            autofocus:
                true, // Ensure text field gets focus when dialog is shown
            decoration: const InputDecoration(hintText: "Note content"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final content = _textEditingController.text;
                if (content.isNotEmpty) {
                  await _insertNote(content);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _insertNote(String content) async {
    await _database.insert(
      'notes',
      {'content': content},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchNotes();
  }

  Future<void> _editNoteDialog(
      BuildContext context, Map<String, dynamic> note) async {
    final TextEditingController controller =
        TextEditingController(text: note['content']);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: controller,
            autofocus:
                true, // Ensure text field gets focus when dialog is shown
            decoration: const InputDecoration(hintText: "Note content"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final content = controller.text;
                await _updateNote(note['id'], content);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateNote(int id, String content) async {
    await _database.update(
      'notes',
      {'id': id, 'content': content},
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchNotes();
  }

  Future<void> _deleteNoteDialog(BuildContext context, int id) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () async {
                await _deleteNote(id);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNote(int id) async {
    await _database.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchNotes();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
