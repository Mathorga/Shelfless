import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shelfless/utils/assets.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/text_capitalization_extension.dart';
import 'package:shelfless/widgets/colored_border_widget.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

import 'package:shelfless/screens/privacy_policy_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/unreleased_feature_widget.dart';

/// List tile for text capitalization. Separated for performance.
class _TextCapitalizationSetting extends StatefulWidget {
  const _TextCapitalizationSetting();

  @override
  State<_TextCapitalizationSetting> createState() => _TextCapitalizationSettingState();
}

class _TextCapitalizationSettingState extends State<_TextCapitalizationSetting> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: Themes.spacingMedium,
        children: [
          Expanded(
            child: Text(strings.settingTitlesCapitalization),
          ),
          Builder(
            builder: (BuildContext context) {
              int titlesCapitalizationIndex = SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.titlesCapitalization) ?? Config.defaultTitlesCapitalization.index;

              return Text(
                TextCapitalization.values[titlesCapitalizationIndex].label,
                style: TextStyle(
                  color: ShelflessColors.onMainContentInactive,
                ),
              );
            },
          ),
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(strings.settingTitlesCapitalization),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: TextCapitalization.values
                  .map(
                    (TextCapitalization element) => Card(
                      color: ShelflessColors.mainContentActive,
                      child: InkWell(
                        onTap: () async {
                          // Prefetch handlers before async gaps.
                          final NavigatorState navigator = Navigator.of(context);

                          // Store the setting.
                          setState(() {
                            SharedPrefsHelper.instance.setValue(SharedPrefsKeys.titlesCapitalization, element.index);
                          });

                          // Pop the dialog.
                          navigator.pop();
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(Themes.spacingMedium),
                            child: Text(element.label),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

/// List tile for default book cover image. Separated for performance.
class _DefaultCoverImageSetting extends StatefulWidget {
  const _DefaultCoverImageSetting();

  @override
  State<_DefaultCoverImageSetting> createState() => __DefaultCoverImageSettingState();
}

class __DefaultCoverImageSettingState extends State<_DefaultCoverImageSetting> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: Themes.spacingMedium,
        children: [
          Expanded(
            child: Text(strings.settingDefaultCover),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(Themes.radiusSmall),
            child: SizedBox(
              width: Themes.spacingXXLarge,
              height: Themes.spacingXXLarge,
              child: Image.asset(
                Assets.defaultCovers[SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.defaultBookCoverImage) ?? Config.defaultBookCoverImage],
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(strings.settingDefaultCover),
            content: SizedBox(
              width: Themes.maxContentWidth,
              child: GridView.count(
                crossAxisCount: 3,
                physics: Themes.scrollPhysics,
                mainAxisSpacing: Themes.spacingMedium,
                crossAxisSpacing: Themes.spacingMedium,
                shrinkWrap: true,
                children: Assets.defaultCovers
                    .mapIndexed(
                      (int index, String imagePath) => GestureDetector(
                        onTap: () {
                          final NavigatorState navigator = Navigator.of(context);

                          // Store the user selected cover.
                          setState(() {
                            SharedPrefsHelper.instance.setLoudValue(SharedPrefsKeys.defaultBookCoverImage, index);
                          });

                          navigator.pop();
                        },
                        child: ColoredBorderWidget(
                          colors: index == SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.defaultBookCoverImage)
                              ? [
                                  ShelflessColors.primary,
                                  ShelflessColors.secondary,
                                ]
                              : [],
                          thickness: Themes.spacingSmall,
                          borderRadius: Themes.radiusMedium,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Themes.spacingLarge,
                children: [
                  // App settings.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      // Default coverless book image.
                      _DefaultCoverImageSetting(),

                      // Titles' text capitalization.
                      _TextCapitalizationSetting(),

                      // App language.
                      UnreleasedFeatureWidget(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: Themes.spacingMedium,
                            children: [
                              Expanded(
                                child: Text(
                                  strings.settingAppLanguage,
                                ),
                              ),
                              Builder(
                                builder: (BuildContext context) {
                                  int appLanguageIndex = SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.appLocale) ?? AppLocales.system.index;

                                  return Text(
                                    AppLocales.values[appLanguageIndex].label,
                                    style: TextStyle(
                                      color: ShelflessColors.onMainContentInactive,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Legals and support.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      ListTile(
                        title: Row(
                          spacing: Themes.spacingMedium,
                          children: [
                            Icon(Icons.policy_rounded),
                            Expanded(
                              child: Text(
                                strings.privacyPolicyLabel,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          NavigatorState navigator = Navigator.of(context);

                          // Go to privacy policy screen.
                          navigator.push(MaterialPageRoute(
                            builder: (BuildContext context) => PrivacyPolicyScreen(),
                          ));
                        },
                      ),

                      // Licenses.
                      ListTile(
                        title: Row(
                          spacing: Themes.spacingMedium,
                          children: [
                            Icon(Icons.assignment_rounded),
                            Expanded(
                              child: Text(
                                strings.licensesLabel,
                              ),
                            ),
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
                            Expanded(
                              child: Text(
                                strings.supportLabel,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Open an email to the support address.
                          launchUrl(Uri.parse(Config.supportEmailAddress));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Version label.
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(Themes.spacingMedium),
                child: DefaultTextStyle(
                  style: theme.textTheme.labelMedium?.copyWith(color: ShelflessColors.onMainContentInactive) ?? TextStyle(),
                  child: FutureBuilder(
                    future: rootBundle.loadString(Assets.pubspec),
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
      ),
    );
  }
}
