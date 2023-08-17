import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

class CounterViewModelBuilder extends ViewModelBuilder<CounterViewModel> {
  const CounterViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => CounterViewModel();
}

class CounterViewModel extends ViewModel<CounterViewModel> {
  int counter = 0;

  void increment() {
    setState(() => counter = counter + 1);
  }

  void decrement() {
    setState(() => counter = counter - 1);
  }

  static CounterViewModel of_(BuildContext context) => getModel<CounterViewModel>(context);
}
