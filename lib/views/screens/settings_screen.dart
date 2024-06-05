import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color scaffoldColor;
  final double textScaleFactor;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<Color> onScaffoldColorChanged;
  final ValueChanged<double> onTextScaleFactorChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.scaffoldColor,
    required this.textScaleFactor,
    required this.onDarkModeChanged,
    required this.onScaffoldColorChanged,
    required this.onTextScaleFactorChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;
  late Color _scaffoldColor;
  late double _textScaleFactor;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _scaffoldColor = widget.scaffoldColor;
    _textScaleFactor = widget.textScaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                });
                widget.onDarkModeChanged(value);
              },
            ),
            ListTile(
              title: const Text("Scaffold Color"),
              trailing: CircleAvatar(
                backgroundColor: _scaffoldColor,
              ),
              onTap: () async {
                Color? selectedColor = await showDialog<Color>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Select Scaffold Color"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildColorOption(Colors.white),
                          buildColorOption(Colors.red),
                          buildColorOption(Colors.green),
                          buildColorOption(Colors.blue),
                          buildColorOption(Colors.yellow),
                          buildColorOption(Colors.orange),
                          buildColorOption(Colors.purple),
                          buildColorOption(Colors.brown),
                        ],
                      ),
                    ),
                  ),
                );
                if (selectedColor != null) {
                  setState(() {
                    _scaffoldColor = selectedColor;
                  });
                  widget.onScaffoldColorChanged(selectedColor);
                }
              },
            ),
            ListTile(
              title: const Text("Text Size"),
              subtitle: Slider(
                value: _textScaleFactor,
                min: 0.5,
                max: 2.0,
                onChanged: (value) {
                  setState(() {
                    _textScaleFactor = value;
                  });
                  widget.onTextScaleFactorChanged(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(color);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        width: double.infinity,
        height: 50.0,
        color: color,
      ),
    );
  }
}
