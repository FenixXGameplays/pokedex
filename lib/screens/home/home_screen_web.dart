import 'package:flutter/material.dart';
import 'package:pokedex/screens/captured/captured_page.dart';
import 'package:pokedex/screens/pokedex/pokedex_screen.dart';


class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
        var _currentPage = 0;
  final _pages = [
    const PokedexScreen(),
    const CapturedPage(),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              child:  
              TextButton.icon(
                label: const Text("Pokedex"),
                style: _currentPage == 0 ? 
                const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.amber)
                ): null,
              icon: const  Icon(Icons.list_alt_outlined),
              onPressed: () {
                setState(() {
                  _currentPage = 0;
                });
              },),
              
            ),
            const SizedBox(width: 24),
            GestureDetector(
              child:  
              TextButton.icon(
                label: const Text("Captured"),
                style: _currentPage == 1 ? 
                const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.amber)
                ): null,
              icon: const Icon(Icons.catching_pokemon_outlined),
              onPressed: () {
                setState(() {
                  _currentPage = 1;
                });
              },),
              
            ),
          ],
        ),
      ),
      body: Center(
        child: _pages.elementAt(_currentPage),
      ),
    );
  }
}
