import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controller/pokemon_controller.dart';
import '../model/pokemon_detail/pokemon_detail_data.dart';
import '../model/pokemon_detail/pokemon_detail_database.dart';
import 'utils.dart';

const baseUrl =
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/";

class ShowPokemonImage extends StatelessWidget {
  const ShowPokemonImage({
    super.key,
    required this.pokemonData,
  });

  final PokemonDetailData pokemonData;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      "$baseUrl${pokemonData.id}.svg",
      placeholderBuilder: (context) => Image.asset(
        'assets/images/loading-pokeball.gif',
      ),
    );
  }
}

class ShowPokemonImageCaptured extends StatelessWidget {
  const ShowPokemonImageCaptured(
      {super.key, required this.pokemonData, required this.controller});

  final PokemonDetailData pokemonData;
  final PokemonController controller;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      "$baseUrl${pokemonData.id}.svg",
      colorFilter: isCapturedColor(),
      placeholderBuilder: (context) => Image.asset(
        'assets/images/loading-pokeball.gif',
      ),
    );
  }

  ColorFilter? isCapturedColor() {
    for (var pokemon in controller.pokemonDetailsCapturedFiltered) {
      if (pokemonData != pokemon && !isCaptured(controller, pokemonData)) {
        return const ColorFilter.mode(Colors.black, BlendMode.srcIn);
      }
    }
    return null;
  }
}

class ContainerId extends StatelessWidget {
  const ContainerId({
    super.key,
    required this.pokemonData,
  });

  final PokemonDetailData pokemonData;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 15, right: 15),
      child: _ShowId(pokemonData: pokemonData),
    );
  }
}

class _ShowId extends StatelessWidget {
  const _ShowId({
    required this.pokemonData,
  });

  final PokemonDetailData pokemonData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '#${pokemonData.id}',
        style: TextStyle(
            color: getPokemonTypeBackground(pokemonData.types?[0].type?.name),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ShowImageDatabase extends StatelessWidget {
  const ShowImageDatabase({
    super.key,
    required this.pokemonData,
  });

  final PokemonDetailDatabase pokemonData;

  @override
  Widget build(BuildContext context) {
    String svgString = utf8.decode(pokemonData.imageBytes!);
    return SvgPicture.string(svgString,
        colorFilter: !pokemonData.isCaptured
            ? const ColorFilter.mode(Colors.black, BlendMode.srcIn)
            : null);
  }
}

class CardData extends StatelessWidget {
  const CardData({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  final String title;
  final String subtitle;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getPokemonTypeBackground(type).withOpacity(0.5),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

class _BaseStats extends StatelessWidget {
  final PokemonDetailData pokemonDetail;
  final Color colorType;

  const _BaseStats({
    required this.pokemonDetail,
    required this.colorType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Base Stats",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pokemonDetail.stats!.length,
            itemBuilder: (BuildContext context, index) {
              Stat stat = pokemonDetail.stats![index];
              return CardData(
                title: stat.stat!.name!.capitalize!,
                subtitle: '${stat.baseStat!}',
                type: pokemonDetail.types![0].type!.name!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ShowAbilities extends StatelessWidget {
  const _ShowAbilities({
    required this.pokemonDetail,
    required this.colorType,
  });

  final PokemonDetailData pokemonDetail;
  final Color colorType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Abilities",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pokemonDetail.abilities?.length,
            itemBuilder: (BuildContext context, index) {
              Ability ability = pokemonDetail.abilities![index];
              return CardData(
                title: ability.ability!.name!.capitalize!,
                subtitle: (ability.isHidden!) ? "(Hidden Activity)" : "",
                type: pokemonDetail.types![0].type!.name!,
              );
            },
          ),
        ),
        const SizedBox(height: 56),
      ],
    );
  }
}

class _ShowTypesPokemon extends StatelessWidget {
  const _ShowTypesPokemon({
    required this.pokemonData,
  });

  final PokemonDetailData pokemonData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pokemonData.types!.map((data) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: getPokemonTypeBackground(data.type!.name),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              data.type!.name!.capitalize!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ColumnData extends StatelessWidget {
  const ColumnData({
    super.key,
    required this.pokemonData,
    required this.colorType,
  });

  final PokemonDetailData pokemonData;
  final Color colorType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(right: 10, top: 10),
          child: _ShowId(pokemonData: pokemonData),
        ),
        const SizedBox(height: 8),
        kIsWeb ? Text('${pokemonData.name!.capitalize}') : const SizedBox.shrink(),
        const SizedBox(height: 8),
        _ShowTypesPokemon(pokemonData: pokemonData),
        const SizedBox(height: 24),
        _About(pokemonDetail: pokemonData),
        const SizedBox(
          height: 24,
        ),
        _BaseStats(pokemonDetail: pokemonData, colorType: colorType),
        const SizedBox(
          height: 24,
        ),
        _ShowAbilities(
          pokemonDetail: pokemonData,
          colorType: colorType,
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class _About extends StatelessWidget {
  final PokemonDetailData pokemonDetail;
  const _About({required this.pokemonDetail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "About",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ShowMetricPokemon(
              value: '${pokemonDetail.weight}',
              metric: "Weight",
              icon: "assets/icons/weight.svg",
            ),
            _ShowMetricPokemon(
              value: '${pokemonDetail.height}',
              metric: "Height",
              icon: "assets/icons/ruler.svg",
            )
          ],
        ),
      ],
    );
  }
}

class _ShowMetricPokemon extends StatelessWidget {
  final String value;
  final String metric;
  final String icon;
  const _ShowMetricPokemon({
    required this.value,
    required this.metric,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 8,
        ),
        SvgPicture.asset(
          icon,
          width: 40,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(metric, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}

class SearchType extends StatelessWidget {
  const SearchType({
    super.key,
    required this.ctrl,
  });

  final PokemonController ctrl;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      ctrl.typesPokemon.remove("Captured");
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownMenu(
        focusNode: FocusNode(canRequestFocus: false),
        initialSelection: ctrl.typeFilter,
        dropdownMenuEntries: ctrl.typesPokemon.map((String value) {
          return DropdownMenuEntry(
            value: value,
            label: value,
          );
        }).toList(),
        onSelected: (newValue) {
          ctrl.typeFilter = newValue!;
          ctrl.update(["listOfPokemonsCaptured"]);
        },
      ),
    );
  }
}

class Order extends StatelessWidget {
  const Order({
    super.key,
    required this.ctrl,
  });

  final PokemonController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownMenu(
        focusNode: FocusNode(canRequestFocus: false),
        initialSelection: ctrl.orderFilter,
        dropdownMenuEntries: ctrl.orderType.map((String value) {
          return DropdownMenuEntry(
            value: value,
            label: value,
          );
        }).toList(),
        onSelected: (newValue) {
          ctrl.orderFilter = newValue!;
          ctrl.getPokemonsFilteredByOrder(newValue);
        },
      ),
    );
  }
}
