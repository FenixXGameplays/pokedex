import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/screens/captured/captured_screen_mobile.dart';
import 'package:pokedex/screens/captured/captured_screen_web.dart';

class CapturedPage extends StatelessWidget {
  const CapturedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: kIsWeb
      ? CapturedScreenWeb()
      : CapturedScreenMobile(),
    );
  }
}