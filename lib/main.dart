import 'package:flutter/material.dart';

import 'repositories/favorites_repository.dart';
import 'screens/home_screen.dart';
import 'services/firebase_service.dart';
import 'services/poke_api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseEnabled = await FirebaseService().initialize();

  runApp(PokedexApp(firebaseEnabled: firebaseEnabled));
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key, required this.firebaseEnabled});

  final bool firebaseEnabled;

  @override
  Widget build(BuildContext context) {
    final apiService = PokeApiService();
    final favoritesRepository = FavoritesRepository(
      firebaseEnabled: firebaseEnabled,
    );

    return MaterialApp(
      title: 'Pokédex Flutter Firebase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: HomeScreen(
        apiService: apiService,
        favoritesRepository: favoritesRepository,
        firebaseEnabled: firebaseEnabled,
      ),
    );
  }
}
