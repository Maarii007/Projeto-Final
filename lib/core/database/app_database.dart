import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Favoritos extends Table {
  TextColumn get id           => text()();
  TextColumn get nome         => text()();
  TextColumn get raca         => text()();
  TextColumn get imageUrl     => text().named('image_url')();
  TextColumn get tipo         => text()();
  TextColumn get temperamento => text().nullable()();
  TextColumn get peso         => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class HistoricoAdocoes extends Table {
  IntColumn  get id        => integer().autoIncrement()();
  TextColumn get petId     => text().named('pet_id')();
  TextColumn get petNome   => text().named('pet_nome')();
  TextColumn get petRaca   => text().named('pet_raca')();
  TextColumn get petImagem => text().named('pet_imagem')();
  TextColumn get petTipo   => text().named('pet_tipo')();
  TextColumn get solicitante => text()();
  TextColumn get email     => text()();
  IntColumn  get dataMs    => integer().named('data_ms')();
}

@DriftDatabase(tables: [Favoritos, HistoricoAdocoes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(historicoAdocoes);
      }
    },
  );

  Future<List<Favorito>> listarFavoritos() => select(favoritos).get();

  Future<bool> isFavorito(String id) async {
    final result = await (select(favoritos)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null;
  }

  Future<void> adicionarFavorito({
    required String id,
    required String nome,
    required String raca,
    required String imageUrl,
    required String tipo,
    String? temperamento,
    String? peso,
  }) =>
      into(favoritos).insertOnConflictUpdate(
        FavoritosCompanion.insert(
          id: id,
          nome: nome,
          raca: raca,
          imageUrl: imageUrl,
          tipo: tipo,
          temperamento: Value(temperamento),
          peso: Value(peso),
        ),
      );

  Future<void> removerFavorito(String id) =>
      (delete(favoritos)..where((t) => t.id.equals(id))).go();

  Future<void> salvarAdocao({
    required String petId,
    required String petNome,
    required String petRaca,
    required String petImagem,
    required String petTipo,
    required String solicitante,
    required String email,
  }) =>
      into(historicoAdocoes).insert(
        HistoricoAdocoesCompanion.insert(
          petId: petId,
          petNome: petNome,
          petRaca: petRaca,
          petImagem: petImagem,
          petTipo: petTipo,
          solicitante: solicitante,
          email: email,
          dataMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );

  Future<List<HistoricoAdocoe>> listarHistorico() =>
      (select(historicoAdocoes)
            ..orderBy([(t) => OrderingTerm.desc(t.dataMs)]))
          .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'adotapet.db'));
    return NativeDatabase.createInBackground(file);
  });
}
