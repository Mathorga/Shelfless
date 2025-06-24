import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/widgets/shaded_image_widget.dart';

/// Displays the provided book's cover image as per app settings.
class BookCoverImageWidget extends StatelessWidget {
  final Book book;
  final Widget? child;

  const BookCoverImageWidget({
    super.key,
    required this.book,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (book.raw.cover == null) {
      return child ??
          Image.asset(
            "assets/images/covers/flower.png",
            fit: BoxFit.cover,
            isAntiAlias: true,
            filterQuality: FilterQuality.none,
          );
    }

    return ShadedImageWidget(
      imageData: book.raw.cover!,
      applyFilter: false,
    );
    // return Image.memory(
    //   book.raw.cover!,
    //   fit: BoxFit.cover,
    //   isAntiAlias: false,
    //   filterQuality: FilterQuality.none,
    // );
  }
}
