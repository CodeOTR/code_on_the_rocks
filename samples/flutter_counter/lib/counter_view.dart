import 'package:flutter/material.dart';
import 'package:flutter_counter/counter_view_model.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CounterViewModelBuilder(
      builder: (context, model) {
        print('Building CounterView');
        return Scaffold(
          appBar: AppBar(title: const Text('Counter')),
          body: Center(child: Text('${model.counter}')),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                key: const Key('increment'),
                child: const Icon(Icons.add),
                onPressed: () => CounterViewModel.of_(context).increment(),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                key: const Key('decrement'),
                child: const Icon(Icons.remove),
                onPressed: () => CounterViewModel.of_(context).decrement(),
              ),
            ],
          ),
        );
      },
    );
  }
}
