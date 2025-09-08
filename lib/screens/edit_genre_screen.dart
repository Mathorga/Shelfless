import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/utils/utils.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/slippery_text_form_field_widget.dart';

class EditGenreScreen extends StatefulWidget {
  static const String routeName = "/edit-genre";

  final RawGenre? genre;

  const EditGenreScreen({
    super.key,
    this.genre,
  });

  @override
  State<EditGenreScreen> createState() => _EditGenreScreenState();
}

class _EditGenreScreenState extends State<EditGenreScreen> {
  late RawGenre _genre;

  // Insert flag: tells whether the widget is used for adding or editing an author.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _inserting = widget.genre == null;

    _genre = widget.genre != null
        ? widget.genre!.copy()
        : RawGenre(
            name: "",
            color: Utils.randomColor(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.genreTitle}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              // Name
              EditSectionWidget(
                spacing: Themes.spacingMedium,
                children: [
                  Text(strings.genreInfoName),
                  SlipperyTextFormFieldWidget(
                    initialValue: widget.genre?.name,
                    onChanged: (String value) => _genre.name = value,
                    textCapitalization: TextCapitalization.values[SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.titlesCapitalization) ?? Config.defaultTitlesCapitalization.index],
                  ),
                ],
              ),
    
              // Color.
              EditSectionWidget(
                spacing: Themes.spacingMedium,
                children: [
                  Text(strings.genreInfoColor),
                  Padding(
                    padding: const EdgeInsets.all(Themes.spacingMedium),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: const EdgeInsets.all(0.0),
                              content: SingleChildScrollView(
                                child: SlidePicker(
                                  pickerColor: Color(_genre.color),
                                  indicatorBorderRadius: BorderRadius.circular(Themes.radiusMedium),
                                  enableAlpha: false,
                                  onColorChanged: (Color pickedColor) {
                                    setState(() {
                                      _genre.color = pickedColor.toARGB32();
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color(_genre.color),
                            ),
                            height: 100,
                            width: double.infinity,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  // Pick a random color.
                                  setState(() {
                                    _genre.color = Utils.randomColor();
                                  });
                                },
                                icon: const Icon(Icons.refresh_rounded)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Actually save the genre.
          _inserting ? LibraryContentProvider.instance.addGenre(_genre) : LibraryContentProvider.instance.updateGenre(widget.genre!..copyFrom(_genre));
          Navigator.of(context).pop();
        },
        label: Row(
          children: [
            Text(strings.editDone),
            const SizedBox(width: 12.0),
            const Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
