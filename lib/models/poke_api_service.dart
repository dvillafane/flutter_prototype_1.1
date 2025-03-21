import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pokemon.dart';

class PokeApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<Pokemon> fetchPokemon(String identifier) async {
    final response = await http.get(Uri.parse('$_baseUrl/pokemon/$identifier'));
    
    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Pokémon no encontrado');
    } else {
      throw Exception('Error en la API: ${response.statusCode}');
    }
  }
}