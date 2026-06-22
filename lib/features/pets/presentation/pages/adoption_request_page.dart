import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/pet_entity.dart';
import '../providers/providers.dart';

class AdoptionRequestPage extends ConsumerStatefulWidget {
  const AdoptionRequestPage({super.key, required this.pet});
  final PetEntity pet;

  @override
  ConsumerState<AdoptionRequestPage> createState() =>
      _AdoptionRequestPageState();
}

class _AdoptionRequestPageState extends ConsumerState<AdoptionRequestPage> {
  final _formKey   = GlobalKey<FormState>();
  final _nomeCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl   = TextEditingController();
  final _msgCtrl   = TextEditingController();
  bool _enviado    = false;
  bool _salvando   = false;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    final db = ref.read(appDatabaseProvider);
    await db.salvarAdocao(
      petId:       widget.pet.id,
      petNome:     widget.pet.nome,
      petRaca:     widget.pet.raca,
      petImagem:   widget.pet.imageUrl,
      petTipo:     widget.pet.tipo.name,
      solicitante: _nomeCtrl.text.trim(),
      email:       _emailCtrl.text.trim(),
    );

    setState(() {
      _salvando = false;
      _enviado  = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adotar ${widget.pet.nome}')),
      body: _enviado ? _sucesso(context) : _formulario(context),
    );
  }

  Widget _formulario(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.pet.imageUrl),
              ),
              title: Text(widget.pet.nome),
              subtitle: Text(widget.pet.raca),
              trailing: Chip(label: Text(widget.pet.tipo.label)),
            ),
          ),
          const SizedBox(height: 24),
          Text('Seus dados',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _campo(_nomeCtrl, 'Nome completo *', Icons.person_outline,
              (v) => (v == null || v.isEmpty) ? 'Informe seu nome' : null),
          const SizedBox(height: 16),
          _campo(_emailCtrl, 'E-mail *', Icons.email_outlined, (v) {
            if (v == null || v.isEmpty) return 'Informe seu e-mail';
            if (!v.contains('@')) return 'E-mail inválido';
            return null;
          }, tipo: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _campo(_telCtrl, 'Telefone *', Icons.phone_outlined,
              (v) => (v == null || v.isEmpty) ? 'Informe seu telefone' : null,
              tipo: TextInputType.phone),
          const SizedBox(height: 16),
          TextFormField(
            controller: _msgCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Por que você quer adotar? *',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.length < 20) ? 'Mínimo de 20 caracteres' : null,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _salvando ? null : _enviar,
              icon: _salvando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_salvando ? 'Enviando...' : 'Enviar solicitação'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _campo(
    TextEditingController ctrl,
    String label,
    IconData icon,
    String? Function(String?) validator, {
    TextInputType tipo = TextInputType.text,
  }) =>
      TextFormField(
        controller: ctrl,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      );

  Widget _sucesso(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.check_circle_outline,
                size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('Solicitação enviada! 🐾',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              'Entraremos em contato para os próximos passos da adoção de ${widget.pet.nome}.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Voltar para o início'),
            ),
          ]),
        ),
      );
}
