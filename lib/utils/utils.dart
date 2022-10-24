import 'dart:math';

class Utils {
  static int randomColor() => (Random().nextDouble() * 0x00FFFFFF + 0xFF000000).toInt();
}