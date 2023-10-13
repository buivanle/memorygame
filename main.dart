import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoryGamePage(),
    );
  }
}

class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  late List<int> _items;
  late List<bool> _flipped;
  late int _previousIndex;
  late bool _isProcessing;

  @override
  void initState() {
    super.initState();
    _items = List.generate(8, (index) => index ~/ 2);
    _items.shuffle();
    _flipped = List.generate(8, (index) => false);
    _previousIndex = -1;
    _isProcessing = false;
  }

  void _flipCard(int index) {
    if (!_isProcessing && !_flipped[index]) {
      setState(() {
        _flipped[index] = true;
      });

      if (_previousIndex == -1) {
        _previousIndex = index;
      } else {
        _isProcessing = true;
        Timer(Duration(seconds: 1), () {
          if (_items[_previousIndex] == _items[index]) {
            _flipped[_previousIndex] = true;
            _flipped[index] = true;
          } else {
            _flipped[_previousIndex] = false;
            _flipped[index] = false;
          }

          _previousIndex = -1;
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _flipCard(index);
            },
            child: Container(
              margin: EdgeInsets.all(4),
              color: _flipped[index] ? Colors.blue : Colors.grey,
              child: Center(
                child: _flipped[index]
                    ? Text(
                        _items[index].toString(),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
