import 'package:flutter/material.dart';
import 'package:full_hometasks/views/screens/notes_screen.dart';
import 'package:full_hometasks/views/screens/profile_screen.dart';
import 'todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [],
              ),
            ),
            ListTile(
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodoScreen()),
                );
              },
              child: Card(
                child: Center(
                  child: Text('Todo',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotesScreen()),
                );
              },
              child: Card(
                child: Center(
                  child: Text('Notes',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
