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
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.genresSectionTitle),
      ),
      body: LibraryContentProvider.instance.genres.isEmpty
          ? Center(
              child: Text(strings.noGenresFound),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
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
                          onTap: () {},
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
            MaterialPageRoute(
              builder: (BuildContext context) => const EditGenreScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
