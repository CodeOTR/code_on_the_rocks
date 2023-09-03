import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

mixin ColorMixin<T> on ViewModel<T> {
  ValueNotifier<Color> color = ValueNotifier(Colors.blue);

  void setColor(Color val) {
    color.value = val;
  }
}
