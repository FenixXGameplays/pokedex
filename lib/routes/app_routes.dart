
import 'package:get/get.dart';
import 'package:pokedex/routes/app_pages.dart';
import 'package:pokedex/screens/details/details_page.dart';
import 'package:pokedex/screens/home/home_page.dart';
import 'package:pokedex/screens/onboarding/onboarding_screen.dart';
import 'package:pokedex/screens/pokedex/pokedex_screen.dart';

import '../screens/captured/captured_page.dart';


abstract class AppRoutes {

  static final pages = [
    GetPage(name: Routes.onboarding, page:() => const OnboardingScreen(), transition: Transition.native),
    GetPage(name: Routes.home, page:() => const HomePage(), transition: Transition.native),
    GetPage(name: Routes.detail, page: () => const DetailsPage(), transition: Transition.native),
    GetPage(name: Routes.pokedex, page: () => const PokedexScreen(), transition: Transition.native),
    GetPage(name: Routes.captured, page: () => const CapturedPage(), transition: Transition.native),
  ];
}