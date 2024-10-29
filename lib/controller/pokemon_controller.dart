import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:pokedex/helper/sql_helper.dart';
import 'package:pokedex/model/pokemon_data.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_data.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_database.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_evolution/evolution_details.dart';

import '../theme/app_theme.dart';
import '../utils/utils.dart';

class PokemonController extends GetxController {
  final baseUrl = "https://pokeapi.co/api/v2/";
  var client = http.Client();

  final AppTheme _appTheme = AppTheme();

  AppTheme get appTheme => _appTheme;

  void toggleTheme(Color newColor) {
    _appTheme.selectedColor = newColor;
    _appTheme.getTheme();

    update(["updateTheme"]);
  }

  bool loading = false;
  bool firstLoading = false;

  String typeFilter = "All";
  String orderFilter = "Id";
  String typedSearch = "";

  bool hasInternet = false;

  PokemonData pokemons =
      PokemonData(mainRegion: null, name: "", pokemonSpecies: [], types: []);

  late final List<PokemonDetailData> pokemonsDetails = [];
  late final List<PokemonDetailData> pokemonsDetailsFiltered = [];

  List<PokemonDetailData> pokemonDetailsCaptured = [];
  List<PokemonDetailData> pokemonDetailsCapturedFiltered = [];

  List<PokemonDetailDatabase> pokemonDatabase = [];
  late List<PokemonDetailDatabase> pokemonDatabaseFiltered = [];

  List<String> typesPokemon = [
    "All",
    "Captured",
    "Bug",
    "Dragon",
    "Electric",
    "Fighting",
    "Fire",
    "Flying",
    "Ghost",
    "Grass",
    "Ground",
    "Ice",
    "Normal",
    "Poison",
    "Psychic",
    "Rock",
    "Water",
    "Fairy"
  ];

  List<String> orderType = [
    "Id",
    "Ascendant",
    "Descendant",
  ];
  
  String typeTheme = "";
  EvolutionDetails evolutionDetails =
      EvolutionDetails.fromJson(<String, dynamic>{});

