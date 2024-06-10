import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:full_hometasks/views/screens/home.dart';
import 'package:full_hometasks/views/screens/register_screen.dart';
import 'package:full_hometasks/views/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Spawning a new isolate for heavy operations
  await spawnHeavyIsolate();

  runApp(const MyApp());
}

Future<void> spawnHeavyIsolate() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(runHeavyIsolate, receivePort.sendPort);
}

void runHeavyIsolate(SendPort sendPort) {
  // Your heavy operations go here
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const RegisterScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MyHomeApp(),
      },
    );
  }
}
