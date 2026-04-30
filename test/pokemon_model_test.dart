import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_flutter_firebase/models/pokemon.dart';

void main() {
  test('PokemonSummary extrai o id pela URL da PokeAPI', () {
    final pokemon = PokemonSummary.fromApi({
      'name': 'bulbasaur',
      'url': 'https://pokeapi.co/api/v2/pokemon/1/',
    });

    expect(pokemon.id, 1);
    expect(pokemon.name, 'bulbasaur');
  });
}
