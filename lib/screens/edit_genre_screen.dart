import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/utils/utils.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditGenreScreen extends StatefulWidget {
  static const String routeName = "/edit-genre";

  final RawGenre? genre;

  const EditGenreScreen({
    Key? key,
    this.genre,
  }) : super(key: key);

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
    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.genreTitle}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              EditSectionWidget(
                children: [
                  Text(strings.genreInfoName),
                  Themes.spacer,
                  TextFormField(
                    initialValue: _genre.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (String value) => _genre.name = value,
                  ),
                ],
              ),

              // Last name.
              EditSectionWidget(
                children: [
                  Text(strings.genreInfoColor),
                  Themes.spacer,
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(strings.genrePickColor),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  enableAlpha: false,
                                  hexInputBar: true,
                                  pickerAreaBorderRadius: BorderRadius.circular(15.0),
                                  pickerColor: Color(_genre.color),
                                  onColorChanged: (Color pickedColor) {
                                    setState(() {
                                      _genre.color = pickedColor.value;
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Dismiss dialog.
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(strings.ok),
                                ),
                              ],
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
      ),
    );
  }
}
