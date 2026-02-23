import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  const OutlinedText(
    this.text, {
    required this.style,
    this.strokeColor = Colors.black,
    this.strokeWidth = 2,
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle style;
  final Color strokeColor;
  final double strokeWidth;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final dx in [-strokeWidth, 0.0, strokeWidth])
          for (final dy in [-strokeWidth, 0.0, strokeWidth])
            if (dx != 0 || dy != 0)
              Transform.translate(
                offset: Offset(dx, dy),
                child: Text(
                  text,
                  textAlign: textAlign,
                  style: style.copyWith(color: strokeColor),
                ),
              ),
        Text(text, textAlign: textAlign, style: style),
      ],
    );
  }
}
