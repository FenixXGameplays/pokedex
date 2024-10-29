import 'dart:convert';

import '../species.dart';

class Chain {
    final List<Chain>? evolvesTo;
    final Species? species;

    Chain({
        this.evolvesTo,
        this.species,
    });

    factory Chain.fromRawJson(String str) => Chain.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Chain.fromJson(Map<String, dynamic> json) => Chain(
        evolvesTo: json["evolves_to"] == null ? [] : List<Chain>.from(json["evolves_to"]!.map((x) => Chain.fromJson(x))),
        species: json["species"] == null ? null : Species.fromJson(json["species"]),
    );

    Map<String, dynamic> toJson() => {
        "evolves_to": evolvesTo == null ? [] : List<dynamic>.from(evolvesTo!.map((x) => x.toJson())),
        "species": species?.toJson(),
    };
}
