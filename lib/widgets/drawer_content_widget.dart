import 'package:flutter/material.dart';

import 'package:shelfless/screens/authors_overview_screen.dart';
import 'package:shelfless/screens/genres_overview_screen.dart';
import 'package:shelfless/screens/settings_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/libraries_list_widget.dart';
import 'package:shelfless/widgets/unreleased_feature_dialog.dart';

class DrawerContentWidget extends StatelessWidget {
  const DrawerContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final EdgeInsets screenPadding = MediaQuery.paddingOf(context);
    final ThemeData theme = Theme.of(context);

    return Column(
      spacing: Themes.spacingSmall,
      children: [
        // Top padding.
        SizedBox(
          height: screenPadding.top,
        ),

        // App name.
        Text(
          Themes.appName,
          style: theme.textTheme.headlineMedium,
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Themes.spacingSmall),
              child: Column(
                children: [
                  // Libraries list.
                  LibrariesListWidget(),

                  Divider(),

                  // Authors.
                  _buildLibraryEntry(
                    // label: strings.authorsSectionTitle,
                    onPressed: () {
                      final NavigatorState navigator = Navigator.of(context);

                      navigator.push(MaterialPageRoute(
                        builder: (BuildContext context) => AuthorsOverviewScreen(),
                      ));
                    },
                    child: Row(
                      spacing: Themes.spacingMedium,
                      children: [
                        Icon(
                          Icons.person_pin_rounded,
                          size: Themes.iconSizeLarge,
                        ),
                        Text(strings.authorsSectionTitle),
                      ],
                    ),
                  ),

                  // Genres.
                  _buildLibraryEntry(
                    onPressed: () {
                      final NavigatorState navigator = Navigator.of(context);

                      navigator.push(MaterialPageRoute(
                        builder: (BuildContext context) => GenresOverviewScreen(),
                      ));
                    },
                    child: Row(
                      spacing: Themes.spacingMedium,
                      children: [
                        Icon(
                          Icons.color_lens_rounded,
                          size: Themes.iconSizeLarge,
                        ),
                        Text(strings.genresSectionTitle),
                      ],
                    ),
                  ),

                  // Publishers.
                  Opacity(
                    opacity: Themes.unavailableFeatureOpacity,
                    child: _buildLibraryEntry(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => UnreleasedFeatureDialog(),
                        );
                      },
                      child: Row(
                        spacing: Themes.spacingMedium,
                        children: [
                          Icon(
                            Icons.work_rounded,
                            size: Themes.iconSizeLarge,
                          ),
                          Text(strings.publishersSectionTitle),
                        ],
                      ),
                    ),
                  ),

                  // Locations.
                  Opacity(
                    opacity: Themes.unavailableFeatureOpacity,
                    child: _buildLibraryEntry(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => UnreleasedFeatureDialog(),
                        );
                      },
                      child: Row(
                        spacing: Themes.spacingMedium,
                        children: [
                          Icon(
                            Icons.place_rounded,
                            size: Themes.iconSizeLarge,
                          ),
                          Text(strings.locationsSectionTitle),
                        ],
                      ),
                    ),
                  ),

                  Divider(),

                  // TODO Add all user-defined collections if present.
                ],
              ),
            ),
          ),
        ),

        Divider(),

        // Settings section.
        Padding(
          padding: const EdgeInsets.all(Themes.spacingSmall),
          child: GestureDetector(
            onTap: () {
              final NavigatorState navigator = Navigator.of(context);

              // Navigate to settings screen.
              navigator.push(MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(Themes.spacingMedium),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                spacing: Themes.spacingLarge,
                children: [
                  Icon(Icons.settings_rounded),
                  Text(strings.settings),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryEntry({
    required Widget child,
    void Function()? onPressed,
  }) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
