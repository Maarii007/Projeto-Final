import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/pets/domain/entities/pet_entity.dart';
import '../../features/pets/presentation/pages/adoption_request_page.dart';
import '../../features/pets/presentation/pages/detail_page.dart';
import '../../features/pets/presentation/pages/favorites_page.dart';
import '../../features/pets/presentation/pages/historico_page.dart';
import '../../features/pets/presentation/pages/home_page.dart';
import '../../features/pets/presentation/pages/settings_page.dart';
import '../widgets/main_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (_, __, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/favoritos',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: FavoritesPage()),
        ),
        GoRoute(
          path: '/configuracoes',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: SettingsPage()),
        ),
      ],
    ),
    GoRoute(
      path: '/pet/:id',
      builder: (_, state) => DetailPage(pet: state.extra as PetEntity),
    ),
    GoRoute(
      path: '/adotar/:id',
      builder: (_, state) =>
          AdoptionRequestPage(pet: state.extra as PetEntity),
    ),
    GoRoute(
      path: '/historico',
      builder: (_, __) => const HistoricoPage(),
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    body: Center(child: Text('Página não encontrada: ${state.error}')),
  ),
);
