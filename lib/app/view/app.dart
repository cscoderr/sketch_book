import 'package:flutter/material.dart';
import 'package:sketch_book/presentation/home/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'GothicAXHand',
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
