import 'package:flutter/material.dart';

class HorizontalSeparator extends StatelessWidget {
  final double width;

  const HorizontalSeparator({Key key, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
