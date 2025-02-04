import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Row(
              spacing: Themes.spacingMedium,
              children: [
                Icon(Icons.assignment_rounded),
                Text("Licenses"),
              ],
            ),
            onTap: () => showLicensePage(context: context),
          ),
        ],
      ),
    );
  }
}
