import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(children: [
        _Header('Aparência'),
        SwitchListTile(
          secondary: Icon(settings.themeMode == ThemeMode.dark
              ? Icons.dark_mode
              : Icons.light_mode),
          title: Text(settings.themeMode == ThemeMode.dark ? 'Tema escuro' : 'Tema claro'),
          value: settings.themeMode == ThemeMode.dark,
          onChanged: (v) => notifier.setThemeMode(
            v ? ThemeMode.dark : ThemeMode.light,
          ),
        ),
        const Divider(),
        _Header('Exibir animais'),
        RadioListTile<String>(
          title: const Text('Todos'),
          value: 'all',
          groupValue: settings.filtro,
          onChanged: (v) => notifier.setFiltro(v!),
        ),
        RadioListTile<String>(
          title: const Text('Apenas cães'),
          value: 'dog',
          groupValue: settings.filtro,
          onChanged: (v) => notifier.setFiltro(v!),
        ),
        RadioListTile<String>(
          title: const Text('Apenas gatos'),
          value: 'cat',
          groupValue: settings.filtro,
          onChanged: (v) => notifier.setFiltro(v!),
        ),
        const Divider(),
        _Header('Adoções'),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Histórico de adoções'),
          subtitle: const Text('Ver todas as solicitações enviadas'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/historico'),
        ),
        const Divider(),
        _Header('Sobre'),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('AdotaPet'),
          subtitle: Text('v1.0.0 — Projeto acadêmico Unicesumar'),
        ),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )),
      );
}
