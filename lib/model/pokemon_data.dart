
import 'main_region.dart';

class PokemonData {
    final MainRegion? mainRegion;
    final String? name;
    final List<MainRegion>? pokemonSpecies;
    final List<MainRegion>? types;

    PokemonData({
        required this.mainRegion,
        required this.name,
        required this.pokemonSpecies,
        required this.types,

    });

    factory PokemonData.fromJson(Map<String, dynamic> json) => PokemonData(
        mainRegion: json["main_region"] == null ? null : MainRegion.fromJson(json["main_region"]),
        name: json["name"],
        pokemonSpecies: json["pokemon_species"] == null ? [] : List<MainRegion>.from(json["pokemon_species"]!.map((x) => MainRegion.fromJson(x))),
        types: json["types"] == null ? [] : List<MainRegion>.from(json["types"]!.map((x) => MainRegion.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "main_region": mainRegion?.toJson(),
        "name": name,
        "pokemon_species": pokemonSpecies == null ? [] : List<dynamic>.from(pokemonSpecies!.map((x) => x.toJson())),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x.toJson())),
        
    };

}


