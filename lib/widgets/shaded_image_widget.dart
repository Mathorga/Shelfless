import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final List<double> uniforms;
  final List<ui.Image?> images;

  ShaderPainter(
    ui.FragmentShader fragmentShader,
    this.uniforms,
    this.images,
  ) : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < images.length; i++) {
      shader.setImageSampler(i, images[i]!);
    }
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    for (int i = 0; i < uniforms.length; i++) {
      shader.setFloat(i, uniforms[i]);
    }

    final Paint paint = Paint();

    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShadedImageWidget extends StatefulWidget {
  final Uint8List imageData;
  final int? upscaleWidth;
  final int? upscaleHeight;
  final bool applyFilter;

  const ShadedImageWidget({
    super.key,
    required this.imageData,
    this.upscaleWidth,
    this.upscaleHeight,
    this.applyFilter = false,
  });

  @override
  State<ShadedImageWidget> createState() => _ShadedImageWidgetState();
}

class _ShadedImageWidgetState extends State<ShadedImageWidget> {
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    loadShader();
  }


  Future<void> loadShader() async {
    ui.FragmentProgram program = await ui.FragmentProgram.fromAsset("shaders/clean_edge.frag.glsl");
    _shader = program.fragmentShader();
    setState(() {
      // trigger a repaint
    });
  }

  Future<ui.Image> _decodeImage() async {
    final ui.Codec codec = await ui.instantiateImageCodec(
      widget.imageData,
      targetWidth: widget.upscaleWidth,
      targetHeight: widget.upscaleHeight,
      allowUpscaling: widget.applyFilter,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    return frameInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _decodeImage(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          // TODO Handle this better pls.
          return Placeholder();
        }

        if (!snapshot.hasData) {
          // TODO Handle this better pls.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final ui.Image image = snapshot.data;

        if (_shader == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return CustomPaint(
          painter: ShaderPainter(
            _shader!,
            [
              16.0,
              16.0,
            ],
            [
              image,
            ],
          ),
        );
      },
    );
  }
}
