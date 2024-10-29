import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_data.dart';

import '../../controller/pokemon_controller.dart';
import '../../routes/app_pages.dart';
import '../../utils/utils.dart';
import '../../utils/widgets.dart';
import '../loading/loading_screen.dart';

class CapturedScreenWeb extends StatelessWidget {
  const CapturedScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PokemonController>();

    return GetBuilder<PokemonController>(
      id: 'listOfPokemonsCaptured',
      builder: (controller) {
        if (controller.loading && !controller.firstLoading) {
          return const LoadingPage(text: "Getting data from Server. Wait...");
        }

        ctrl.getPokemonsFilteredByType(ctrl.typeFilter);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: _AppBarTitle(controller: controller),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text("Types"),
                      SearchType(ctrl: ctrl),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Order"),
                      Order(ctrl: ctrl),
                    ],
                  ),
                ],
              ),
              Expanded(child: _ShowPokemonCard(controller: controller)),
            ],
          ),
        );
      },
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
    return controller.pokemonDetailsCapturedFiltered.isNotEmpty
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1280) {
          return _ListPokemonsCaptured(
            controller: controller,
            maxColumns: 6,
          );
        } else if (constraints.maxWidth < 1280 && constraints.maxWidth > 960) {
          return _ListPokemonsCaptured(
            controller: controller,
            maxColumns: 4,
          );
        } else {
          return _ListPokemonsCaptured(
            controller: controller,
            maxColumns: 2,
          );
        }
      },
    );
  }
}

class _ListPokemonsCaptured extends StatelessWidget {
  const _ListPokemonsCaptured({
    required this.maxColumns,
    required this.controller,
  });

  final PokemonController controller;
  final int maxColumns;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: maxColumns,
      children: List.generate(
        controller.pokemonDetailsCapturedFiltered.length,
        (index) {
          final pokemonData = controller.pokemonDetailsCapturedFiltered[index];

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
                  child: _ShowDataPokemon(
                      ctrl: controller, pokemonData: pokemonData),
                ),
                ContainerId(pokemonData: pokemonData),
              ],
            ),
            onTap: () {
              if (isCaptured(controller, pokemonData)) {
                Get.toNamed(Routes.detail,
                    arguments: {"pokemonDetail": pokemonData});
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
    required this.ctrl,
  });

  final PokemonDetailData pokemonData;
  final PokemonController ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: ShowPokemonImageCaptured(
                controller: ctrl, pokemonData: pokemonData)),
        _ShowNamePokemon(
          pokemonData: pokemonData,
          ctrl: ctrl,
        )
      ],
    );
  }
}

class _ShowNamePokemon extends StatelessWidget {
  const _ShowNamePokemon({
    required this.pokemonData,
    required this.ctrl,
  });

  final PokemonDetailData pokemonData;
  final PokemonController ctrl;

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
              isCaptured(ctrl, pokemonData)
                  ? '${pokemonData.name!.capitalize}'
                  : '????',
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