  Future<void> getPokemonByNameOrId(String url) async {
    try {
      var urlParsed = Uri.parse(url);
      var response = await http.get(urlParsed);

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        pokemonsDetails.add(PokemonDetailData.fromJson(decodedResponse));
      }
    } on Exception catch (_, e) {
      e.printError();
    }
  }

  Future<void> getPokemons() async {
    if (loading != true) {
      loading = true;
      update(["listOfPokemons"]);
      pokemonsDetails.clear();
      try {
        var url = Uri.parse("$baseUrl/generation/1/");
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
              as Map<String, dynamic>;
          pokemons = PokemonData.fromJson(decodedResponse);
          if (pokemons.pokemonSpecies != null) {
            for (var pokemon in pokemons.pokemonSpecies!) {
              await getPokemonByNameOrId(
                pokemon.url.replaceAll("/pokemon-species/", "/pokemon/"),
              );
            }
          }

          pokemonsDetails.sort((a, b) => a.id!.compareTo(b.id!));
          getPokemonsFilteredBySearch("");

          if (!kIsWeb) {
            await getDatabaseData();
          }
        }
      } on Exception catch (_, e) {
        e.printError();
      }

      loading = false;
      firstLoading = true;
      update(["listOfPokemons", "listOfPokemonsCaptured"]);
    }
  }

  void getPokemonsFilteredBySearch(String nameSearched) {
    pokemonsDetailsFiltered.clear();
    if (nameSearched != "") {
      for (var data in pokemonsDetails) {
        if (data.name!.startsWith(nameSearched.toLowerCase())) {
          pokemonsDetailsFiltered.add(data);
        }
      }
      typedSearch = nameSearched;
    } else {
      typedSearch = "";
      pokemonsDetailsFiltered.addAll(pokemonsDetails);
    }
    update(["listOfPokemons"]);
  }

  void getPokemonsFilteredByType(String typeSearched) {
    if (kIsWeb) {
      pokemonDetailsCapturedFiltered.clear();
      if (typeSearched != "All") {
        for (var data in pokemonsDetails) {
          for (var type in data.types!) {
            if (type.type?.name!.capitalize == typeSearched) {
              if (!pokemonDetailsCapturedFiltered.contains(data)) {
                pokemonDetailsCapturedFiltered.add(data);
              }
            }
          }
        }
      } else {
        pokemonDetailsCapturedFiltered.addAll(pokemonsDetails);
      }
      pokemonDetailsCapturedFiltered.sort((a, b) => a.id!.compareTo(b.id!));
    } else {
      pokemonDatabaseFiltered.clear();
      if (typeSearched != "All") {
        for (var data in pokemonDatabase) {
          for (var type in data.pokeData!.types!) {
            if (typeSearched != "Captured") {
              if (type.type?.name!.capitalize == typeSearched) {
                if (!pokemonDatabaseFiltered.contains(data)) {
                  pokemonDatabaseFiltered.add(data);
                }
              }
            } else {
              if (!pokemonDatabaseFiltered.contains(data) && data.isCaptured) {
                pokemonDatabaseFiltered.add(data);
              }
            }
          }
        }
      } else {
        pokemonDatabaseFiltered.addAll(pokemonDatabase);
      }
      pokemonDatabaseFiltered
          .sort((a, b) => a.idPokemon!.compareTo(b.idPokemon!));
    }
    typeFilter = typeSearched;
    getPokemonsFilteredByOrder(orderFilter);
  }

  void getPokemonsFilteredByOrder(String typeSearched) {
    if (kIsWeb) {
      switch (typeSearched) {
        case "Ascendant":
          pokemonDetailsCapturedFiltered
              .sort((a, b) => a.name!.compareTo(b.name!));
          break;
        case "Descendant":
          pokemonDetailsCapturedFiltered
              .sort((a, b) => b.name!.compareTo(a.name!));
          break;
        default:
          pokemonDetailsCapturedFiltered.sort((a, b) => a.id!.compareTo(b.id!));
      }
    } else {
      switch (typeSearched) {
        case "Ascendant":
          pokemonDatabaseFiltered
              .sort((a, b) => a.pokeData!.name!.compareTo(b.pokeData!.name!));
          break;
        case "Descendant":
          pokemonDatabaseFiltered
              .sort((a, b) => b.pokeData!.name!.compareTo(a.pokeData!.name!));
          break;
        default:
          pokemonDatabaseFiltered
              .sort((a, b) => a.pokeData!.id!.compareTo(b.pokeData!.id!));
      }
    }
    orderFilter = typeSearched;
    update(["listOfPokemonsCaptured"]);
  }

  void updatePokemon(PokemonDetailData poke) async {
    if (!pokemonDetailsCaptured.contains(poke)) {
      pokemonDetailsCaptured.add(poke);
    } else {
      pokemonDetailsCaptured.remove(poke);
    }
    pokemonDetailsCaptured.sort((a, b) => a.id!.compareTo(b.id!));

    updateThemeFromCaptured();
    update(["pokemonCaptured", "listOfPokemonsCaptured"]);
  }

  void updatePokemonDatabase(PokemonDetailDatabase poke) async {
    if (!isInDatabaseCaptured(poke.pokeData!, pokemonDatabase)) {
      await SqlHelper.updateCaptured(
        PokemonDetailDatabase(
            idPokemon: poke.idPokemon,
            pokeData: poke.pokeData,
            imageBytes: poke.imageBytes,
            isCaptured: true),
      );
    } else {
      await SqlHelper.updateCaptured(PokemonDetailDatabase(
          idPokemon: poke.idPokemon,
          pokeData: poke.pokeData,
          imageBytes: poke.imageBytes,
          isCaptured: false));
    }
    pokemonDatabase = await SqlHelper.getPokemons();

    updateThemeFromCaptured();
    typedSearch = "";
    update(["pokemonCaptured", "listOfPokemonsCaptured"]);
  }

  void updateThemeFromCaptured() async {
    Map<String, int> countPerType = {};
    if (kIsWeb) {
      for (var pokemon in pokemonDetailsCaptured) {
        var type = pokemon.types!;
        countPerType[type[0].type!.name!] =
            (countPerType[type[0].type!.name] ?? 0) + 1;
      }
    } else {
      for (var pokemon in pokemonDatabase) {
        if (pokemon.isCaptured) {
          var type = pokemon.pokeData!.types!;
          countPerType[type[0].type!.name!] =
              (countPerType[type[0].type!.name] ?? 0) + 1;
        }
      }
    }

    List<MapEntry<String, int>> typesOrdered = countPerType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (typesOrdered.length > 1) {
      if (typesOrdered[0].value == typesOrdered[1].value) {
        typeTheme = "";
      } else {
        typeTheme = typesOrdered[0].key;
      }
    } else if (typesOrdered.isEmpty) {
      typeTheme = "";
    } else {
      typeTheme = typesOrdered[0].key;
    }

    toggleTheme(getPokemonTypeBackground(typeTheme));
  }

  Future<void> getDatabaseData() async {
    if (!kIsWeb) {
      pokemonDatabase = await SqlHelper.getPokemons();
      List<PokemonDetailDatabase> listPokemons = [];
      if (pokemonDatabase.isEmpty) {
        for (var value in pokemonsDetails) {
          var imageBytes = await getBytesImage(value.id);
          listPokemons.add(
            PokemonDetailDatabase(
              idPokemon: value.id,
              isCaptured: false,
              pokeData: value,
              imageBytes: imageBytes,
            ),
          );
        }
        await SqlHelper.insertItems(listPokemons);
        pokemonDatabase = await SqlHelper.getPokemons();
      } else {
        firstLoading = true;
      }
    }

    updateThemeFromCaptured();

    update(["updateTheme"]);
  }
}
