import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code on the Rocks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeViewModelBuilder(
        builder: (context, model) {
          return Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(model.counter.value.toString()),
                    ElevatedButton(
                      onPressed: model.isLoading
                          ? () {}
                          : () async {
                              model.incrementCounterWithLoader();
                              model.setLoading(false);
                            },
                      child: const Text('Increment with Loader'),
                    ),
                    ElevatedButton(
                      onPressed: model.isLoading
                          ? () {}
                          : () {
                              model.incrementCounter();
                            },
                      child: const Text('Increment Now'),
                    )
                  ],
                ),
              ),
              if (model.isLoading) const ColoredBox(color: Colors.black12, child: Center(child: CircularProgressIndicator()))
            ],
          );
        },
      ),
    );
  }
}

class HomeViewModelBuilder extends ViewModelBuilder<HomeViewModel> {
  const HomeViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => HomeViewModel();
}

class HomeViewModel extends ViewModel<HomeViewModel> {

  static HomeViewModel of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ViewModelProvider>()!.state) as HomeViewModel;

  ValueNotifier<int> counter = ValueNotifier(0);

  Future<void> incrementCounterWithLoader() async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    counter.value = counter.value + 1;
    setLoading(false);
  }

  void incrementCounter() {
    setState(() {
      counter.value++;
    });
  }
}
