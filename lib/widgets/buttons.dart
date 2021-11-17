import 'package:flutter/material.dart';

Widget buildYellowButton({
  required VoidCallback handler,
  required Widget child,
  required Color color,
  required double h,
  required double w,
  required double radius,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(radius),
    onTap:
        handler, //() {}, //=> Navigator.of(context).pushNamed('/search-advanced'),
    child: Container(
      width: w,
      height: h,
      alignment: Alignment.center,
      child: child,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
