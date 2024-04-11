import 'package:flutter/material.dart';

class Bomb extends StatelessWidget {
  final int number;
  final bool reveal;
  final function;

  const Bomb(
      {Key? key,
      required this.number,
      required this.reveal,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: reveal ? Colors.grey[800] : Colors.grey[300],
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(fontSize: 16), // Use const for styles
            ),
          ),
        ),
      ),
    );
  }
}
