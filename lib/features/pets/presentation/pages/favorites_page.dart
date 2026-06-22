import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favoritosProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.favorite_outline, size: 64),
                SizedBox(height: 12),
                Text('Nenhum favorito ainda'),
                SizedBox(height: 8),
                Text('Salve animais que você amou ❤️'),
              ]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final pet = lista[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: pet.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(Icons.pets),
                    ),
                  ),
                  title: Text(pet.nome),
                  subtitle: Text(pet.raca),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () =>
                        ref.read(favoritosProvider.notifier).alternar(pet),
                  ),
                  onTap: () => context.push('/pet/${pet.id}', extra: pet),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
