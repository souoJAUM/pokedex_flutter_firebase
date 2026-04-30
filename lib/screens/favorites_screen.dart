import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../repositories/favorites_repository.dart';
import '../services/poke_api_service.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.favoritesRepository,
    required this.apiService,
    required this.firebaseEnabled,
  });

  final FavoritesRepository favoritesRepository;
  final PokeApiService apiService;
  final bool firebaseEnabled;

  void _openDetails(BuildContext context, PokemonSummary pokemon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PokemonDetailScreen(
          pokemon: pokemon,
          apiService: apiService,
          favoritesRepository: favoritesRepository,
          firebaseEnabled: firebaseEnabled,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: StreamBuilder<List<PokemonSummary>>(
        stream: favoritesRepository.watchFavorites(),
        builder: (context, snapshot) {
          if (!firebaseEnabled) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'O Firebase ainda não está configurado. Após rodar flutterfire configure, os favoritos aparecerão aqui usando Cloud Firestore.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro no Firestore: ${snapshot.error}'));
          }

          final favorites = snapshot.data ?? [];
          if (favorites.isEmpty) {
            return const Center(
              child: Text('Nenhum favorito salvo no Firebase ainda.'),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final pokemon = favorites[index];
              return Dismissible(
                key: ValueKey(pokemon.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => favoritesRepository.removeFavorite(pokemon.id),
                child: PokemonCard(
                  pokemon: pokemon,
                  onTap: () => _openDetails(context, pokemon),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
