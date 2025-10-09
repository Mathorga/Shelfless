import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shelfless/screens/router_screen.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/strings/strings.dart';

/// Displays the app credits and then redirects to the main screens.
class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Automatically navigate to the main screen.
    Timer(
      Config.creditsDuration,
      () {
        final NavigatorState navigator = Navigator.of(context);

        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return RouterScreen();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          strings.credits,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
