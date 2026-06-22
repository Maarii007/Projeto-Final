import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:adotapet/main.dart' as app;
import 'package:adotapet/features/pets/domain/entities/pet_entity.dart';
import 'package:adotapet/features/pets/presentation/providers/providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Fluxo: home → detalhe → adoção', (tester) async {
    const fakeDog = PetEntity(
      id: 'dog_1', nome: 'Labrador', raca: 'Labrador Retriever',
      imageUrl: 'https://example.com/dog.jpg', tipo: AnimalType.dog,
      temperamento: 'Friendly', descricao: 'Um cão amigável.',
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [
        petsProvider.overrideWith(() => _FakePets(fakeDog)),
      ],
      child: const app.AdotaPetApp(),
    ));

    await tester.pumpAndSettle();
    expect(find.text('AdotaPet'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Labrador'), findsOneWidget);

    await tester.tap(find.text('Labrador').first);
    await tester.pumpAndSettle();
    expect(find.text('Labrador Retriever'), findsOneWidget);
    expect(find.text('Quero adotar'), findsOneWidget);

    await tester.tap(find.text('Quero adotar'));
    await tester.pumpAndSettle();
    expect(find.text('Adotar Labrador'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome completo *'), 'Ana Silva');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'E-mail *'), 'ana@email.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Telefone *'), '(42) 99999-0000');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Por que você quer adotar? *'),
        'Sempre quis ter um cão e tenho espaço em casa.');

    await tester.tap(find.text('Enviar solicitação'));
    await tester.pumpAndSettle();
    expect(find.text('Solicitação enviada! 🐾'), findsOneWidget);
  });
}

class _FakePets extends PetsNotifier {
  _FakePets(this._pet);
  final PetEntity _pet;

  @override
  Future<PetsState> build() async => PetsState(caes: [_pet], gatos: []);

  @override
  Future<void> recarregar() async {
    state = AsyncData(PetsState(caes: [_pet], gatos: []));
  }

  @override
  void setBusca(String query) {}
}