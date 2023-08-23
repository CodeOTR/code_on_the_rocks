import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:example/two.dart';
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
    return HomeViewModelBuilder(
      builder: (context, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.title),
          ),
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: model.counter,
                        builder: (context, value, child) =>
                            Text(value.toString())),
                    const SeparatedCounter(),
                    ElevatedButton(
                      onPressed: model.isLoading
                          ? () {}
                          : () async {
                              HomeViewModel()
                                  .of(context)
                                  .incrementCounterWithSetState();
                              model.setLoading(false);
                            },
                      child: const Text('Increment using setState'),
                    ),
                    ElevatedButton(
                      onPressed: model.isLoading
                          ? () {}
                          : () {
                              model.incrementCounterWithValueNotifier();
                            },
                      child: const Text('Increment using ValueNotifier'),
                    )
                  ],
                ),
              ),
              if (model.isLoading)
                const ColoredBox(
                    color: Colors.black12,
                    child: Center(child: CircularProgressIndicator()))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScreenTwoView(),
                ),
              );
            },
            child: const Icon(Icons.navigate_next),
          ),
        );
      },
    );
  }
}

class SeparatedCounter extends StatelessWidget {
  const SeparatedCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(HomeViewModel().of(context).counter.value.toString());
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
  static HomeViewModel of_(BuildContext context) =>
      getModel<HomeViewModel>(context);

  final String title = 'Home';

  ValueNotifier<int> counter = ValueNotifier(0);

  Future<void> incrementCounterWithSetState() async {
    setState(() {
      counter.value = counter.value + 1;
    });
  }

  void incrementCounterWithValueNotifier() {
    counter.value++;
  }

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
