import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_data.dart';

import '../../controller/pokemon_controller.dart';
import '../../model/pokemon_detail/pokemon_detail_database.dart';
import '../../routes/app_pages.dart';
import '../../utils/utils.dart';
import '../../utils/widgets.dart';
import '../loading/loading_screen.dart';

FocusNode myFocusNode = FocusNode();

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PokemonController>();
    final textCtrl = TextEditingController(text: "");

    return GetBuilder<PokemonController>(
      initState: (state) => ctrl.getPokemons(),
      id: 'listOfPokemons',
      builder: (controller) {
        if (controller.loading) {
          return const LoadingPage(
            text: "Retrieving Data From Server.\nWait a Minute...",
          );
        }
        

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: _AppBarTitle(controller: controller),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SearchName(textCtrl: textCtrl, ctrl: ctrl),
              Expanded(child: _ShowPokemonCard(controller: controller)),
            ],
          ),
        );
      },
    );
  }
}

class _SearchName extends StatelessWidget {
  const _SearchName({
    required this.textCtrl,
    required this.ctrl,
  });

  final TextEditingController textCtrl;
  final PokemonController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        focusNode: myFocusNode,
        controller: textCtrl,
        onChanged: (value) {
          ctrl.getPokemonsFilteredBySearch(textCtrl.text);
        },
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          hintText: "Search",
          suffixIcon: textCtrl.text.isEmpty
              ? const Icon(Icons.search)
              : GestureDetector(
                  child: const Icon(Icons.close),
                  onTap: () {
                    textCtrl.text = "";
                    ctrl.getPokemonsFilteredBySearch(textCtrl.text);
                  },
                ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  final PokemonController controller;

  const _AppBarTitle({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        controller.pokemons.mainRegion?.name ?? "",
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }
}

class _ShowPokemonCard extends StatelessWidget {
  final PokemonController controller;
  const _ShowPokemonCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return controller.pokemonsDetailsFiltered.isNotEmpty
        ? _WithDataSearch(controller: controller)
        : const _EmptySearch();
  }
}

class _WithDataSearch extends StatelessWidget {
  const _WithDataSearch({
    required this.controller,
  });

  final PokemonController controller;

  @override
  Widget build(BuildContext context) {
    return (kIsWeb)
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 1280) {
                return _ListPokemons(
                  controller: controller,
                  maxColumns: 6,
                );
              } else if (constraints.maxWidth < 1280 &&
                  constraints.maxWidth > 960) {
                return _ListPokemons(
                  controller: controller,
                  maxColumns: 4,
                );
              } else {
                return _ListPokemons(
                  controller: controller,
                  maxColumns: 2,
                );
              }
            },
          )
        : _ListPokemons(
            controller: controller,
            maxColumns: 2,
          );
  }
}

class _ListPokemons extends StatelessWidget {
  const _ListPokemons({
    required this.maxColumns,
    required this.controller,
  });

  final int maxColumns;
  final PokemonController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: maxColumns,
      children: List.generate(
        controller.pokemonsDetailsFiltered.length,
        (index) {
          final pokemonData = controller.pokemonsDetailsFiltered[index];

          var boxDecoration = BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color:
                    getPokemonTypeBackground(pokemonData.types?[0].type?.name),
                width: 1),
          );

          return GestureDetector(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: boxDecoration,
                  child: _ShowDataPokemon(pokemonData: pokemonData),
                ),
                ContainerId(pokemonData: pokemonData),
              ],
            ),
            onTap: () async {
              myFocusNode.unfocus();
              if (kIsWeb) {
                Get.toNamed(Routes.detail,
                    arguments: {"pokemonDetail": pokemonData});
              } else {
                var imageBytes = await getBytesImage(pokemonData.id);
                Get.toNamed(
                  Routes.detail,
                  arguments: {
                    "pokemonDetailDatabase": PokemonDetailDatabase(
                        idPokemon: pokemonData.id,
                        pokeData: pokemonData,
                        imageBytes: imageBytes)
                  },
                );
              }
            },
          );
          //return Text(controller.pokemons.pokemonSpecies[index].name);
        },
      ),
    );
  }
}



class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Image.asset("assets/images/empty-pokedex.png"),
            Text(
              "No Data available",
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }
}

class _ShowDataPokemon extends StatelessWidget {
  const _ShowDataPokemon({
    required this.pokemonData,
  });

  final PokemonDetailData pokemonData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: ShowPokemonImage(pokemonData: pokemonData)),
        _ShowNamePokemon(pokemonData: pokemonData)
      ],
    );
  }
}

class _ShowNamePokemon extends StatelessWidget {
  const _ShowNamePokemon({
    required this.pokemonData,
  });

  final PokemonDetailData pokemonData;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      color: getPokemonTypeBackground(pokemonData.types?[0].type?.name),
    );

    return Container(
      width: double.infinity,
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${pokemonData.name!.capitalize}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
