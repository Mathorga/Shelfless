import 'package:flutter/material.dart';

import 'package:shelfish/screens/main_screen.dart';

void main() {
  runApp(const Shelfish());
}

class Shelfish extends StatelessWidget {
  const Shelfish({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shelfish",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MainScreen(),
    );
  }
}
