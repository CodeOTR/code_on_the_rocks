library code_on_the_rocks;

import 'package:flutter/material.dart';

typedef ModelBuilder<TViewModel> = Widget Function(BuildContext context, TViewModel model);

abstract class ViewModelBuilder<TViewModel> extends StatefulWidget {
  const ViewModelBuilder({Key? key, required this.builder}) : super(key: key);
  final ModelBuilder<TViewModel> builder;
}

T getModel<T>(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ViewModelProvider<ViewModel<T>>>()!.state) as T;

abstract class ViewModel<T> extends State<ViewModelBuilder<T>> {

  T of(BuildContext context) => getModel<T>(context);

  ValueNotifier<bool> loading = ValueNotifier(false);

  bool get isLoading => loading.value;

  void setLoading(bool val) {
    setState(() {
      loading.value = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      state: this,
      child: Builder(
        builder: (context) {
          return widget.builder(context, this as T);
        },
      ),
    );
  }
}

class ViewModelProvider<TViewModel extends ViewModel> extends InheritedWidget {
  const ViewModelProvider({Key? key, required Widget child, required this.state}) : super(key: key, child: child);
  final TViewModel state;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
