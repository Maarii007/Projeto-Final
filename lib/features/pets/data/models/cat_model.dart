import '../../domain/entities/pet_entity.dart';

class CatModel {
  const CatModel({
    required this.id,
    required this.nome,
    this.temperamento,
    this.origem,
    this.vidaMedia,
    this.peso,
    this.imageUrl,
    this.descricao,
  });

  final String id;
  final String nome;
  final String? temperamento;
  final String? origem;
  final String? vidaMedia;
  final String? peso;
  final String? imageUrl;
  final String? descricao;

  factory CatModel.fromJson(Map<String, dynamic> json) {
    String? imgUrl;
    final img = json['image'];
    if (img is Map<String, dynamic>) {
      imgUrl = img['url'] as String?;
    }
    if (imgUrl == null) {
      final refId = json['reference_image_id'];
      if (refId != null) {
        imgUrl = 'https://cdn2.thecatapi.com/images/$refId.jpg';
      }
    }

    String? pesoStr;
    final w = json['weight'];
    if (w is Map<String, dynamic>) {
      pesoStr = w['metric'] as String?;
    }

    return CatModel(
      id: (json['id'] as String?) ?? '',
      nome: (json['name'] as String?) ?? 'Sem nome',
      temperamento: json['temperament'] as String?,
      origem: json['origin'] as String?,
      vidaMedia: json['life_span'] as String?,
      peso: pesoStr,
      imageUrl: imgUrl,
      descricao: json['description'] as String?,
    );
  }

  PetEntity toEntity() => PetEntity(
        id: 'cat_$id',
        nome: nome,
        raca: nome,
        imageUrl: imageUrl ?? 'https://placekitten.com/400/300',
        tipo: AnimalType.cat,
        temperamento: temperamento,
        peso: peso,
        origem: origem,
        vidaMedia: vidaMedia,
        descricao: descricao,
      );
}
