import 'dart:convert';

class Species {
    final String? name;
    final String? url;

    Species({
        this.name,
        this.url,
    });

    factory Species.fromRawJson(String str) => Species.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Species.fromJson(Map<String, dynamic> json) => Species(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}