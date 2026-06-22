import '../../../../core/database/app_database.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pet_repository.dart';

class FavoritoRepositoryImpl implements FavoritoRepository {
  FavoritoRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Future<void> adicionar(PetEntity pet) => _db.adicionarFavorito(
        id: pet.id,
        nome: pet.nome,
        raca: pet.raca,
        imageUrl: pet.imageUrl,
        tipo: pet.tipo.name,
        temperamento: pet.temperamento,
        peso: pet.peso,
      );

  @override
  Future<void> remover(String petId) => _db.removerFavorito(petId);

  @override
  Future<bool> isFavorito(String petId) => _db.isFavorito(petId);

  @override
  Future<List<PetEntity>> listar() async {
    final rows = await _db.listarFavoritos();
    return rows
        .map((r) => PetEntity(
              id: r.id,
              nome: r.nome,
              raca: r.raca,
              imageUrl: r.imageUrl,
              tipo: AnimalType.values.firstWhere(
                (e) => e.name == r.tipo,
                orElse: () => AnimalType.dog,
              ),
              temperamento: r.temperamento,
              peso: r.peso,
            ))
        .toList();
  }
}
