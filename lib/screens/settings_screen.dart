import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/unavailable_content_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                title: Row(
                  spacing: Themes.spacingMedium,
                  children: [
                    Icon(Icons.assignment_rounded),
                    Text(strings.licensesLabel),
                  ],
                ),
                onTap: () => showLicensePage(context: context),
              ),
              UnavailableContentWidget(
                child: ListTile(
                  title: Row(
                    spacing: Themes.spacingMedium,
                    children: [
                      Icon(Icons.support_agent_rounded),
                      Text(strings.supportLabel),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(Themes.spacingMedium),
              child: Text("<version_number>"),
            ),
          ),
        ],
      ),
    );
  }
}
