import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:yaml/yaml.dart';

import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/unreleased_feature_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              // App settings.
              Padding(
                padding: const EdgeInsets.all(Themes.spacingMedium),
                child: Text(
                  strings.setitngsSectionTitle,
                  style: TextStyle(
                    color: ShelflessColors.onMainContentInactive,
                    fontSize: Themes.fontSizeSmall,
                  ),
                ),
              ),

              // Privacy policy.
              UnreleasedFeatureWidget(
                child: ListTile(
                  title: Row(
                    spacing: Themes.spacingMedium,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Themes.radiusSmall),
                        child: SizedBox(
                          width: Themes.spacingXXLarge,
                          height: Themes.spacingXXLarge,
                          child: Image.asset(
                            "assets/images/covers/flower.png",
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                      ),
                      Text(strings.defaultCoverLabel),
                    ],
                  ),
                ),
              ),

              // Legals and support.
              Padding(
                padding: const EdgeInsets.all(Themes.spacingMedium),
                child: Text(
                  strings.legalsSectionTitle,
                  style: TextStyle(
                    color: ShelflessColors.onMainContentInactive,
                    fontSize: Themes.fontSizeSmall,
                  ),
                ),
              ),

              // Privacy policy.
              UnreleasedFeatureWidget(
                child: ListTile(
                  title: Row(
                    spacing: Themes.spacingMedium,
                    children: [
                      Icon(Icons.policy_rounded),
                      Text(strings.privacyPolicyLabel),
                    ],
                  ),
                ),
              ),

              // Licenses.
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

              // Contact support.
              ListTile(
                title: Row(
                  spacing: Themes.spacingMedium,
                  children: [
                    Icon(Icons.support_agent_rounded),
                    Text(strings.supportLabel),
                  ],
                ),
                onTap: () {
                  // Open an email to the support address.
                  launchUrl(Uri.parse("mailto:michelettiluka@gmail.com?subject=Shelfless%20Support"));
                },
              ),
            ],
          ),

          // Version label.
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(Themes.spacingMedium),
              child: DefaultTextStyle(
                style: theme.textTheme.labelMedium?.copyWith(color: ShelflessColors.onMainContentInactive) ?? TextStyle(),
                child: FutureBuilder(
                  future: rootBundle.loadString("pubspec.yaml"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return Text("...");

                    if (snapshot.hasError) return Text(strings.genericError);

                    final String pubspecString = snapshot.data;
                    final YamlMap pubspecData = loadYaml(pubspecString);
                    final String versionString = pubspecData["version"];
                    return Text("${Themes.appName} v${versionString.split("+").first}");
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
