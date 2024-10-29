import 'dart:convert';

import 'species.dart';

class PokemonDetailData {
    final List<Ability>? abilities;
    final int? height;
    final int? id;
    final String? name;
    final List<Stat>? stats;
    final List<Type>? types;
    final int? weight;

    PokemonDetailData({
        this.abilities,
        this.height,
        this.id,
        this.name,
        this.stats,
        this.types,
        this.weight,
    });

    factory PokemonDetailData.fromRawJson(String str) => PokemonDetailData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PokemonDetailData.fromJson(Map<String, dynamic> json) => PokemonDetailData(
        abilities: json["abilities"] == null ? [] : List<Ability>.from(json["abilities"]!.map((x) => Ability.fromJson(x))),
        height: json["height"],
        id: json["id"],
        name: json["name"],
        stats: json["stats"] == null ? [] : List<Stat>.from(json["stats"]!.map((x) => Stat.fromJson(x))),
        types: json["types"] == null ? [] : List<Type>.from(json["types"]!.map((x) => Type.fromJson(x))),
        weight: json["weight"],
    );

    Map<String, dynamic> toJson() => {
        "abilities": abilities == null ? [] : List<dynamic>.from(abilities!.map((x) => x.toJson())),
        "height": height,
        "id": id,
        "name": name,
        "stats": stats == null ? [] : List<dynamic>.from(stats!.map((x) => x.toJson())),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x.toJson())),
        "weight": weight,
    };
}

class Ability {
    final Species? ability;
    final bool? isHidden;

    Ability({
        this.ability,
        this.isHidden,
    });

    factory Ability.fromRawJson(String str) => Ability.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Ability.fromJson(Map<String, dynamic> json) => Ability(
        ability: json["ability"] == null ? null : Species.fromJson(json["ability"]),
        isHidden: json["is_hidden"],
    );

    Map<String, dynamic> toJson() => {
        "ability": ability?.toJson(),
        "is_hidden": isHidden,
    };
}

class Stat {
    final int? baseStat;
    final Species? stat;

    Stat({
        this.baseStat,
        this.stat,
    });

    factory Stat.fromRawJson(String str) => Stat.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        baseStat: json["base_stat"],
        stat: json["stat"] == null ? null : Species.fromJson(json["stat"]),
    );

    Map<String, dynamic> toJson() => {
        "base_stat": baseStat,
        "stat": stat?.toJson(),
    };
}

class Type {
    final Species? type;

    Type({
        this.type,
    });

    factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Type.fromJson(Map<String, dynamic> json) => Type(
        type: json["type"] == null ? null : Species.fromJson(json["type"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type?.toJson(),
    };
}
