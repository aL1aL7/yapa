import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/global_l10n.dart';
import 'providers/auth_provider.dart';
import 'providers/documents_provider.dart';
import 'providers/app_settings_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/notifications_provider.dart';
import 'screens/login_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YapaApp());
}

class YapaApp extends StatelessWidget {
  const YapaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(storage)..init()),
        ChangeNotifierProvider(create: (_) => LocaleProvider(storage)..init()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider(storage)..init()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) => MaterialApp(
          title: 'YAPA',
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('de'),
            Locale('en'),
            Locale('es'),
            Locale('fr'),
            Locale('it'),
            Locale('pl'),
            Locale('pt'),
            Locale('cs'),
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          builder: (context, child) {
            final l10n = AppLocalizations.of(context);
            if (l10n != null) setCurrentL10n(l10n);
            return child!;
          },
          home: const _AppRoot(),
        ),
      ),
    );
  }
}

class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.unauthenticated:
        return const LoginScreen();
      case AuthStatus.authenticated:
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => DocumentsProvider(auth.api!),
            ),
            ChangeNotifierProvider(
              create: (_) => NotificationsProvider(auth.api!)..load(),
            ),
          ],
          child: const _MainShell(),
        );
    }
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unread = context.watch<NotificationsProvider>().unacknowledgedCount;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          DocumentsScreen(),
          NotificationsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) {
          setState(() => _selectedIndex = i);
          // Reload tasks every time the notifications tab is opened.
          if (i == 1) context.read<NotificationsProvider>().load();
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.folder_outlined),
            selectedIcon: const Icon(Icons.folder),
            label: l10n?.navDocuments ?? 'Dokumente',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text(unread > 9 ? '9+' : '$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: unread > 0,
              label: Text(unread > 9 ? '9+' : '$unread'),
              child: const Icon(Icons.notifications),
            ),
            label: l10n?.navNotifications ?? 'Dateiaufgaben',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n?.navSettings ?? 'Einstellungen',
          ),
        ],
      ),
    );
  }
}
