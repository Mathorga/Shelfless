import 'package:flutter/material.dart';

import 'package:crop_image/crop_image.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/config.dart';

class CropCoverScreen extends StatefulWidget {
  final Image image;

  const CropCoverScreen({
    super.key,
    required this.image,
  });

  @override
  State<CropCoverScreen> createState() => _CropCoverScreenState();
}

class _CropCoverScreenState extends State<CropCoverScreen> {
  final CropController _controller = CropController(
    aspectRatio: 1 / 1,
    defaultCrop: Rect.fromLTRB(
      0.2,
      0.2,
      0.8,
      0.8,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO Move to strings!
        title: Text("Crop image"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Themes.spacingMedium),
        child: Column(
          spacing: Themes.spacingMedium,
          children: [
            Expanded(
              child: CropImage(
                controller: _controller,
                image: widget.image,

                /// The size of the corner of the crop grid. Defaults to 25.
                gridCornerSize: 50.0,

                /// The width of the crop grid thin lines. Defaults to 2.
                gridThinWidth: 1.0,

                /// The width of the crop grid thick lines. Defaults to 5.
                gridThickWidth: 3.0,
                alwaysShowThirdLines: true,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                // TODO Move to strings!
                child: Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
