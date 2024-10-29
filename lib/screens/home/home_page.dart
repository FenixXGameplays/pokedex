import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/screens/home/home_screen_mobile.dart';
import 'package:pokedex/screens/home/home_screen_web.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kIsWeb
      ? HomeScreenWeb()
      : const HomeScreenMobile(),
    );
  }
}