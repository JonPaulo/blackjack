import 'package:flutter/material.dart';
import 'package:blackjack/screens/game_screen.dart';

class App extends StatelessWidget {
  final String title;

  App({this.title});

  static final routes = {
    GameScreen.routeName: (context) => GameScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      routes: routes,
    );
  }
}
