import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' show Random;

class LoadingPage extends StatelessWidget {
  final String text;
  const LoadingPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            const ShowLoadingImage(),
            ShowLoadingMessage(text: text)
          ],
        ),
      ),
    );
  }
}

class ShowLoadingImage extends StatelessWidget {
  const ShowLoadingImage({
    super.key, 
  });


  @override
  Widget build(BuildContext context) {
    var random = Random();
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        (kIsWeb) ? 'assets/images/loading-images/loading-image-web-${random.nextInt(8) + 1}.png' : 'assets/images/loading-images/loading-image-${random.nextInt(11) + 1}.png',
        fit: !kIsWeb ? BoxFit.cover : BoxFit.fill,
      ),
    );
  }
}

class ShowLoadingMessage extends StatelessWidget {
  final String text;
  const ShowLoadingMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}
