import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'details_screen_mobile.dart';
import 'details_screen_web.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: kIsWeb
      ? DetailsScreenWeb()
      : DetailsScreenMobile(),
    );
  }
}