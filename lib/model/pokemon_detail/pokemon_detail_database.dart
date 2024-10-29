import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_data.dart';


class PokemonDetailDatabase {
    final PokemonDetailData? pokeData;
    final int? idPokemon;
    final Uint8List? imageBytes;
    final bool isCaptured;


    PokemonDetailDatabase({
        this.pokeData,
        this.idPokemon,
        this.imageBytes,
        this.isCaptured = false,
        
    });

    factory PokemonDetailDatabase.fromRawJson(String str) => PokemonDetailDatabase.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PokemonDetailDatabase.fromJson(Map<String, dynamic> json) => PokemonDetailDatabase(
        pokeData: json["pokeData"],
        idPokemon: json["idPoke"],
        imageBytes: json["imageBytes"],
        isCaptured: json["isCaptured"]
        
    );

    Map<String, dynamic> toJson() => {
        "pokeData": pokeData?.toRawJson() ?? "null",
        "idPoke": idPokemon,
        "imageBytes": imageBytes,
        "isCaptured": isCaptured.toString(),
       
    };
}
