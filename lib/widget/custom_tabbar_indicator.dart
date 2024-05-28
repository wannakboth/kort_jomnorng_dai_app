// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final BoxDecoration boxDecoration;
  final double indicatorWidth;

  const CustomTabIndicator({required this.boxDecoration, required this.indicatorWidth});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(boxDecoration, indicatorWidth);
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final BoxDecoration boxDecoration;
  final double indicatorWidth;

  _CustomTabIndicatorPainter(this.boxDecoration, this.indicatorWidth);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    final BoxPainter painter = boxDecoration.createBoxPainter();
    final Rect rect = Offset(
      offset.dx + (configuration.size!.width / 2 - indicatorWidth / 2),
      offset.dy,
    ) & Size(indicatorWidth, configuration.size!.height);
    painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }
}
