import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/foundation.dart';

class CounterViewModel<T> extends ViewModel<T> {
  ValueNotifier<int> counter = ValueNotifier(0);

  void increment() {
    setState(() {
      counter.value = counter.value + 1;
    });
  }
}
