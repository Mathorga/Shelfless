import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/config.dart';

class CropCoverScreen extends StatelessWidget {
  final Image image;
  const CropCoverScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CropController(
      /// If not specified, [aspectRatio] will not be enforced.
      aspectRatio: 1 / 1,

      /// Specify in percentages (1 means full width and height). Defaults to the full image.
      defaultCrop: Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
    );

    return Scaffold(
      appBar: AppBar(
        // TODO Move to strings!
        title: Text("Crop image"),
      ),
      body: CropImage(
        /// Only needed if you expect to make use of its functionality like setting initial values of
        /// [aspectRatio] and [defaultCrop].
        controller: controller,

        /// The image to be cropped. Use [Image.file] or [Image.network] or any other [Image].
        image: image,

        /// The crop grid color of the outer lines. Defaults to 70% white.
        gridColor: Colors.white,

        /// The crop grid color of the inner lines. Defaults to [gridColor].
        gridInnerColor: Colors.white,

        /// The crop grid color of the corner lines. Defaults to [gridColor].
        gridCornerColor: Colors.white,

        /// The size of the corner of the crop grid. Defaults to 25.
        gridCornerSize: 50.0,

        /// Whether to display the corners. Defaults to true.
        showCorners: true,

        /// The width of the crop grid thin lines. Defaults to 2.
        gridThinWidth: 1.0,

        /// The width of the crop grid thick lines. Defaults to 5.
        gridThickWidth: 3.0,

        /// True: Always show third lines of the crop grid.
        /// False: third lines are only displayed while the user manipulates the grid (default).
        alwaysShowThirdLines: true,

        /// Event called when the user changes the crop rectangle.
        /// The passed [Rect] is normalized between 0 and 1.
        onCrop: (rect) => print(rect),
      ),
    );
  }
}
