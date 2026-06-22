import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../providers/providers.dart';

class HistoricoPage extends ConsumerStatefulWidget {
  const HistoricoPage({super.key});

  @override
  ConsumerState<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends ConsumerState<HistoricoPage> {
  List<HistoricoAdocoe> _historico = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final db = ref.read(appDatabaseProvider);
    final lista = await db.listarHistorico();
    if (mounted) {
      setState(() {
        _historico = lista;
        _carregando = false;
      });
    }
  }

  String _formatarData(int ms) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Adoções')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _historico.isEmpty
              ? const Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text('Nenhuma adoção solicitada ainda',
                        style: TextStyle(color: Colors.grey)),
                  ]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _historico.length,
                  itemBuilder: (context, i) {
                    final item = _historico[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: item.petImagem,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.pets, size: 40),
                          ),
                        ),
                        title: Text(item.petNome,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.petRaca),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.person_outline, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(item.solicitante,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ]),
                            Row(children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 14),
                              const SizedBox(width: 4),
                              Text(_formatarData(item.dataMs),
                                  style: const TextStyle(fontSize: 12)),
                            ]),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            item.petTipo == 'dog' ? 'Cachorro' : 'Gato',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
