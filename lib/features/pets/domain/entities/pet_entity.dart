enum AnimalType {
  dog,
  cat;

  String get label => this == AnimalType.dog ? 'Cachorro' : 'Gato';
}

class PetEntity {
  const PetEntity({
    required this.id,
    required this.nome,
    required this.raca,
    required this.imageUrl,
    required this.tipo,
    this.temperamento,
    this.peso,
    this.origem,
    this.vidaMedia,
    this.descricao,
  });

  final String id;
  final String nome;
  final String raca;
  final String imageUrl;
  final AnimalType tipo;
  final String? temperamento;
  final String? peso;
  final String? origem;
  final String? vidaMedia;
  final String? descricao;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PetEntity && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
