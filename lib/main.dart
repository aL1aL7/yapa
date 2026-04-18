import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'screens/upload_screen.dart';
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
              create: (_) => DocumentsProvider(auth.api!, currentUsername: auth.username),
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

class _MainShellState extends State<_MainShell> with WidgetsBindingObserver {
  static const _shareChannel = MethodChannel('de.yapa.yapa/share');

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Listen for share intents that arrive while the app is already running
    // (Kotlin calls invokeMethod("onSharedFile") from onNewIntent).
    _shareChannel.setMethodCallHandler((call) async {
      if (call.method == 'onSharedFile') await _handleSharedFile();
    });
    // Check for a share intent that launched the app fresh.
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleSharedFile());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _shareChannel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Also check when the app resumes from background (covers most share flows).
    if (state == AppLifecycleState.resumed) _handleSharedFile();
  }

  Future<void> _handleSharedFile() async {
    if (!mounted) return;
    try {
      final result =
          await _shareChannel.invokeMethod<Map<Object?, Object?>>('getSharedFile');
      if (result == null || !mounted) return;
      final path = result['path'] as String;
      final name = result['name'] as String;
      // True when the app was cold-started just for this share — we should
      // return to the calling app once the upload screen is dismissed.
      final shouldFinish = result['shouldFinish'] as bool? ?? false;
      final bytes = await File(path).readAsBytes();
      if (!mounted) return;
      final provider = context.read<DocumentsProvider>();
      final uploaded = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: provider,
            child: UploadScreen(initialBytes: bytes, initialFileName: name),
          ),
        ),
      );
      if (!mounted) return;
      if (uploaded == true) provider.loadDocuments();
      // If YAPA was launched solely as a share target, go back to the
      // calling app after the upload screen closes (uploaded or cancelled).
      if (shouldFinish) SystemNavigator.pop();
    } catch (_) {
      // Silently ignore — no pending share or read error.
    }
  }

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
