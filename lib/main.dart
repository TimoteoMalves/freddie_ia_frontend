import 'package:flutter/material.dart';
import 'package:ia_gemini_freddie/pages/home.dart';

void main() {
  runApp(const FreddieAi());
}

class FreddieAi extends StatelessWidget {
  const FreddieAi({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}

