import 'package:flutter/material.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/genre.dart';

class BookPreviewWidget extends StatelessWidget {
  final Book book;
  final void Function()? onTap;

  const BookPreviewWidget({
    Key? key,
    required this.book,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: book.genres!.length >= 2
              ? LinearGradient(colors: book.genres!.map((Genre genre) => Color(genre.color)).toList())
              : LinearGradient(colors: [
                  Color(book.genres!.first.color),
                  Color(book.genres!.first.color),
                ]),
        ),
        padding: const EdgeInsets.all(4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            // side: BorderSide(
            //   /*color: Color(book.genre?.color ?? 0), */ width: 4.0,
            // ),
          ),
          // shadowColor: Color(book.genre?.color ?? 0),
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                if (book.authors != null && book.authors!.isNotEmpty)
                  book.authors!.length <= 2
                      ? Text(book.authors!.map((Author author) => author.toString()).reduce((String value, String element) => "$value, $element"))
                      : Text("${book.authors!.first}, altri"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
