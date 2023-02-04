import 'package:flutter/material.dart';
import 'package:sketch_book/view/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'GothicAXHand',
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
