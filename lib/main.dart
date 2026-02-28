import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00897B),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const VangtiChaiHomePage(title: 'VangtiChai'),
    );
  }
}

class VangtiChaiHomePage extends StatefulWidget {
  const VangtiChaiHomePage({super.key, required this.title});
  final String title;

  @override
  State<VangtiChaiHomePage> createState() => _VangtiChaiHomePageState();
}

class _VangtiChaiHomePageState extends State<VangtiChaiHomePage> {
  String _amountString = "";
  final List<int> _notes = [500, 100, 50, 20, 10, 5, 2, 1];

  void _onKeyPress(String value) {
    setState(() {
      if (value == "CLEAR") {
        _amountString = "";
      } else {
        if (_amountString == "0") {
          if (value != "0") {
            _amountString = value;
          }
        } else {
          _amountString += value;
        }
      }
    });
  }

  Map<int, int> _calculateChange() {
    Map<int, int> change = {for (var note in _notes) note: 0};
    int amount = int.tryParse(_amountString.isEmpty ? "0" : _amountString) ?? 0;

    for (int note in _notes) {
      if (amount >= note) {
        change[note] = amount ~/ note;
        amount = amount % note;
      }
    }
    return change;
  }

  Widget _buildNoteRow(int note, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '$note:',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$count',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteList(bool isLandscape) {
    final change = _calculateChange();

    if (isLandscape) {
      return Container(
        color: const Color(0xFFE8F0FE), // Light blue background
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 4; i++)
                    _buildNoteRow(_notes[i], change[_notes[i]]!),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 4; i < 8; i++)
                    _buildNoteRow(_notes[i], change[_notes[i]]!),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: const Color(0xFFE8F0FE),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int note in _notes) _buildNoteRow(note, change[note]!),
          ],
        ),
      );
    }
  }

  Widget _buildKeyButton(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: const Color(0xFFD6D7D9),
          elevation: 1,
          child: InkWell(
            onTap: () => _onKeyPress(label),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeKeypad() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildKeyButton("1"),
              _buildKeyButton("2"),
              _buildKeyButton("3"),
              _buildKeyButton("4"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKeyButton("5"),
              _buildKeyButton("6"),
              _buildKeyButton("7"),
              _buildKeyButton("8"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKeyButton("9"),
              _buildKeyButton("0"),
              _buildKeyButton("CLEAR", flex: 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitKeypad() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildKeyButton("1"),
              _buildKeyButton("2"),
              _buildKeyButton("3"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKeyButton("4"),
              _buildKeyButton("5"),
              _buildKeyButton("6"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKeyButton("7"),
              _buildKeyButton("8"),
              _buildKeyButton("9"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKeyButton("0", flex: 1),
              _buildKeyButton("CLEAR", flex: 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypad(bool isLandscape) {
    return Container(
      color: const Color(0xFFF5F5F5), // Light grey background
      padding: const EdgeInsets.all(4.0),
      child: isLandscape ? _buildLandscapeKeypad() : _buildPortraitKeypad(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    String displayAmount = _amountString.isEmpty ? "0" : _amountString;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              'Taka: $displayAmount',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: isLandscape ? 1 : 4,
                  child: _buildNoteList(isLandscape),
                ),
                Expanded(
                  flex: isLandscape ? 1 : 5,
                  child: _buildKeypad(isLandscape),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
