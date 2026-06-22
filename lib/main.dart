import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/services/prefs.dart';
import 'core/theme/app_theme.dart';
import 'features/pets/presentation/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final resultados = await Future.wait([
    Prefs.loadThemeMode(),
    Prefs.loadFilter(),
  ]);

  final savedTheme  = resultados[0] as String;
  final savedFilter = resultados[1] as String;

  SettingsNotifier.setInitial(savedTheme, savedFilter);

  runApp(const ProviderScope(child: AdotaPetApp()));
}

class AdotaPetApp extends ConsumerWidget {
  const AdotaPetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'AdotaPet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: appRouter,
    );
  }
}
