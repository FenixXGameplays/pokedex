import 'dart:convert';

class EvolutionChain {
    final String? url;

    EvolutionChain({
        this.url,
    });

    factory EvolutionChain.fromRawJson(String str) => EvolutionChain.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EvolutionChain.fromJson(Map<String, dynamic> json) => EvolutionChain(
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
    };
}
