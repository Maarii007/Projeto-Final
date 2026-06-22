import 'package:flutter_test/flutter_test.dart';
import 'package:adotapet/features/pets/data/models/dog_model.dart';
import 'package:adotapet/features/pets/data/models/cat_model.dart';
import 'package:adotapet/features/pets/domain/entities/pet_entity.dart';
import 'package:adotapet/features/pets/presentation/providers/providers.dart';

void main() {
  group('DogModel.fromJson + toEntity', () {
    test('converte campos corretamente', () {
      final json = {
        'id': 1,
        'name': 'Labrador Retriever',
        'temperament': 'Friendly, Active',
        'origin': 'United Kingdom',
        'life_span': '10 - 12 years',
        'weight': {'metric': '25 - 36'},
        'image': {'url': 'https://cdn2.thedogapi.com/images/abc.jpg'},
      };
      final entity = DogModel.fromJson(json).toEntity();
      expect(entity.id, 'dog_1');
      expect(entity.nome, 'Labrador Retriever');
      expect(entity.tipo, AnimalType.dog);
      expect(entity.imageUrl, 'https://cdn2.thedogapi.com/images/abc.jpg');
      expect(entity.peso, '25 - 36');
    });

    test('usa referenceImageId quando image está ausente', () {
      final json = {'id': 2, 'name': 'Beagle', 'reference_image_id': 'xyz'};
      final entity = DogModel.fromJson(json).toEntity();
      expect(entity.imageUrl, 'https://cdn2.thedogapi.com/images/xyz.jpg');
    });
  });
  group('CatModel.fromJson + toEntity', () {
    test('converte campos corretamente', () {
      final json = {
        'id': 'abys',
        'name': 'Abyssinian',
        'temperament': 'Active, Energetic',
        'origin': 'Egypt',
        'description': 'A slender cat.',
        'weight': {'metric': '3 - 5'},
      };
      final entity = CatModel.fromJson(json).toEntity();
      expect(entity.id, 'cat_abys');
      expect(entity.tipo, AnimalType.cat);
      expect(entity.descricao, 'A slender cat.');
    });
  });

  group('PetsState.filtrados()', () {
    const cao = PetEntity(id: 'dog_1', nome: 'Rex',  raca: 'Lab',     imageUrl: '', tipo: AnimalType.dog);
    const gato = PetEntity(id: 'cat_1', nome: 'Mia', raca: 'Siamese', imageUrl: '', tipo: AnimalType.cat);
    final state = PetsState(caes: [cao], gatos: [gato]);

    test('"all" retorna cães e gatos', () => expect(state.filtrados('all').length, 2));
    test('"dog" retorna só cães',       () => expect(state.filtrados('dog').length, 1));
    test('"cat" retorna só gatos',      () => expect(state.filtrados('cat').length, 1));
  });

  group('PetsState busca', () {
    const pets = [
      PetEntity(id: 'dog_1', nome: 'Golden Retriever', raca: 'Golden Retriever', imageUrl: '', tipo: AnimalType.dog),
      PetEntity(id: 'dog_2', nome: 'Labrador',          raca: 'Labrador',          imageUrl: '', tipo: AnimalType.dog),
    ];
    test('busca "golden" retorna 1', () {
      final s = PetsState(caes: pets, busca: 'golden');
      expect(s.filtrados('all').length, 1);
    });
    test('busca case-insensitive', () {
      final s = PetsState(caes: pets, busca: 'GOLDEN');
      expect(s.filtrados('all').length, 1);
    });
    test('busca vazia retorna todos', () {
      final s = PetsState(caes: pets, busca: '');
      expect(s.filtrados('all').length, 2);
    });
  });
  group('PetEntity equality', () {
    test('mesmo id → iguais', () {
      const a = PetEntity(id: 'dog_1', nome: 'Rex',   raca: 'Lab', imageUrl: '', tipo: AnimalType.dog);
      const b = PetEntity(id: 'dog_1', nome: 'Outro', raca: 'X',   imageUrl: '', tipo: AnimalType.dog);
      expect(a == b, true);
    });
    test('ids diferentes → não iguais', () {
      const a = PetEntity(id: 'dog_1', nome: 'Rex', raca: 'Lab', imageUrl: '', tipo: AnimalType.dog);
      const b = PetEntity(id: 'dog_2', nome: 'Rex', raca: 'Lab', imageUrl: '', tipo: AnimalType.dog);
      expect(a == b, false);
    });
    test('Set não permite duplicatas', () {
      const p = PetEntity(id: 'dog_1', nome: 'Rex', raca: 'Lab', imageUrl: '', tipo: AnimalType.dog);
      expect({p, p}.length, 1);
    });
  });
}
