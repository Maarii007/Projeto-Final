import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/prefs.dart';
import '../../data/repositories/favorito_repository_impl.dart';
import '../../data/repositories/pet_repository_impl.dart';
import '../../data/sources/pet_api_service.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/usecases/pet_usecases.dart';

final appDatabaseProvider = Provider<AppDatabase>((_) => AppDatabase());
final petApiServiceProvider = Provider<PetApiService>((_) => PetApiService());
final petRepositoryProvider = Provider<PetRepositoryImpl>(
  (ref) => PetRepositoryImpl(ref.read(petApiServiceProvider)),
);

final favoritoRepositoryProvider = Provider<FavoritoRepositoryImpl>(
  (ref) => FavoritoRepositoryImpl(ref.read(appDatabaseProvider)),
);

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.filtro = 'all',
  });
  final ThemeMode themeMode;
  final String filtro;

  AppSettings copyWith({ThemeMode? themeMode, String? filtro}) => AppSettings(
        themeMode: themeMode ?? this.themeMode,
        filtro: filtro ?? this.filtro,
      );
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return AppSettings(
      themeMode: Prefs.toThemeMode(_initialTheme),
      filtro: _initialFilter,
    );
  }
  static String _initialTheme  = 'dark';
  static String _initialFilter = 'all';

  static void setInitial(String theme, String filter) {
    _initialTheme  = theme;
    _initialFilter = filter;
  }

  void setThemeMode(ThemeMode mode) {
    Prefs.saveThemeMode(Prefs.fromThemeMode(mode));
    state = state.copyWith(themeMode: mode);
  }

  void setFiltro(String filtro) {
    Prefs.saveFilter(filtro);
    state = state.copyWith(filtro: filtro);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class PetsState {
  const PetsState({
    this.caes = const [],
    this.gatos = const [],
    this.busca = '',
  });

  final List<PetEntity> caes;
  final List<PetEntity> gatos;
  final String busca;

  List<PetEntity> filtrados(String filtro) {
    List<PetEntity> base;
    if (filtro == 'dog') {
      base = caes;
    } else if (filtro == 'cat') {
      base = gatos;
    } else {
      base = [...caes, ...gatos];
    }
    if (busca.trim().isEmpty) return base;
    final q = busca.toLowerCase();
    return base
        .where((p) =>
            p.raca.toLowerCase().contains(q) ||
            p.nome.toLowerCase().contains(q))
        .toList();
  }

  PetsState copyWith({
    List<PetEntity>? caes,
    List<PetEntity>? gatos,
    String? busca,
  }) =>
      PetsState(
        caes: caes ?? this.caes,
        gatos: gatos ?? this.gatos,
        busca: busca ?? this.busca,
      );
}

class PetsNotifier extends AsyncNotifier<PetsState> {
  @override
  Future<PetsState> build() => _carregar();

  Future<PetsState> _carregar() async {
    final repo = ref.read(petRepositoryProvider);
    final resultados = await Future.wait([
      BuscarCaesUseCase(repo)(limit: 30),
      BuscarGatosUseCase(repo)(limit: 30),
    ]);
    return PetsState(caes: resultados[0], gatos: resultados[1]);
  }

  Future<void> recarregar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_carregar);
  }

  void setBusca(String query) {
    state.whenData(
      (s) => state = AsyncData(s.copyWith(busca: query)),
    );
  }
}

final petsProvider = AsyncNotifierProvider<PetsNotifier, PetsState>(
  PetsNotifier.new,
);

class FavoritosNotifier extends AsyncNotifier<List<PetEntity>> {
  @override
  Future<List<PetEntity>> build() {
    return ListarFavoritosUseCase(ref.read(favoritoRepositoryProvider)).call();
  }

  Future<void> alternar(PetEntity pet) async {
    await AlternarFavoritoUseCase(ref.read(favoritoRepositoryProvider)).call(pet);
    ref.invalidateSelf();
  }

  Future<bool> isFavorito(String petId) =>
      VerificarFavoritoUseCase(ref.read(favoritoRepositoryProvider)).call(petId);
}

final favoritosProvider =
    AsyncNotifierProvider<FavoritosNotifier, List<PetEntity>>(
  FavoritosNotifier.new,
);
