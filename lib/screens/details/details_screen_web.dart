import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_data.dart';
import 'package:pokedex/utils/utils.dart';

import '../../controller/pokemon_controller.dart';
import '../../utils/widgets.dart';
import '../loading/loading_screen.dart';

class DetailsScreenWeb extends StatelessWidget {
  const DetailsScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PokemonController>();
    var arguments = Get.arguments;
    late PokemonDetailData pokemonData;

    pokemonData = arguments["pokemonDetail"];
    final colorType =
        getPokemonTypeBackground(pokemonData.types![0].type!.name!);

    return GetBuilder<PokemonController>(
      id: 'listOfEvolutions',
      builder: (controller) {
        if (controller.loading) {
          return LoadingPage(
            text:
                "Getting data of ${pokemonData.name!.capitalize}.\nWait a Minute...",
          );
        }

        return Scaffold(
          backgroundColor: colorType,
          drawerScrimColor: colorType,
          
          body: SingleChildScrollView(
            child: _ColumnImageAndData(
                pokemonData: pokemonData, colorType: colorType),
          ),
          floatingActionButton:
              _SelectCaptured(ctrl: ctrl, pokemonData: pokemonData),
        );
      },
    );
  }
}

class _SelectCaptured extends StatelessWidget {
  const _SelectCaptured({
    required this.ctrl,
    required this.pokemonData,
  });

  final PokemonController ctrl;
  final PokemonDetailData pokemonData;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        ctrl.updatePokemon(pokemonData);
      },
      child: GetBuilder<PokemonController>(
        id: "pokemonCaptured",
        builder: (controller) {
          if (isCaptured(controller, pokemonData)) {
            return const Icon(Icons.star);
          }
          return const Icon(Icons.star_border_outlined);
        },
      ),
    );
  }
}

bool isCaptured(PokemonController controller, PokemonDetailData pokemonData) {
  for (var poke in controller.pokemonDetailsCaptured) {
    if (poke.name == pokemonData.name && poke.id == pokemonData.id) {
      return true;
    }
  }
  return false;
}

class _ColumnImageAndData extends StatelessWidget {
  const _ColumnImageAndData({
    required this.pokemonData,
    required this.colorType,
  });

  final PokemonDetailData pokemonData;
  final Color colorType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShowPokemonImage(pokemonData: pokemonData),
        const SizedBox(height: 16),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: ColumnData(pokemonData: pokemonData, colorType: colorType),
        ),
      ],
    );
  }
}
