import '../entities/pet_entity.dart';
import '../repositories/pet_repository.dart';

class BuscarCaesUseCase {
  const BuscarCaesUseCase(this._repo);
  final PetRepository _repo;
  Future<List<PetEntity>> call({int limit = 20, int page = 0}) =>
      _repo.getCaes(limit: limit, page: page);
}

class BuscarGatosUseCase {
  const BuscarGatosUseCase(this._repo);
  final PetRepository _repo;
  Future<List<PetEntity>> call({int limit = 20, int page = 0}) =>
      _repo.getGatos(limit: limit, page: page);
}

class PesquisarPorRacaUseCase {
  const PesquisarPorRacaUseCase(this._repo);
  final PetRepository _repo;
  Future<List<PetEntity>> call(String query, AnimalType tipo) {
    if (query.trim().isEmpty) return Future.value([]);
    return _repo.buscarPorRaca(query.trim(), tipo);
  }
}

class AlternarFavoritoUseCase {
  const AlternarFavoritoUseCase(this._repo);
  final FavoritoRepository _repo;
  Future<bool> call(PetEntity pet) async {
    final ja = await _repo.isFavorito(pet.id);
    if (ja) {
      await _repo.remover(pet.id);
      return false;
    } else {
      await _repo.adicionar(pet);
      return true;
    }
  }
}

class ListarFavoritosUseCase {
  const ListarFavoritosUseCase(this._repo);
  final FavoritoRepository _repo;
  Future<List<PetEntity>> call() => _repo.listar();
}

class VerificarFavoritoUseCase {
  const VerificarFavoritoUseCase(this._repo);
  final FavoritoRepository _repo;
  Future<bool> call(String petId) => _repo.isFavorito(petId);
}
