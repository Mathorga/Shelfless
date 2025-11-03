import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/dedication_screen.dart';
import 'package:shelfless/screens/router_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';

void main() async {
  // Open the local database.
  await DatabaseHelper.instance.openDB();

  // Fetch shared preferences.
  await SharedPrefsHelper.instance.init();

  // Fetch libraries from DB.
  await LibrariesProvider.instance.fetchLibraries();

  // Disable runtime fetchin google fonts, since used fonts are already in assets.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Limit orientation to portrait.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const Shelfless());
}

class Shelfless extends StatelessWidget {
  const Shelfless({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Themes.appName,
      theme: Themes.shelflessTheme,
      localizationsDelegates: const {
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      },
      supportedLocales: {
        const Locale("it"),
        const Locale("en"),
      },
      home: Builder(
        builder: (BuildContext context) {
          // Check whether startup credits were shown or not.
          final bool startupCreditsShown = SharedPrefsHelper.instance.data.getBool(SharedPrefsKeys.startupCreditsShown) ?? false;

          // Make sure credits aren't shown at next startup.
          if (!startupCreditsShown) SharedPrefsHelper.instance.data.setBool(SharedPrefsKeys.startupCreditsShown, true);

          return startupCreditsShown
              ? RouterScreen()
              : DedicationScreen(
                  destination: MaterialPageRoute(
                    builder: (BuildContext context) {
                      return RouterScreen();
                    },
                  ),
                );
        },
      ),
      routes: {},
    );
  }
}
