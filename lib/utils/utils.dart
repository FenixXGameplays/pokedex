
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/controller/pokemon_controller.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/pokemon_detail/pokemon_detail_data.dart';
import '../model/pokemon_detail/species.dart';
import 'package:http/http.dart' as http;

Color getPokemonTypeBackground(String? name) {
  Color finalColor;
  switch (name) {
    case "bug":
      finalColor = const Color(0xFF9ACD32);
      break;
    case "dragon":
      finalColor = const Color(0xFF6495ED);
      break;
    case "electric":
      finalColor = const Color(0xFFF2D027);

      break;
    case "fighting":
      finalColor = const Color(0xFFA8A878);

      break;
    case "fire":
      finalColor = const Color(0xFFFF5733);

      break;
    case "flying":
      finalColor = const Color(0xFF87CEEB);

      break;
    case "ghost":
      finalColor = const Color(0xFF7B68EE);

      break;
    case "fairy":
      finalColor = const Color(0xFFFFB6C1);

      break;
    case "grass":
      finalColor = const Color(0xFF78C850);

      break;
    case "ground":
      finalColor = const Color(0xFFBB8F38);

      break;
    case "ice":
      finalColor = const Color(0xFFB0E0E6);

      break;
    case "normal":
      finalColor = const Color(0xFFA4ACAF);

      break;
    case "poison":
      finalColor = const Color(0xFFA040A0);

      break;
    case "psychic":
      finalColor = const Color(0xFFF08080);

      break;
    case "rock":
      finalColor = const Color(0xFF708090);

      break;
    case "water":
      finalColor = const Color(0xFF4A90E2);

      break;

    default:
      finalColor = const Color(0xFFFF0000);
  }
  return finalColor;
}

int getId(String? url) {
  String valor = "";
  RegExp exp = RegExp(r'https://pokeapi.co/api/v2/pokemon-species/(\d+)/');
  var match = exp.firstMatch(url!);

  if (match != null) {
    valor = match.group(1)!;
  } else {
    valor = "0";
  }

  return int.parse(valor);
}

Future<SharedPreferences> getPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

List<Species> extractSpecies(Map<String, dynamic> data) {
  final List<Species> speciesList = [];
  Species specie;
  void exploreData(dynamic value) {
    if (value is Map) {
      if (value.containsKey("species")) {
        specie = Species.fromJson(value["species"]);
        int id = getId(specie.url);
        if (id > 0 && id <= 151) {
          speciesList.add(specie); // Add species
        }
      }
      value.forEach((key, value) => exploreData(value)); // Explore sub-maps
    } else if (value is List) {
      for (var item in value) {
        exploreData(item);
      } // Explore list items
    }
  }

  exploreData(data);
  return speciesList;
}

bool isInDatabaseCaptured(
    PokemonDetailData poke, List<PokemonDetailDatabase> pokemonDatabase) {
  for (var po in pokemonDatabase) {
    if (po.idPokemon == poke.id && po.isCaptured) return true;
  }
  return false;
}


Future<Uint8List> getBytesImage(int? id) async {
    var url = Uri.parse(
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/$id.svg");

      var response = await http.get(url);
    return response.bodyBytes;
  }



  bool isCaptured(PokemonController ctrl, PokemonDetailData pokemonData){
    for (var poke in ctrl.pokemonDetailsCaptured) {
      if (poke.name == pokemonData.name && poke.id == pokemonData.id) {
        return true;
      }
    }
    return false;
  }

  