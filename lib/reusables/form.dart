
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormBorder extends OutlineInputBorder {
  const FormBorder({
    BorderSide borderSide: const BorderSide(),
    BorderRadius borderRadius: const BorderRadius.all(Radius.circular(2.0)),
    this.cut: 7.0,
    double gapPadding: 2.0,
  }) : super(
      borderSide: borderSide,
      borderRadius: borderRadius,
      gapPadding: gapPadding);

  @override
  FormBorder copyWith({
    BorderSide borderSide,
    BorderRadius borderRadius,
    double gapPadding,
    double cut,
  }) {
    return FormBorder(
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      cut: cut ?? this.cut,
      gapPadding: gapPadding ?? this.gapPadding,
    );
  }

  final double cut;

  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    if (a is FormBorder) {
      final FormBorder outline = a;
      return FormBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t),
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
        cut: cut,
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    if (b is FormBorder) {
      final FormBorder outline = b;
      return FormBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t),
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        cut: cut,
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpTo(b, t);
  }

  Path _notchedCornerPath(Rect center,
      [double start = 0.0, double extent = 0.0]) {
    final Path path = Path();

    return path;
  }

  @override
  void paint(
      Canvas canvas,
      Rect rect, {
        double gapStart,
        double gapExtent: 0.0,
        double gapPercentage: 0.0,
        TextDirection textDirection,
      }) {
    assert(gapExtent != null);
    assert(gapPercentage >= 0.0 && gapPercentage <= 1.0);

    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(rect);
    if (gapStart == null || gapExtent <= 0.0 || gapPercentage == 0.0) {
      canvas.drawPath(_notchedCornerPath(outer.middleRect), paint);
    } else {
      final double extent =
      lerpDouble(0.0, gapExtent + gapPadding * 2.0, gapPercentage);
      switch (textDirection) {
        case TextDirection.rtl:
          {
            final Path path = _notchedCornerPath(
                outer.middleRect, gapStart + gapPadding - extent, extent);
            canvas.drawPath(path, paint);
            break;
          }
        case TextDirection.ltr:
          {
            final Path path = _notchedCornerPath(
                outer.middleRect, gapStart - gapPadding, extent);
            canvas.drawPath(path, paint);
            break;
          }
      }
    }
  }
}