library code_on_the_rocks;

import 'package:flutter/material.dart';

typedef ModelBuilder<TViewModel> = Widget Function(BuildContext context, TViewModel model);

abstract class ViewModelBuilder<TViewModel extends ViewModel> extends StatefulWidget {
  const ViewModelBuilder({Key? key, required this.builder}) : super(key: key);
  final ModelBuilder builder;
}

class ViewModel<TViewModel> extends State<ViewModelBuilder> {
  ValueNotifier<bool> loading = ValueNotifier(false);

  bool get isLoading => loading.value;

  void setLoading(bool val) {
    setState(() {
      loading.value = val;
    });
  }

  @override
  Widget build(BuildContext context) => ViewModelProvider(
        state: this,
        child: Builder(
          builder: (context) {
            return widget.builder(context, this);
          },
        ),
      );
}

class ViewModelProvider extends InheritedWidget {
  const ViewModelProvider({Key? key, required Widget child, required this.state}) : super(key: key, child: child);
  final ViewModel state;

  @override
  // Always rebuild children if state changes
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
