import 'dart:convert';

import 'chain.dart';

class EvolutionDetails {
    final Chain? chain;
    final int? id;

    EvolutionDetails({
        this.chain,
        this.id,
    });

    factory EvolutionDetails.fromRawJson(String str) => EvolutionDetails.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EvolutionDetails.fromJson(Map<String, dynamic> json) => EvolutionDetails(
        chain: json["chain"] == null ? null : Chain.fromJson(json["chain"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "chain": chain?.toJson(),
        "id": id,
    };

  
}

