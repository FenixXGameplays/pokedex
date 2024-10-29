import 'dart:convert';

class MainRegion {
    final String name;
    final String url;

    MainRegion({
        required this.name,
        required this.url,
    });

    factory MainRegion.fromRawJson(String str) => MainRegion.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MainRegion.fromJson(Map<String, dynamic> json) => MainRegion(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}