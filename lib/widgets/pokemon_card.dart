import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  final PokemonSummary pokemon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Hero(
          tag: 'pokemon-${pokemon.id}',
          child: Image.network(
            pokemon.imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.catching_pokemon),
          ),
        ),
        title: Text(
          capitalize(pokemon.name),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Nº ${pokemon.id.toString().padLeft(3, '0')}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
