import 'package:flutter/material.dart';
import 'package:sketch_book/app/widgets/theme.dart';
import 'package:sketch_book/view/home_page.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.dark);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: lightTheme(mode),
          darkTheme: darkTheme(mode),
          home: const HomePage(),
        );
      },
    );
  }
}
