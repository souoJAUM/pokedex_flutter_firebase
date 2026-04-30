import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../repositories/favorites_repository.dart';
import '../services/poke_api_service.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/status_banner.dart';
import 'favorites_screen.dart';
import 'pokemon_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.apiService,
    required this.favoritesRepository,
    required this.firebaseEnabled,
  });

  final PokeApiService apiService;
  final FavoritesRepository favoritesRepository;
  final bool firebaseEnabled;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PokemonSummary>> _futurePokemon;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _futurePokemon = widget.apiService.fetchPokemonList(limit: 60);
  }

  void _openDetails(PokemonSummary pokemon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PokemonDetailScreen(
          pokemon: pokemon,
          apiService: widget.apiService,
          favoritesRepository: widget.favoritesRepository,
          firebaseEnabled: widget.firebaseEnabled,
        ),
      ),
    );
  }

  void _openFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FavoritesScreen(
          favoritesRepository: widget.favoritesRepository,
          apiService: widget.apiService,
          firebaseEnabled: widget.firebaseEnabled,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex Flutter'),
        actions: [
          IconButton(
            tooltip: 'Favoritos no Firebase',
            onPressed: _openFavorites,
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Column(
        children: [
          StatusBanner(firebaseEnabled: widget.firebaseEnabled),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar Pokémon',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (value) => setState(() => _search = value.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PokemonSummary>>(
              future: _futurePokemon,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Erro ao carregar API: ${snapshot.error}'),
                    ),
                  );
                }

                final pokemons = snapshot.data ?? [];
                final filtered = pokemons.where((pokemon) {
                  return pokemon.name.contains(_search) || pokemon.id.toString() == _search;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Nenhum Pokémon encontrado.'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final pokemon = filtered[index];
                    return PokemonCard(
                      pokemon: pokemon,
                      onTap: () => _openDetails(pokemon),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
