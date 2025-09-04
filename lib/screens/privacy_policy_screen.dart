import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:markdown_widget/markdown_widget.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';

/// Displays the full privacy policy in a dedicated screen.
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String? _data;

  @override
  void initState() {
    super.initState();

    _fetchSourceFile();
  }

  /// Fetches the privacy policy file from assets and updates the view.
  Future<void> _fetchSourceFile() async {
    // final String locale = Platform.localeName;
    final int localePref = SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.appLocale) ?? AppLocale.system.index;
    final AppLocale locale = AppLocale.values[localePref];
    String policyFilePath = "assets/privacy_policy_en.md";
    switch (locale) {
      case AppLocale.it:
        policyFilePath = "assets/privacy_policy_it.md";
        break;
      case AppLocale.en:
        policyFilePath = "assets/privacy_policy_en.md";
        break;
      case AppLocale.system:
        final String locale = Platform.localeName;

        if (locale.contains("it")) {
          policyFilePath = "assets/privacy_policy_it.md";
        }
        break;
    }

    _data = await rootBundle.loadString(policyFilePath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.privacyPolicyLabel),
      ),
      body: SafeArea(
        child: _data == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(Themes.spacingMedium),
                child: MarkdownWidget(
                  physics: Themes.scrollPhysics,
                  data: _data!,
                ),
              ),
      ),
    );
  }
}
