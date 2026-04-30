import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pokemon.dart';

class FavoritesRepository {
  FavoritesRepository({required this.firebaseEnabled});

  final bool firebaseEnabled;

  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection('favorite_pokemons');

  Stream<List<PokemonSummary>> watchFavorites() {
    if (!firebaseEnabled) {
      return Stream.value(const []);
    }

    return _collection.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => PokemonSummary.fromMap(doc.data())).toList();
    });
  }

  Future<bool> isFavorite(int id) async {
    if (!firebaseEnabled) return false;
    final doc = await _collection.doc(id.toString()).get();
    return doc.exists;
  }

  Future<void> addFavorite(PokemonSummary pokemon) async {
    if (!firebaseEnabled) {
      throw Exception('Firebase não está configurado. Execute flutterfire configure.');
    }

    await _collection.doc(pokemon.id.toString()).set({
      ...pokemon.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFavorite(int id) async {
    if (!firebaseEnabled) {
      throw Exception('Firebase não está configurado. Execute flutterfire configure.');
    }

    await _collection.doc(id.toString()).delete();
  }
}
