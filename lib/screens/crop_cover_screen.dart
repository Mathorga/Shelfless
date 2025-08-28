import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:crop_image/crop_image.dart';

import 'package:shelfless/dialogs/error_dialog.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';

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
    aspectRatio: 1.0 / 1.0,
  );
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO Move to strings!
        title: Text("Crop image"),
        actions: [],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(Themes.spacingLarge),
            child: Column(
              spacing: Themes.spacingMedium,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Themes.spacingMedium),
                    child: CropImage(
                      controller: _controller,
                      image: widget.image,

                      /// The size of the corner of the crop grid. Defaults to 25.
                      gridCornerSize: Themes.spacingLarge,
                      gridThinWidth: Themes.borderSideThin,
                      gridThickWidth: Themes.borderSideThick,
                      alwaysShowThirdLines: true,
                    ),
                  ),
                ),
                Row(
                  spacing: Themes.spacingMedium,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: Themes.spacingFAB,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(strings.cancel),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: Themes.spacingFAB,
                        child: FloatingActionButton(
                          onPressed: () async {
                            // Prefetch handlers before async gaps.
                            final NavigatorState navigator = Navigator.of(context);

                            setState(() {
                              _loading = true;
                            });

                            final ui.Image result;
                            Uint8List? resultData;

                            try {
                              result = await _controller.croppedBitmap();
                              resultData = (await result.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
                            } catch (e) {
                              // Stop showing the loading indicator.
                              setState(() {
                                _loading = false;
                              });

                              // Let the user know something went wrong.
                              if (context.mounted) showUnexpectedErrorDialog(context);

                              return;
                            }

                            if (resultData == null) {
                              navigator.pop();
                              return;
                            }

                            navigator.pop(resultData);
                          },
                          child: Text(strings.editDone),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_loading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
