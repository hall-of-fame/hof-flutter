import 'package:flutter/material.dart';

int getCrossAxisCount(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 750) {
    return 2;
  } else if (width < 1000) {
    return 3;
  } else {
    return 4;
  }
}
