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
  String name = "";
  int color = Colors.white.value;

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    final GenresProvider genresProvider = Provider.of(context, listen: false);

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Insert Genre"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const Text("Name"),
              TextField(
                onChanged: (String value) => name = value,
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
                              pickerColor: Color(color),
                              onColorChanged: (Color pickedColor) {
                                setState(() {
                                  color = pickedColor.value;
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
                          color: Color(color),
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
                                color = (Random().nextDouble() * 0x00FFFFFF + 0xFF000000).toInt();
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
            // Actually save a new genre.
            final Genre genre = Genre(
              name: name.trim(),
              // color: (Random().nextDouble() * 0x00FFFFFF + 0xFF000000).toInt(),
              color: color,
            );
            genresProvider.addGenre(genre);
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
}
