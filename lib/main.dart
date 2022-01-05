import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfish/providers/database_provider.dart';

import 'package:shelfish/screens/main_screen.dart';

void main() {
  runApp(const Shelfish());
}

class Shelfish extends StatelessWidget {
  const Shelfish({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DatabaseProvider(),
      child: MaterialApp(
        title: "Shelfish",
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
