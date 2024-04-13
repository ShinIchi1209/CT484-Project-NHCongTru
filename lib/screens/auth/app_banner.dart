import 'dart:math';
import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 94.0,
      ),
      transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 12, 148, 221),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Color.fromARGB(66, 4, 75, 93),
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Text(
        'TO-DO',
        style: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color,
          fontSize: 50,
          fontFamily: 'Anton',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
