import 'package:flutter/material.dart';

void main() {
  runApp(const soil());
}

class soil extends StatelessWidget {
  const soil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 149, 255, 154),
        body: Center(
          child: Container(
            child: Text(
              "Hello World",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
