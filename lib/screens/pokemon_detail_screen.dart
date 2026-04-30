import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../repositories/favorites_repository.dart';
import '../services/poke_api_service.dart';

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
    required this.apiService,
    required this.favoritesRepository,
    required this.firebaseEnabled,
  });

  final PokemonSummary pokemon;
  final PokeApiService apiService;
  final FavoritesRepository favoritesRepository;
  final bool firebaseEnabled;

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Future<PokemonDetail> _futureDetail;
  bool _isFavorite = false;
  bool _favoriteLoading = true;

  @override
  void initState() {
    super.initState();
    _futureDetail = widget.apiService.fetchPokemonDetail(widget.pokemon.name);
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFavorite = await widget.favoritesRepository.isFavorite(widget.pokemon.id);
    if (!mounted) return;
    setState(() {
      _isFavorite = isFavorite;
      _favoriteLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    if (!widget.firebaseEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configure o Firebase para salvar favoritos no Firestore.'),
        ),
      );
      return;
    }

    setState(() => _favoriteLoading = true);
    try {
      if (_isFavorite) {
        await widget.favoritesRepository.removeFavorite(widget.pokemon.id);
      } else {
        await widget.favoritesRepository.addFavorite(widget.pokemon);
      }
      await _loadFavoriteStatus();
    } catch (error) {
      if (!mounted) return;
      setState(() => _favoriteLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar favorito: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(widget.pokemon.name)),
        actions: [
          IconButton(
            onPressed: _favoriteLoading ? null : _toggleFavorite,
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            tooltip: 'Salvar favorito no Firebase',
          ),
        ],
      ),
      body: FutureBuilder<PokemonDetail>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao buscar detalhes: ${snapshot.error}'));
          }

          final detail = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Hero(
                tag: 'pokemon-${detail.id}',
                child: Image.network(
                  detail.imageUrl,
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.catching_pokemon, size: 120),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                capitalize(detail.name),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Nº ${detail.id.toString().padLeft(3, '0')}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: detail.types
                    .map((type) => Chip(label: Text(capitalize(type))))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _InfoRow(label: 'Altura', value: '${detail.heightInMeters.toStringAsFixed(1)} m'),
                      _InfoRow(label: 'Peso', value: '${detail.weightInKg.toStringAsFixed(1)} kg'),
                      _InfoRow(label: 'Experiência base', value: detail.baseExperience.toString()),
                      _InfoRow(
                        label: 'Habilidades',
                        value: detail.abilities.map(capitalize).join(', '),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
