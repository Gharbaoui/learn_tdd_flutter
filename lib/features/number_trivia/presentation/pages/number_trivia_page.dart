import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: buildBody(context),
    );
  }
}

BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => serviceLocator<NumberTriviaBloc>(),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            //! top half
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: const Placeholder(),
            ),
            //! bottom half
            const SizedBox(height: 20),
            Column(
              children: [
                const Placeholder(fallbackHeight: 40),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      child: Placeholder(fallbackHeight: 30),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Placeholder(
                        fallbackHeight: 30,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
