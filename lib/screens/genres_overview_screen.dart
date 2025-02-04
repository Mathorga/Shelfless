import 'package:flutter/material.dart';

import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_genre_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/genre_preview_widget.dart';

class GenresOverviewScreen extends StatefulWidget {
  final String searchValue;

  const GenresOverviewScreen({
    super.key,
    this.searchValue = "",
  });

  @override
  State<GenresOverviewScreen> createState() => _GenresOverviewScreenState();
}

class _GenresOverviewScreenState extends State<GenresOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: LibraryContentProvider.instance.genres.isEmpty
            ? Center(
                child: Text(strings.noGenresFound),
              )
            : GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                childAspectRatio: 12 / 9,
                crossAxisCount: 2,
                children: [
                  ...List.generate(
                    LibraryContentProvider.instance.genres.length,
                    (int index) {
                      // Make sure the received index is somewhat valid.
                      if (index > LibraryContentProvider.instance.genres.values.length) return const Placeholder();

                      // Prefetch the genre for later use.
                      RawGenre? genre = LibraryContentProvider.instance.genres.values.toList()[index];

                      return Stack(
                        children: [
                          GenrePreviewWidget(
                            genre: genre,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // Go to genre info.
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) => GenreInfoScreen(genre: _genres[index]),
                                //   ),
                                // );
                              },
                              icon: const Icon(Icons.settings_rounded),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Create new genre.
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => const EditGenreScreen()),
            );
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
