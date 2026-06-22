import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pet_repository.dart';
import '../sources/pet_api_service.dart';

class PetRepositoryImpl implements PetRepository {
  PetRepositoryImpl(this._api);
  final PetApiService _api;

  @override
  Future<List<PetEntity>> getCaes({int limit = 20, int page = 0}) async {
    final models = await _api.getCaes(limit: limit, page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PetEntity>> getGatos({int limit = 20, int page = 0}) async {
    final models = await _api.getGatos(limit: limit, page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PetEntity>> buscarPorRaca(String query, AnimalType tipo) async {
    if (tipo == AnimalType.dog) {
      final models = await _api.buscarCaes(query);
      return models.map((m) => m.toEntity()).toList();
    } else {
      final models = await _api.buscarGatos(query);
      return models.map((m) => m.toEntity()).toList();
    }
  }
}
