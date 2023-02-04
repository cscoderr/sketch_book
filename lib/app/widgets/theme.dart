import 'package:flutter/material.dart';

ThemeData lightTheme(ThemeMode mode) => ThemeData.light().copyWith(
      textTheme: TextTheme(
        headlineMedium: const TextStyle(
          fontFamily: 'GothicAXHand',
        ),
        labelLarge: TextStyle(
          fontFamily: 'GothicAXHand',
          color: mode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
    );

ThemeData darkTheme(ThemeMode mode) => ThemeData.dark().copyWith(
      textTheme: TextTheme(
        headlineMedium: const TextStyle(
          fontFamily: 'GothicAXHand',
        ),
        labelLarge: TextStyle(
          fontFamily: 'GothicAXHand',
          color: mode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
    );
