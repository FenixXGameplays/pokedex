import 'package:flutter/material.dart';
import 'package:pokedex/screens/pokedex/pokedex_screen.dart';

import '../captured/captured_page.dart';


class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({super.key});

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  var _currentPage = 0;
  final _pages = [
    const PokedexScreen(),
    const CapturedPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_currentPage),
      ),

      bottomNavigationBar: 
           BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt_outlined), label: "Pokedex"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.catching_pokemon_outlined),
                    label: "Captured"),
              ],
              currentIndex: _currentPage,
              type: BottomNavigationBarType.fixed,
              onTap: (int inIndex) {
                setState(() {
                  _currentPage = inIndex;
                });
              },
            )
          /*: null,*/
    );
  }
}
