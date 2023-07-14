import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>(
      modelToRegister: HomeViewModel(),
      builder: (context, model, child) {
        return  Scaffold(body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(model.counter.value.toString()),
              ElevatedButton(onPressed: (){
                model.setCounter(model.counter.value + 1);
              }, child: Text('Increment'))
            ],
          ),
        ));
      },
    );
  }
}

class HomeViewModel extends ChangeNotifier {
  ValueNotifier<bool> loading = ValueNotifier(false);

  ValueNotifier<int> counter = ValueNotifier(0);

  void setCounter(int val){
    counter.value = val;
    notifyListeners();
  }

  bool get isLoading => loading.value;

  void setLoading(bool val) {
    loading.value = val;
    notifyListeners();
  }
}
