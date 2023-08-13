# Code on the Rocks
A bold and balanced state management library that pairs MVVM structures with the simplicity of InheritedWidget.

## Inspiration
Over the years I've become a big fan of several different "state-management" solutions:

- [InheritedWidgets](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) are powerful widgets built into the Flutter Framework
- [Stacked](https://pub.dev/packages/stacked) is an opinionated MVVM library that uses ViewModels, ViewModelBuilders, and ViewModelWidgets
- [get_it](https://pub.dev/packages/get_it) lets you easily access services from anywhere in your app
- [get_it_mixin](https://pub.dev/packages/get_it_mixin) lets you bind views to services stored in GetIt

This package is an attempt to combine the best parts of these solutions into a single package that is easy to use and understand. The main benefits are listed here:

**Each ViewModel is included as a property on the ViewModelProvider.** 

ViewModelProviders are InheritedWidgets, meaning you can access them the same way. Since the ViewModel is a property on the ViewModelProvider, you just need to access it like this:

```dart
static HomeViewModel of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ViewModelProvider>()!.state) as HomeViewModel;
```

**The ViewModelProvider _provides_ your model to its children through its builder property**

```dart
return Scaffold(
      body: HomeViewModelBuilder(
        builder: (context, model) {
          return ... // Use the model to render your UI
        },
      ),
    );
```

**No Bloat**

This entire library is 42 lines of dart code with no external dependencies.

## Setup
To get started using this library, you need to create 2 classes - a ViewModelBuilder and a ViewModel. 

The ViewModel is a [State](https://api.flutter.dev/flutter/widgets/State-class.html) object that introduces an InheritedWidget to the widget tree. This is where your business logic will live.
```dart
class HomeViewModel extends ViewModel {
  
  // For convenience, you can add a static .of getter. This is optional
  static HomeViewModel of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ViewModelProvider>()!.state) as HomeViewModel;

  // Here is where you will add your business logic and state properties
  // Notice that you have access to setState here
  ValueNotifier<int> counter = ValueNotifier(0);

  void incrementCounter() {
    setState(() {
      counter.value++;
    });
  }
}
```
The ViewModelBuilder is a widget that you will include in your widget tree. ViewModelBuilder is simply a StatefulWidget that creates the ViewModel from above.
```dart
 class HomeViewModelBuilder extends ViewModelBuilder<HomeViewModel> {
  const HomeViewModelBuilder({
    super.key,
    required super.builder,
  });

  // Override createState to create the specific ViewModel from above
  @override
  State<StatefulWidget> createState() => HomeViewModel();
}
 ```

## IntelliJ Live Templates

### View
```dart
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';
import '$snakeName$_model.dart';

class $Name$View extends StatelessWidget {
  const $Name$View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: $Name$ViewModelBuilder(
        builder: (context, model) {
          return Center(child: Text('$Name$'););
        },
      ),
    );
  }
}
```

### ViewModel and ViewModelBuilder
```dart
import 'package:flutter/foundation.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';

class $Name$ViewModelBuilder extends ViewModelBuilder<$Name$ViewModel> {
  const $Name$ViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => $Name$ViewModel();
}

class $Name$ViewModel extends ViewModel {
  static $Name$ViewModel of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ViewModelProvider>()!.state) as $Name$ViewModel;
}
```

You can read more about using variables in Live Templates [here](https://www.jetbrains.com/help/idea/template-variables.html#example_live_template_variables).