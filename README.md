# 🍹Code on the Rocks
A bold and balanced state management library that pairs MVVM structures with the simplicity of InheritedWidget.

## Inspiration
Over the years I've become a big fan of several different "state-management" solutions:

- [InheritedWidgets](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) are powerful widgets built into the Flutter Framework
- [Stacked](https://pub.dev/packages/stacked) is an opinionated MVVM library that uses ViewModels, ViewModelBuilders, and ViewModelWidgets
- [get_it](https://pub.dev/packages/get_it) lets you easily access services from anywhere in your app
- [get_it_mixin](https://pub.dev/packages/get_it_mixin) lets you bind views to services stored in GetIt

This package is an attempt to combine the best parts of these solutions into a single package that is easy to use and understand. The main benefits are listed here:

### 💙 Pure Flutter

ViewModelProviders are InheritedWidgets, meaning you can access them the using methods built into the Flutter framework. Since the ViewModel is a property on the ViewModelProvider, you can access it using the [dependOnInheritedWidgetOfExactType](https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html) context method. This package sets that up for you so can just do this:

```dart
 HomeViewModel model = HomeViewModel().of(context);
```

### 🍋 Easy Model Usage
The ViewModelProvider _provides_ your model to its children through its builder property so most of the time you won't need to add code to access the model.

```dart
return Scaffold(
      body: HomeViewModelBuilder(
        builder: (context, model) {
          return ... // Use the model to render your UI
        },
      ),
    );
```

### 🔥 No Bloat

This entire library is 46 lines of dart code with no external dependencies. 

## Setup

**Step 1**: 

Create a ViewModel. The ViewModel is a [State](https://api.flutter.dev/flutter/widgets/State-class.html) object that introduces an InheritedWidget to the widget tree. This is where your business logic will live.
```dart
class HomeViewModel extends ViewModel<HomeViewModel> {
  
  // For convenience, you can add a static .of_ getter. This is optional
  static HomeViewModel of_(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ViewModelProvider<ViewModel<HomeViewModel>>>()!.state) as HomeViewModel;


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
**Step 2**: 

Create a ViewModelBuilder. The ViewModelBuilder is a [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) that you will include in your widget tree. ViewModelBuilder creates the ViewModel from above.
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

## Usage
Once you have your ViewModel and ViewModelBuilder, add the ViewModelBuilder to your widget tree:
```dart
return Scaffold(
      body: HomeViewModelBuilder(
        builder: (context, model) {
          return Text('Test')
        },
      ),
    );
```
You can access the ViewModel using the provided "model" object:
```dart
return Scaffold(
      body: HomeViewModelBuilder(
        builder: (context, model) {
          return Text(model.title); // Add a title String to your ViewModel
        },
      ),
    );
```
Or you can use the built in .of() method. This is useful if you break your widget tree up and need to access the model in a different widget:
```dart
return Scaffold(
      body: HomeViewModelBuilder(
        builder: (context, model) {
          return Text(HomeViewModel().of(context).title); // Add a title String to your ViewModel
        },
      ),
    );
```
The .of(context) method only works on an instance of your ViewModel since [static members can' reference type parameters of a class](https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=type_parameter_referenced_by_static#type_parameter_referenced_by_static). If you want to save yourself the time it takes to type the extra parenthesis, add a separate method directly in your View Model (classes can't have instance and static methods with the same name, hence the ".of_" vs ".of"):
```dart
class HomeViewModel extends ViewModel<HomeViewModel> {

  // Add this
  static HomeViewModel of_(BuildContext context) => getModel<HomeViewModel>(context);
}
```

To update your UI after a change in the ViewModel, you have two options. 
1. Call `setState` to rebuild the entire widget tree inside your ViewModelBuilder
2. Use a combination of ValueNotifiers and ValueListenableBuilders to selectively rebuild parts of the UI

You can see examples of each of these approaches in the example directory.

## Advanced Usage
### Initialize and Dispose
Since the ViewModel object extends the State class, you can simply override [initState](https://api.flutter.dev/flutter/widgets/State/initState.html) and [dispose](https://api.flutter.dev/flutter/widgets/State/dispose.html) to run code when the ViewModel is added and removed from the widget tree, respectively: 
```dart
class HomeViewModel extends ViewModel<HomeViewModel> {

  @override
  void initState() {
    debugPrint('Initialize');
    super.initState();
  }
  
  @override
  void dispose() {
    debugPrint('Dispose');
    super.dispose();
  }
}
```

### Set Loading
ViewModels include a single ValueNotifier that can be used to mark it as "loading":
```dart
ValueNotifier<bool> loading = ValueNotifier(false);

bool get isLoading => loading.value;

void setLoading(bool val) {
  setState(() {
    loading.value = val;
  });
}
```
For example, you can call `model.setLoading(true)` when the ViewModel needs to load asynchronous data. When the data is loaded, call `model.setLoading(false)`. In your UI, you can show a spinner if the loading value is true using the model directly. _Whenever the loading value is changed, the entire UI inside the ViewModelBuilder will be rebuilt._
```dart
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeViewModelBuilder(
      builder: (context, model) {
        return Scaffold(
          appBar: AppBar(title: Text(model.title)),
          body: Stack(
            children: [
              Text('Hello World!')
              if (model.isLoading) const ColoredBox(color: Colors.black12, child: Center(child: CircularProgressIndicator()))
            ],
          ),
        );
      },
    );
  }
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
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

class $Name$ViewModelBuilder extends ViewModelBuilder<$Name$ViewModel> {
  const $Name$ViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => $Name$ViewModel();
}

class $Name$ViewModel extends ViewModel<$Name$ViewModel> {
  static $Name$ViewModel of_(BuildContext context) => getModel<$Name$ViewModel>(context);
}
```

You can read more about using variables in Live Templates [here](https://www.jetbrains.com/help/idea/template-variables.html#example_live_template_variables).