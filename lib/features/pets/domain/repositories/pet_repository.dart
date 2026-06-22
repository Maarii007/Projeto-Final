import '../entities/pet_entity.dart';

abstract class PetRepository {
  Future<List<PetEntity>> getCaes({int limit = 20, int page = 0});
  Future<List<PetEntity>> getGatos({int limit = 20, int page = 0});
  Future<List<PetEntity>> buscarPorRaca(String query, AnimalType tipo);
}

abstract class FavoritoRepository {
  Future<void> adicionar(PetEntity pet);
  Future<void> remover(String petId);
  Future<bool> isFavorito(String petId);
  Future<List<PetEntity>> listar();
}
