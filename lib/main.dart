import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/pokemon_controller.dart';
import 'package:pokedex/routes/app_pages.dart';
import 'package:pokedex/routes/app_routes.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _subscription = InternetConnection().onStatusChange.listen((status) {
        Get.put(PokemonController());
        final ctrl = Get.find<PokemonController>();
        switch (status) {
          case InternetStatus.connected:
            ctrl.hasInternet = true;
            break;
          case InternetStatus.disconnected:
            ctrl.hasInternet = false;
            break;
        }
      });

      _listener = AppLifecycleListener(
        onResume: _subscription.resume,
        onHide: _subscription.pause,
        onPause: _subscription.pause,
      );
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _subscription.cancel();
      _listener.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PokemonController());
    final ctrl = Get.find<PokemonController>();
    return GetBuilder<PokemonController>(
      initState: (state) async{
        await ctrl.getDatabaseData();
      } ,
      id: 'updateTheme',
      builder: (controller) {
        return GetMaterialApp(
          getPages: AppRoutes.pages,
          debugShowCheckedModeBanner: false,
          initialRoute: (!kIsWeb &&
                  (prefs.getBool("onboarding") == null ||
                      prefs.getBool("onboarding") == false))
              ? Routes.onboarding
              : Routes.home,
          theme: Get.find<PokemonController>().appTheme.getTheme(),
          title: "Pokedex",
        );
      },
    );
  }
}
