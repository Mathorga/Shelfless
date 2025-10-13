import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shelfless/screens/router_screen.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/strings/strings.dart';

/// Displays the app dedication and then redirects to the provided destination if any.
class DedicationScreen extends StatefulWidget {
  /// Optional destination route. This route, if provided, is navigated to after a short time.
  final MaterialPageRoute? destination;

  /// Whether the screen should be displayed as a landing page instead of an intermediate one.
  final bool landing;

  const DedicationScreen({
    super.key,
    this.destination,
    this.landing = false,
  });

  @override
  State<DedicationScreen> createState() => _DedicationScreenState();
}

class _DedicationScreenState extends State<DedicationScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Make sure no timer starts if no destination is provided.
    if (widget.destination == null) return;

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
      appBar: widget.landing ? AppBar() : null,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Text(
          strings.dedication,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
