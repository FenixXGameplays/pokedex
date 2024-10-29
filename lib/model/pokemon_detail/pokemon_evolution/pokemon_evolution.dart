import 'dart:convert';

import 'evolution_chain.dart';

class PokemonUrlEvolution {

    final EvolutionChain? evolutionChain;
   

    PokemonUrlEvolution({

        this.evolutionChain,
        
    });

    factory PokemonUrlEvolution.fromRawJson(String str) => PokemonUrlEvolution.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PokemonUrlEvolution.fromJson(Map<String, dynamic> json) => PokemonUrlEvolution(
        evolutionChain: json["evolution_chain"] == null ? null : EvolutionChain.fromJson(json["evolution_chain"]),
        );

    Map<String, dynamic> toJson() => {
        "evolution_chain": evolutionChain?.toJson(),
        };
}


