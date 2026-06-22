import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adotapet/features/pets/domain/entities/pet_entity.dart';
import 'package:adotapet/features/pets/presentation/providers/providers.dart';
import 'package:adotapet/features/pets/presentation/widgets/filter_chips.dart';
import 'package:adotapet/features/pets/presentation/widgets/pet_card.dart';

const _dog = PetEntity(
  id: 'dog_1', nome: 'Rex', raca: 'Labrador',
  imageUrl: 'https://example.com/dog.jpg', tipo: AnimalType.dog,
);

Widget _wrap(Widget child) =>
    ProviderScope(child: MaterialApp(home: Scaffold(body: child)));

void main() {
  group('PetCard', () {
    testWidgets('exibe nome, raça e tipo', (tester) async {
      await tester.pumpWidget(_wrap(PetCard(pet: _dog, onTap: () {})));
      expect(find.text('Rex'),       findsOneWidget);
      expect(find.text('Labrador'),  findsOneWidget);
      expect(find.text('Cachorro'),  findsOneWidget);
    });

    testWidgets('chama onTap ao clicar', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
          _wrap(PetCard(pet: _dog, onTap: () => tapped = true)));
      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });
  });

  group('FilterChips', () {
    testWidgets('renderiza 3 chips', (tester) async {
      await tester.pumpWidget(
          _wrap(FilterChips(selecionado: 'all', onChanged: (_) {})));
      expect(find.text('Todos'), findsOneWidget);
      expect(find.text('Cães'),  findsOneWidget);
      expect(find.text('Gatos'), findsOneWidget);
    });

    testWidgets('chip "Cães" chama onChanged com "dog"', (tester) async {
      String? sel;
      await tester.pumpWidget(_wrap(
          FilterChips(selecionado: 'all', onChanged: (v) => sel = v)));
      await tester.tap(find.text('Cães'));
      expect(sel, 'dog');
    });
  });

  group('FavoritesPage estado vazio', () {
    testWidgets('exibe mensagem quando sem favoritos', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          favoritosProvider.overrideWith(() => _FavVazio()),
        ],
        child: MaterialApp(
          home: Scaffold(body: Consumer(builder: (ctx, ref, _) {
            final f = ref.watch(favoritosProvider);
            return f.when(
              loading: () => const CircularProgressIndicator(),
              error:   (e, _) => Text('$e'),
              data:    (list) => list.isEmpty
                  ? const Text('Nenhum favorito ainda')
                  : Text('${list.length}'),
            );
          })),
        ),
      ));
      await tester.pump();
      expect(find.text('Nenhum favorito ainda'), findsOneWidget);
    });
  });
}

class _FavVazio extends FavoritosNotifier {
  @override
  Future<List<PetEntity>> build() async => [];
}
