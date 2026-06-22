import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../widgets/filter_chips.dart';
import '../widgets/pet_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);
    final settings  = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.pets,
              color: Theme.of(context).colorScheme.primary, size: 22),
          const SizedBox(width: 8),
          const Text('AdotaPet'),
        ]),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            onChanged: (q) => ref.read(petsProvider.notifier).setBusca(q),
            decoration: InputDecoration(
              hintText: 'Buscar por raça...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),

        // Chips de filtro
        FilterChips(
          selecionado: settings.filtro,
          onChanged: (f) => ref.read(settingsProvider.notifier).setFiltro(f),
        ),

        Expanded(
          child: petsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (erro, _) => Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.wifi_off_outlined, size: 48),
                const SizedBox(height: 12),
                Text('Erro ao carregar: $erro',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.read(petsProvider.notifier).recarregar(),
                  child: const Text('Tentar novamente'),
                ),
              ]),
            ),
            data: (state) {
              final pets = state.filtrados(settings.filtro);
              if (pets.isEmpty) {
                return const Center(
                    child: Text('Nenhum animal encontrado 🐾'));
              }
              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(petsProvider.notifier).recarregar(),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: pets.length,
                  itemBuilder: (context, i) => PetCard(
                    pet: pets[i],
                    onTap: () => context.push(
                      '/pet/${pets[i].id}',
                      extra: pets[i],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
