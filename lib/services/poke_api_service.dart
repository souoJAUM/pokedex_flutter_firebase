import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokeApiService {
  PokeApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<PokemonSummary>> fetchPokemonList({int limit = 30}) async {
    final uri = Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=0');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar lista de Pokémon: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final results = decoded['results'] as List<dynamic>;
    return results
        .map((item) => PokemonSummary.fromApi(item as Map<String, dynamic>))
        .toList();
  }

  Future<PokemonDetail> fetchPokemonDetail(String nameOrId) async {
    final uri = Uri.parse('$_baseUrl/pokemon/${nameOrId.toLowerCase()}');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar detalhes do Pokémon: ${response.statusCode}');
    }

    return PokemonDetail.fromApi(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
