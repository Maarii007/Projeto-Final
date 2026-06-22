import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cat_model.dart';
import '../models/dog_model.dart';

const _dogBase = 'https://api.thedogapi.com/v1';
const _catBase = 'https://api.thecatapi.com/v1';

class PetApiService {
  late final Dio _dioCaes;
  late final Dio _dioGatos;

  PetApiService() {
    _dioCaes = _buildDio(dotenv.env['DOG_API_KEY'] ?? '');
    _dioGatos = _buildDio(dotenv.env['CAT_API_KEY'] ?? '');
  }

  static Dio _buildDio(String apiKey) {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    if (apiKey.isNotEmpty) {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['x-api-key'] = apiKey;
          handler.next(options);
        },
      ));
    }
    return dio;
  }

  static const _descricoesCaes = {
    'affenpinscher': (
      'Alemanha',
      '10 - 12 anos',
      '3 - 6',
      'Pequeno e corajoso. Cheio de personalidade, é brincalhão e muito leal ao dono.',
      'Curioso, Brincalhão, Teimoso, Animado'
    ),
    'african': (
      'África do Sul',
      '10 - 12 anos',
      '20 - 45',
      'Robusto e resistente. Muito leal e protetor da família.',
      'Leal, Protetor, Corajoso, Ativo'
    ),
    'airedale': (
      'Inglaterra',
      '10 - 13 anos',
      '18 - 29',
      'Conhecido como o rei dos terriers. Inteligente, corajoso e muito versátil.',
      'Corajoso, Amigável, Inteligente, Confiante'
    ),
    'akita': (
      'Japão',
      '10 - 15 anos',
      '32 - 59',
      'Símbolo de boa saúde e lealdade no Japão. Muito nobre e protetor.',
      'Leal, Receptivo, Digno, Corajoso'
    ),
    'appenzeller': (
      'Suíça',
      '12 - 14 anos',
      '22 - 32',
      'Cão de pastoreio suíço, muito ágil e enérgico. Adora trabalhar.',
      'Enérgico, Confiável, Vivo, Responsável'
    ),
    'australian': (
      'Austrália',
      '12 - 15 anos',
      '16 - 32',
      'Extremamente inteligente e ativo. Precisa de muito exercício e estímulo mental.',
      'Ativo, Inteligente, Protetor, Leal'
    ),
    'basenji': (
      'Congo',
      '10 - 12 anos',
      '9 - 11',
      'O cão que não late! Muito curioso e independente, limpo como um gato.',
      'Inteligente, Energético, Curioso, Reservado'
    ),
    'beagle': (
      'Inglaterra',
      '12 - 15 anos',
      '9 - 11',
      'Curioso e cheio de energia. Adora brincar ao ar livre e é muito dócil com crianças.',
      'Amoroso, Curioso, Alegre, Ativo'
    ),
    'bluetick': (
      'Estados Unidos',
      '11 - 12 anos',
      '20 - 36',
      'Excelente farejador. Dedicado e muito amigável com a família.',
      'Inteligente, Amigável, Ativo, Dedicado'
    ),
    'borzoi': (
      'Rússia',
      '10 - 12 anos',
      '27 - 48',
      'Elegante e veloz. Um dos cães mais rápidos do mundo, muito gentil em casa.',
      'Respeitoso, Gentil, Independente, Leal'
    ),
    'bouvier': (
      'Bélgica',
      '10 - 12 anos',
      '27 - 40',
      'Cão de trabalho versátil e muito inteligente. Ótimo cão de guarda e companhia.',
      'Leal, Racional, Protetor, Inteligente'
    ),
    'boxer': (
      'Alemanha',
      '10 - 12 anos',
      '25 - 32',
      'Brincalhão e cheio de energia. Excelente com crianças e muito protetor da família.',
      'Brincalhão, Leal, Amigável, Protetor'
    ),
    'briard': (
      'França',
      '10 - 12 anos',
      '23 - 41',
      'Pastor francês muito inteligente e dedicado. Excelente memória e muito fiel.',
      'Leal, Inteligente, Protetor, Gentil'
    ),
    'bulldog': (
      'Inglaterra',
      '8 - 10 anos',
      '18 - 23',
      'Calmo e dócil. Apesar da aparência séria, é muito afetuoso e adora crianças.',
      'Dócil, Amigável, Willful, Gregário'
    ),
    'cairn': (
      'Escócia',
      '12 - 15 anos',
      '4 - 7',
      'Pequeno e corajoso. Um dos terriers mais antigos, muito animado e curioso.',
      'Assertivo, Alegre, Brincalhão, Corajoso'
    ),
    'cattledog': (
      'Austrália',
      '12 - 16 anos',
      '15 - 22',
      'Incansável e muito inteligente. Precisa de trabalho e exercício constante.',
      'Cauteloso, Energético, Leal, Obediente'
    ),
    'chihuahua': (
      'México',
      '12 - 20 anos',
      '1 - 3',
      'Menor raça do mundo, mas com personalidade gigante. Muito apegado ao dono.',
      'Devotado, Leal, Corajoso, Animado'
    ),
    'chow': (
      'China',
      '9 - 15 anos',
      '20 - 32',
      'Um dos cães mais antigos do mundo. Independente e muito leal a um dono específico.',
      'Leal, Independente, Quieto, Reservado'
    ),
    'clumber': (
      'Inglaterra',
      '10 - 12 anos',
      '25 - 39',
      'Calmo e gentil. Ótimo cão de caça e companhia, muito carinhoso com a família.',
      'Gentil, Leal, Afável, Digno'
    ),
    'cockapoo': (
      'Estados Unidos',
      '12 - 15 anos',
      '5 - 11',
      'Mistura de Cocker Spaniel e Poodle. Muito inteligente, afetivo e hipoalergênico.',
      'Amoroso, Alegre, Inteligente, Ativo'
    ),
    'collie': (
      'Escócia',
      '12 - 14 anos',
      '18 - 29',
      'Famoso pelo Lassie! Muito inteligente, gentil e excelente com crianças.',
      'Leal, Gentil, Ativo, Inteligente'
    ),
    'dachshund': (
      'Alemanha',
      '12 - 16 anos',
      '3 - 5',
      'Conhecido como salsicha, é corajoso e curioso. Ótimo companheiro para apartamento.',
      'Esperto, Teimoso, Brincalhão, Dedicado'
    ),
    'dalmatian': (
      'Croácia',
      '10 - 13 anos',
      '16 - 32',
      'Inconfundível com suas pintas. Muito energético e brincalhão, adora correr.',
      'Ativo, Amigável, Independente, Inteligente'
    ),
    'doberman': (
      'Alemanha',
      '10 - 13 anos',
      '27 - 45',
      'Elegante e poderoso. Muito inteligente e leal, excelente cão de proteção.',
      'Enérgico, Determinado, Alerta, Leal'
    ),
    'germanshepherd': (
      'Alemanha',
      '9 - 13 anos',
      '22 - 40',
      'Versátil e protetor. Muito usado como cão de trabalho e guarda, extremamente inteligente.',
      'Corajoso, Confiante, Inteligente, Leal'
    ),
    'golden': (
      'Escócia',
      '10 - 12 anos',
      '25 - 34',
      'Uma das raças mais populares do mundo. Extremamente dócil e paciente, ideal para famílias.',
      'Inteligente, Confiável, Amigável, Confiante'
    ),
    'greyhound': (
      'Reino Unido',
      '10 - 13 anos',
      '27 - 40',
      'O cão mais veloz do mundo. Surpreendentemente calmo e dócil em casa.',
      'Gentil, Inteligente, Atlético, Leal'
    ),
    'husky': (
      'Sibéria',
      '12 - 14 anos',
      '16 - 27',
      'Energético e independente. Precisa de muito exercício e adora companhia.',
      'Leal, Amigável, Gentil, Inteligente'
    ),
    'labrador': (
      'Canadá',
      '10 - 12 anos',
      '25 - 36',
      'Extremamente sociável e brincalhão. Ótimo com crianças e outros animais.',
      'Ativo, Inteligente, Gentil, Confiável'
    ),
    'mix': (
      'Brasil',
      '12 - 20 anos',
      'Variado',
      'O melhor amigo brasileiro! Resiliente, inteligente e muito fiel. Adotar um vira-lata é um ato de amor.',
      'Leal, Adaptável, Carinhoso, Resistente'
    ),
  };

  Future<List<DogModel>> getCaes({int limit = 30, int page = 0}) async {
    // Busca lista de raças
    final breedsResp =
        await _dioCaes.get('https://dog.ceo/api/breeds/list/all');
    final breedsMap = breedsResp.data['message'] as Map<String, dynamic>;

    // Pega só as raças da página atual
    final allBreeds = breedsMap.keys.toList();
    final start = page * limit;
    final end = (start + limit).clamp(0, allBreeds.length);
    final pageBreeds = allBreeds.sublist(start, end);

    final result = <DogModel>[];

    // Busca todas as imagens em paralelo
    final futures = pageBreeds.map((breed) async {
      try {
        final imgResp = await _dioCaes.get(
          'https://dog.ceo/api/breed/$breed/images/random',
        );
        final imgUrl = imgResp.data['message'] as String;
        final desc = _descricoesCaes[breed];
        return DogModel.fromJson({
          'id': allBreeds.indexOf(breed),
          'name': breed[0].toUpperCase() + breed.substring(1),
          'image': {'url': imgUrl},
          if (desc != null) 'origin': desc.$1,
          if (desc != null) 'life_span': desc.$2,
          if (desc != null) 'weight': {'metric': desc.$3},
          if (desc != null) 'description': desc.$4,
          if (desc != null) 'temperament': desc.$5,
        });
      } catch (_) {
        return null;
      }
    });

    final models = await Future.wait(futures);
    result.addAll(models.whereType<DogModel>());
    return result;
  }

  Future<List<DogModel>> buscarCaes(String query) async {
    final response = await _dioCaes.get(
      '$_dogBase/breeds/search',
      queryParameters: {'q': query},
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => DogModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CatModel>> getGatos({int limit = 30, int page = 0}) async {
    final gatos = [
      {
        'id': 'abys',
        'name': 'Abissínio',
        'temperament': 'Ativo, Energético, Independente, Inteligente',
        'origin': 'Etiópia',
        'life_span': '14 - 17',
        'weight': {'metric': '3 - 5'},
        'description':
            'Um dos gatos mais antigos do mundo. Ágil e curioso, adora explorar tudo ao redor.',
        'image': {'url': 'assets/images/abissimo.jfif'},
      },
      {
        'id': 'beng',
        'name': 'Bengal',
        'temperament': 'Alerta, Ágil, Energético, Exigente, Inteligente',
        'origin': 'Estados Unidos',
        'life_span': '12 - 16',
        'weight': {'metric': '3 - 7'},
        'description':
            'Parece um leopardo em miniatura! Muito ativo e brincalhão, adora água.',
        'image': {'url': 'assets/images/bengal.jfif'},
      },
      {
        'id': 'bure',
        'name': 'Burmês',
        'temperament': 'Curioso, Inteligente, Gentil, Sociável',
        'origin': 'Birmânia',
        'life_span': '10 - 16',
        'weight': {'metric': '3 - 6'},
        'description':
            'Compacto e musculoso. Extremamente afetivo, segue o dono por toda a casa.',
        'image': {'url': 'assets/images/burmes.jfif'},
      },
      {
        'id': 'main',
        'name': 'Maine Coon',
        'temperament': 'Adaptável, Inteligente, Amoroso, Gentil',
        'origin': 'Estados Unidos',
        'life_span': '12 - 15',
        'weight': {'metric': '4 - 8'},
        'description':
            'Um dos maiores gatos domésticos. Pelagem luxuosa e personalidade de cão — leal e brincalhão.',
        'image': {'url': 'assets/images/maine.jfif'},
      },
      {
        'id': 'pers',
        'name': 'Persa',
        'temperament': 'Afetuoso, Leal, Calmo, Quieto, Gentil',
        'origin': 'Irã',
        'life_span': '10 - 17',
        'weight': {'metric': '3 - 6'},
        'description':
            'Elegante e tranquilo. Adora ambientes calmos e é muito carinhoso com a família.',
        'image': {'url': 'assets/images/persa.jfif'},
      },
      {
        'id': 'rags',
        'name': 'Ragdoll',
        'temperament': 'Afetuoso, Gentil, Calmo, Sociável',
        'origin': 'Estados Unidos',
        'life_span': '12 - 17',
        'weight': {'metric': '5 - 9'},
        'description':
            'Fica mole nos braços como uma boneca de pano. Muito dócil e ideal para famílias.',
        'image': {'url': 'assets/images/ragdoll.jfif'},
      },
      {
        'id': 'sibe',
        'name': 'Siberiano',
        'temperament': 'Curioso, Agil, Calmo, Inteligente, Leal',
        'origin': 'Rússia',
        'life_span': '12 - 15',
        'weight': {'metric': '4 - 9'},
        'description':
            'Gato de floresta com pelo triplo. Hipoalergênico e muito resistente ao frio.',
        'image': {'url': 'assets/images/sibe.jfif'},
      },
      {
        'id': 'soma',
        'name': 'Somali',
        'temperament': 'Brincalhão, Curioso, Interativo, Ativo',
        'origin': 'Somália',
        'life_span': '12 - 14',
        'weight': {'metric': '3 - 5'},
        'description':
            'Versão de pelo longo do Abissínio. Cheio de energia e muito inteligente.',
        'image': {'url': 'assets/images/somali.jfif'},
      },
      {
        'id': 'sphy',
        'name': 'Sphynx',
        'temperament': 'Carinhoso, Leal, Inteligente, Curioso, Amigável',
        'origin': 'Canadá',
        'life_span': '8 - 14',
        'weight': {'metric': '3 - 5'},
        'description':
            'Sem pelos mas cheio de amor! Extremamente apegado ao dono, adora calor humano.',
        'image': {'url': 'assets/images/sphynx.jfif'},
      },
      {
        'id': 'tvan',
        'name': 'Turkish Van',
        'temperament': 'Ágil, Inteligente, Leal, Brincalhão, Energético',
        'origin': 'Turquia',
        'life_span': '12 - 17',
        'weight': {'metric': '3 - 9'},
        'description':
            'Conhecido como o gato nadador. Adora água e é muito ativo e curioso.',
        'image': {'url': 'assets/images/turkish.jfif'},
      },
      {
        'id': 'vira',
        'name': 'Frajolinha',
        'temperament': 'Adaptável, Carinhoso, Resistente, Leal',
        'origin': 'Brasil',
        'life_span': '12 - 20',
        'weight': {'metric': 'Variado'},
        'description':
            'O gatinho brasileiro! Resiliente e muito carinhoso. Adotar um Sem Raça Definida é um ato de amor e solidariedade.',
        'image': {'url': 'assets/images/frajolinha.jfif'},
      },
    ];

    return gatos.map((g) => CatModel.fromJson(g)).toList();
  }

  Future<List<CatModel>> buscarGatos(String query) async {
    final response = await _dioGatos.get(
      '$_catBase/breeds/search',
      queryParameters: {'q': query},
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => CatModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
