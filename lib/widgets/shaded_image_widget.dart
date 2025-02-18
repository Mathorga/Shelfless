import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;

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
      shader.setFloat(i + 2, uniforms[i]);
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

  const ShadedImageWidget({
    super.key,
    required this.imageData,
  });

  @override
  State<ShadedImageWidget> createState() => _ShadedImageWidgetState();
}

class _ShadedImageWidgetState extends State<ShadedImageWidget> {
  late Timer _timer;
  double _delta = 0;
  ui.Image? _image;
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    loadMyShader();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void loadMyShader() async {
    final ui.Codec codec = await ui.instantiateImageCodec(
      widget.imageData,
      // targetWidth: 512,
      // targetHeight: 512,
      allowUpscaling: false,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    setState(() {
      _image = frameInfo.image;
    });

    ui.FragmentProgram program = await ui.FragmentProgram.fromAsset("shaders/blur_upscale.frag.glsl");
    _shader = program.fragmentShader();
    setState(() {
      // trigger a repaint
    });

    _timer = Timer.periodic(
      const Duration(milliseconds: 16),
      (Timer timer) {
        // setState(() {
        //   _delta += 1 / 60;
        // });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_shader == null || _image == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return CustomPaint(
        painter: ShaderPainter(
          _shader!,
          [_delta],
          [_image],
        ),
      );
    }
  }
}
