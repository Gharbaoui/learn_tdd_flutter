import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_controlls.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:number_trivia/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: SingleChildScrollView(child: buildBody(context)),
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
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case EmptyNumberTriviaState:
                    return const MessageDisplay(message: 'Start Searching...');
                  case ErrorNumberTriviaState:
                    return MessageDisplay(
                      message: (state as ErrorNumberTriviaState).errorMessage,
                    );
                  case LoadingNumberTriviaState:
                    return const LoadingWidget();
                  case LoadedNumberTriviaState:
                    return TriviaDisplay(
                      numberTrivia:
                          (state as LoadedNumberTriviaState).numberTrivia,
                    );
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: const Placeholder(),
                );
              },
            ),
            //! bottom half
            const SizedBox(height: 20),
            const TriviaControls()
          ],
        ),
      ),
    ),
  );
}
