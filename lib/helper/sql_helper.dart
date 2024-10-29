import 'package:flutter/foundation.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_data.dart';
import 'package:pokedex/model/pokemon_detail/pokemon_detail_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlHelper {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'animales.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE IF NOT EXISTS pokemons (idPoke INTEGER PRIMARY KEY, pokeData TEXT, isCaptured TEXT, imageBytes TEXT)",
      );
    }, version: 1);
  }

  static Future<void> insertItems(List<PokemonDetailDatabase> data) async {
    final db = await SqlHelper._openDB();

    for (var dataJson in data) {
      await db.insert('pokemons', dataJson.toJson());
    }
  }

  static Future<List<PokemonDetailDatabase>> getPokemons() async {
    final db = await SqlHelper._openDB();

    final List<Map<String, dynamic>> pokemonsMap =
        await db.query("pokemons", orderBy: "idPoke");
    final List<PokemonDetailDatabase> finalList = [];
    for (var poke in pokemonsMap) {
      //finalList.add(PokemonDetailDatabase.fromJson(poke));
      Uint8List bytes = Uint8List.fromList(poke["imageBytes"]);
      bool isCaptured = false;
      if (poke["isCaptured"].toLowerCase() == "true") {
        isCaptured = true;
      }

      finalList.add(
        PokemonDetailDatabase(
          idPokemon: poke["idPoke"],
          imageBytes: bytes,
          pokeData: PokemonDetailData.fromRawJson(poke["pokeData"]),
          isCaptured: isCaptured,
        ),
      );
    }

    return finalList;
  }

  static Future<void> updateCaptured(PokemonDetailDatabase poke) async {
    final db = await SqlHelper._openDB();

    try {
      await db.update("pokemons", poke.toJson(),
          where: "idPoke = ?", whereArgs: [poke.idPokemon]);
    } catch (e) {
      debugPrint("Something went wrong when deleting an item: $e");
    }
  }
}
