import 'package:flutter/material.dart';

class Number extends StatelessWidget {
  const Number({
    Key? key,
    required this.number,
    required this.reveal,
    required this.function,
  }) : super(key: key);

  final int number;
  final bool reveal;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: Colors.grey[400],
          child: Center(
            child: Text(
              reveal ? (number == 0 ? '' : '$number') : '',
              style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: reveal
                      ? (number == 1 ? Colors.red : Colors.black)
                      : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
