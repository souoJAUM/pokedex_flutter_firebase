class PokemonSummary {
  const PokemonSummary({
    required this.id,
    required this.name,
    required this.url,
  });

  final int id;
  final String name;
  final String url;

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  factory PokemonSummary.fromApi(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final parts = url.split('/')..removeWhere((part) => part.isEmpty);
    final id = int.tryParse(parts.last) ?? 0;

    return PokemonSummary(
      id: id,
      name: json['name'] as String,
      url: url,
    );
  }

  factory PokemonSummary.fromMap(Map<String, dynamic> map) {
    return PokemonSummary(
      id: map['id'] as int,
      name: map['name'] as String,
      url: map['url'] as String? ?? 'https://pokeapi.co/api/v2/pokemon/${map['id']}/',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'url': url,
        'imageUrl': imageUrl,
      };
}

class PokemonDetail {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.baseExperience,
  });

  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;
  final int baseExperience;

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  double get heightInMeters => height / 10;
  double get weightInKg => weight / 10;

  factory PokemonDetail.fromApi(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      baseExperience: json['base_experience'] as int? ?? 0,
      types: (json['types'] as List)
          .map((item) => item['type']['name'] as String)
          .toList(),
      abilities: (json['abilities'] as List)
          .map((item) => item['ability']['name'] as String)
          .toList(),
    );
  }
}

String capitalize(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}
