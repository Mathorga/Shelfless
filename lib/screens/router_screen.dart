import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/library_content_screen.dart';
import 'package:shelfless/screens/welcome_screen.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';

/// Reroutes the UI to either a library creation or import screen or to the latest library open by the user.
class RouterScreen extends StatefulWidget {
  const RouterScreen({super.key});

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  // Latest selected app locale, used to update the UI when necessary.
  int _appLocaleIndex =
      SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.appLocale) ??
          Config.defaultAppLocale;

  @override
  void initState() {
    super.initState();

    // Listen to changes in shared preferences in order to catch app-wide changes.
    SharedPrefsHelper.instance.addListener(_onPrefsChanged);
  }

  @override
  void dispose() {
    // Stop listening to shared preferences changes.
    SharedPrefsHelper.instance.removeListener(_onPrefsChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        LibrariesProvider.instance.addListener(() {
          if (context.mounted) {
            setState(() {});
          }
        });

        // Show an introductory library creation wizard instead of a bare EditLibraryScreen.
        if (LibrariesProvider.instance.libraries.isEmpty)
          return WelcomeScreen();

        // Try and read the latest open library from shared preferences.
        LibraryPreview library = LibrariesProvider.instance.libraries.first;
        int? storedLibraryId =
            SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.openLibrary);
        LibraryPreview? foundLibrary = LibrariesProvider.instance.libraries
            .firstWhereOrNull(
                (LibraryPreview preview) => preview.raw.id == storedLibraryId);
        library = foundLibrary ?? library;

        return LibraryContentScreen(
          library: library,
        );
      },
    );
  }

  void _onPrefsChanged() {
    if (!mounted) return;

    final int currentAppLocaleIndex =
        SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.appLocale) ??
            Config.defaultAppLocale;
    if (currentAppLocaleIndex != _appLocaleIndex) {
      _appLocaleIndex = currentAppLocaleIndex;
      setState(() {});
    }
  }
}
