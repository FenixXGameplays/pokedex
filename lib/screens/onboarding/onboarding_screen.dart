import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_pages.dart';
class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo(
      {required this.title, required this.caption, required this.imageUrl});
}

final slides = <SlideInfo>[
  SlideInfo(
      title: "Pokedex",
      caption: "You'll see all the pokemons from Generation 1",
      imageUrl: 'assets/images/onboarding/onboarding-1.png'),
  SlideInfo(
      title: "Captured",
      caption: "How many Pokemons you'll be able to capture",
      imageUrl: 'assets/images/onboarding/onboarding-2.png'),
  SlideInfo(
      title: "Pokemon Details",
      caption:
          "You can meet information about every pokemon you want",
      imageUrl: 'assets/images/onboarding/onboarding-3.png'),
];

class OnboardingScreen extends StatefulWidget {
  static const routeName = 'app_tutorial';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageViewController = PageController();
  bool endReached = false;

  @override
  void initState() {
    super.initState();
    pageViewController.addListener(() {
      final page = pageViewController.page ?? 0;
      if(!endReached && page >= (slides.length - 1.5)){
        endReached = true;
        setState(() {
          
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageViewController,
            physics: const BouncingScrollPhysics(),
            children: slides.map((slide) => _Slide(info: slide)).toList(),
          ),
          Positioned(
            right: 20,
            top: 30,
            child: TextButton(
              onPressed: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("onboarding", true);
                Get.offAndToNamed(Routes.home);
              },
              child: const Text("Skip"),
            ),
          ),
          endReached
              ? Positioned(
                  bottom: 20,
                  right: 30,
                  child: FadeInRight(
                    from: 15,
                    delay: const Duration(milliseconds: 500),
                    child: FilledButton(
                      onPressed: () async{
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("onboarding", true);
                        Get.offAndToNamed(Routes.home);
                      },
                      child: const Text("Comenzar"),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
  
}

class _Slide extends StatelessWidget {
  final SlideInfo info;
  const _Slide({required this.info});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final captionStyle = Theme.of(context).textTheme.bodySmall;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(info.imageUrl,fit: BoxFit.fill,),
              ),
              const SizedBox(height: 20),
              Text(
                info.title,
                style: titleStyle,
              ),
              const SizedBox(height: 10),
              Text(
                info.caption,
                style: captionStyle,
              ),
            ],
          ),
        ));
  }
}
