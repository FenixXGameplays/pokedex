import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_database.dart';
import 'package:pokedex/utils/utils.dart';

import '../../controller/pokemon_controller.dart';
import '../../utils/widgets.dart';
import '../loading/loading_screen.dart';

class DetailsScreenMobile extends StatelessWidget {
  const DetailsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PokemonController>();
    var arguments = Get.arguments;
    late PokemonDetailDatabase pokemonData;

    pokemonData = arguments["pokemonDetailDatabase"];
    final colorType =
        getPokemonTypeBackground(pokemonData.pokeData!.types![0].type!.name!);

    return GetBuilder<PokemonController>(
      builder: (controller) {
        if (controller.loading) {
          return LoadingPage(text: "Getting data of ${pokemonData.pokeData!.name!.capitalize}.\nWait a Minute...",);
        }

        return Scaffold(
          backgroundColor: colorType,
          appBar: AppBar(
            title: Text('${pokemonData.pokeData!.name!.capitalize}'),
          ),
          body: SingleChildScrollView(
            child: _ColumnImageAndData(
                pokemonData: pokemonData, colorType: colorType, ctrl: ctrl,),
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
  final PokemonDetailDatabase pokemonData;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        ctrl.updatePokemonDatabase(pokemonData);
      },
      child: GetBuilder<PokemonController>(
        id: "pokemonCaptured",
        builder: (controller) {
          if (isInDatabaseCaptured(pokemonData.pokeData!, controller.pokemonDatabase)) {
            return const Icon(Icons.star);
          }
          return const Icon(Icons.star_border_outlined);
        },
      ),
    );
  }
}

class _ColumnImageAndData extends StatelessWidget {
  const _ColumnImageAndData({
    required this.pokemonData,
    required this.colorType,
    required this.ctrl,
  });

  final PokemonDetailDatabase pokemonData;
  final Color colorType;
  final PokemonController ctrl;

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ctrl.hasInternet 
        ? ShowPokemonImage(pokemonData: pokemonData.pokeData!)
        : getOfflineImage(pokemonData),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.all( 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: ColumnData(pokemonData: pokemonData.pokeData!, colorType: colorType),
        ),
      ],
    );
  }

getOfflineImage(PokemonDetailDatabase pokemonData){
      String svgString = utf8.decode(pokemonData.imageBytes!);
    return SvgPicture.string(svgString);
}

}





