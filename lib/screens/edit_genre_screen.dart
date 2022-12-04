import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:shelfish/models/genre.dart';
import 'package:shelfish/providers/genres_provider.dart';
import 'package:shelfish/utils/strings.dart';
import 'package:shelfish/utils/utils.dart';
import 'package:shelfish/widgets/unfocus_widget.dart';

class EditGenreScreen extends StatefulWidget {
  static const String routeName = "/edit-genre";

  const EditGenreScreen({Key? key}) : super(key: key);

  @override
  _EditGenreScreenState createState() => _EditGenreScreenState();
}

class _EditGenreScreenState extends State<EditGenreScreen> {
  late Genre _genre;

  // Insert flag: tells whether the widget is used for adding or editing an author.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _genre = Genre(
      name: "",
      color: Utils.randomColor(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    final GenresProvider genresProvider = Provider.of(context, listen: false);

    // Fetch passed arguments.
    Genre? receivedGenre = ModalRoute.of(context)!.settings.arguments as Genre?;
    _inserting = receivedGenre == null;

    if (!_inserting) {
      _genre = receivedGenre!;
    }

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.genreTitle}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Text(strings.genreInfoName),
              TextFormField(
                initialValue: _genre.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (String value) => _genre.name = value,
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // Last name.
              Text(strings.genreInfoColor),
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
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Actually save the genre.
            _inserting ? genresProvider.addGenre(_genre) : genresProvider.updateGenre(_genre);
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
