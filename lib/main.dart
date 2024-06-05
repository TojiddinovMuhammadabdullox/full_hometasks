import 'package:flutter/material.dart';
import 'package:full_hometasks/views/screens/courses_screen.dart';
import 'package:full_hometasks/views/screens/home_screen.dart';
import 'package:full_hometasks/views/screens/profile_screen.dart';
import 'package:full_hometasks/views/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Widget> _screens = [];
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  Color _scaffoldColor = Colors.white;
  double _textScaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      const HomeScreen(),
      const ProfileScreen(),
      SettingsScreen(
        isDarkMode: _isDarkMode,
        scaffoldColor: _scaffoldColor,
        textScaleFactor: _textScaleFactor,
        onDarkModeChanged: (bool value) {
          setState(() {
            _isDarkMode = value;
          });
        },
        onScaffoldColorChanged: (Color color) {
          setState(() {
            _scaffoldColor = color;
          });
        },
        onTextScaleFactorChanged: (double scale) {
          setState(() {
            _textScaleFactor = scale;
          });
        },
      ),
      const CoursesScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme.copyWith(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: Scaffold(
        backgroundColor: _scaffoldColor,
        bottomNavigationBar: MediaQuery.of(context).size.width < 640
            ? BottomNavigationBar(
                currentIndex: _selectedIndex,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.indigoAccent,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Profile"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_rounded), label: "Courses"),
                ],
              )
            : null,
        body: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: _textScaleFactor),
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width >= 640)
                NavigationRail(
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  selectedIndex: _selectedIndex,
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.home), label: Text("Home")),
                    NavigationRailDestination(
                        icon: Icon(Icons.person), label: Text("Profile")),
                    NavigationRailDestination(
                        icon: Icon(Icons.settings), label: Text("Settings")),
                    NavigationRailDestination(
                        icon: Icon(Icons.menu_book_rounded),
                        label: Text("Courses")),
                  ],
                ),
              Expanded(
                child: _screens[_selectedIndex],
              )
            ],
          ),
        ),
      ),
    );
  }
}
