import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/genre.dart';
import 'package:shelfish/providers/genres_provider.dart';
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
      color: randomColor(),
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
          title: Text("${_inserting ? "Insert" : "Edit"} Genre"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const Text("Name"),
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
              const Text("Color"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Pick a color"),
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
                              child: const Text("OK"),
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
                                _genre.color = randomColor();
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
            children: const [
              Text("Done"),
              SizedBox(width: 12.0),
              Icon(Icons.check),
            ],
          ),
        ),
      ),
    );
  }

  int randomColor() => (Random().nextDouble() * 0x00FFFFFF + 0xFF000000).toInt();
}
