import 'package:flutter/material.dart';

import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/slippery_text_form_field_widget.dart';

class EditPublisherScreen extends StatefulWidget {
  final Publisher? publisher;

  const EditPublisherScreen({
    super.key,
    this.publisher,
  });

  @override
  State<EditPublisherScreen> createState() => _EditPublisherScreenState();
}

class _EditPublisherScreenState extends State<EditPublisherScreen> {
  late Publisher _publisher;

  // Insert flag: tells whether the widget is used for adding or editing a publisher.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _inserting = widget.publisher == null;

    _publisher = widget.publisher != null
        ? widget.publisher!.copy()
        : Publisher(
            name: "",
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.publisherTitle}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Themes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditSectionWidget(
                spacing: Themes.spacingMedium,
                children: [
                  Text(strings.publisherInfoName),
                  SlipperyTextFormFieldWidget(
                    initialValue: _publisher.name,
                    textCapitalization:
                        TextCapitalization.values[SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.titlesCapitalization) ?? Config.defaultTitlesCapitalization.index],
                    onChanged: (String value) => _publisher.name = value,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final NavigatorState navigator = Navigator.of(context);

          // Actually save the author.
          _inserting
              ? await LibraryContentProvider.instance.addPublisher(_publisher)
              : await LibraryContentProvider.instance.updatePublisher(widget.publisher!..copyFrom(_publisher));
          navigator.pop(_publisher);
        },
        label: Row(
          spacing: Themes.spacingMedium,
          children: [
            Text(strings.editDone),
            const Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
