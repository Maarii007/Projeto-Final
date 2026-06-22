import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/pet_entity.dart';
import '../providers/providers.dart';

class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({super.key, required this.pet});
  final PetEntity pet;

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  bool? _isFavorito;

  @override
  void initState() {
    super.initState();
    _verificar();
  }

  Future<void> _verificar() async {
    final r = await ref
        .read(favoritosProvider.notifier)
        .isFavorito(widget.pet.id);
    if (mounted) setState(() => _isFavorito = r);
  }

  Future<void> _alternar() async {
    await ref.read(favoritosProvider.notifier).alternar(widget.pet);
    await _verificar();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isFavorito == true
            ? '${widget.pet.nome} adicionado aos favoritos 💙'
            : '${widget.pet.nome} removido dos favoritos'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    final cs  = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          actions: [
            if (_isFavorito != null)
              IconButton(
                icon: Icon(
                  _isFavorito! ? Icons.favorite : Icons.favorite_outline,
                  color: _isFavorito! ? cs.error : null,
                ),
                onPressed: _alternar,
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'pet-${pet.id}',
              child: _DetailImage(url: pet.imageUrl),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(pet.nome,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Chip(label: Text(pet.tipo.label)),
                ]),
                const SizedBox(height: 4),
                Text(pet.raca,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: cs.primary)),

                if (pet.origem != null || pet.vidaMedia != null || pet.peso != null) ...[
                  const SizedBox(height: 16),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    if (pet.origem    != null) _Chip(Icons.public,         pet.origem!),
                    if (pet.vidaMedia != null) _Chip(Icons.timer_outlined, pet.vidaMedia!),
                    if (pet.peso      != null) _Chip(Icons.straighten,     '${pet.peso} kg'),
                  ]),
                ],

                if (pet.temperamento != null) ...[
                  const SizedBox(height: 20),
                  Text('Temperamento',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: pet.temperamento!
                        .split(',')
                        .map((t) => Chip(label: Text(t.trim())))
                        .toList(),
                  ),
                ],

                if (pet.descricao != null) ...[
                  const SizedBox(height: 20),
                  Text('Sobre a raça',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(pet.descricao!,
                      style: Theme.of(context).textTheme.bodyLarge),
                ],

                const SizedBox(height: 32),
                SafeArea(
                  child: Column(children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () =>
                            context.push('/adotar/${pet.id}', extra: pet),
                        icon: const Icon(Icons.volunteer_activism),
                        label: const Text('Quero adotar'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _alternar,
                        icon: Icon(_isFavorito == true
                            ? Icons.favorite
                            : Icons.favorite_outline),
                        label: Text(_isFavorito == true
                            ? 'Remover dos favoritos'
                            : 'Salvar nos favoritos'),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _DetailImage extends StatelessWidget {
  const _DetailImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          color: cs.surfaceContainerHighest,
          child: Icon(Icons.pets, size: 80, color: cs.onSurfaceVariant),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => Container(
        color: cs.surfaceContainerHighest,
        child: Icon(Icons.pets, size: 80, color: cs.onSurfaceVariant),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Chip(
        avatar: Icon(icon, size: 16),
        label: Text(label, style: Theme.of(context).textTheme.labelMedium),
      );
}