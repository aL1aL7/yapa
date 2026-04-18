import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/documents_provider.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();
  int? _defaultViewId;
  bool _defaultViewLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultViewId();
  }

  Future<void> _loadDefaultViewId() async {
    final id = await StorageService().getDefaultViewId();
    if (mounted) setState(() { _defaultViewId = id; _defaultViewLoaded = true; });
  }

  Future<void> _setDefaultView(int? id) async {
    await StorageService().setDefaultViewId(id);
    setState(() => _defaultViewId = id);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<DocumentsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Verbindung', style: theme.textTheme.labelLarge),
          ),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: const Text('Server'),
            subtitle: Text(auth.serverUrl ?? '—'),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Benutzer'),
            subtitle: Text(auth.username ?? '—'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Ansicht', style: theme.textTheme.labelLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: _defaultViewLoaded
                ? DropdownButtonFormField<int?>(
                    initialValue: _defaultViewId,
                    decoration: const InputDecoration(
                      labelText: 'Standard-Ansicht beim Start',
                      prefixIcon: Icon(Icons.bookmark_outline),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Alle Dokumente'),
                      ),
                      ...provider.savedViews.map((v) => DropdownMenuItem(
                            value: v.id,
                            child: Text(v.name),
                          )),
                    ],
                    onChanged: _setDefaultView,
                  )
                : const SizedBox(
                    height: 56,
                    child: Center(child: LinearProgressIndicator()),
                  ),
          ),
          if (provider.savedViews.isEmpty && _defaultViewLoaded)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                'Keine gespeicherten Ansichten vorhanden.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          const SizedBox(height: 8),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Sicherheit', style: theme.textTheme.labelLarge),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Nur HTTPS-Verbindungen'),
            subtitle: const Text('Standardmäßig aktiv und nicht deaktivierbar'),
            trailing: const Icon(Icons.lock, color: Colors.green),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Konto', style: theme.textTheme.labelLarge),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text('Abmelden',
                style: TextStyle(color: theme.colorScheme.error)),
            subtitle: const Text('Token und gespeicherte Daten löschen'),
            onTap: () => _confirmLogout(context, auth),
          ),
          const Divider(),
          FutureBuilder<PackageInfo>(
            future: _packageInfo,
            builder: (context, snapshot) {
              final info = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        width: 72,
                        height: 72,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      info?.appName ?? 'YAPA',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Yet Another Paperless-ngx App',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info != null
                          ? 'Version ${info.version}+${info.buildNumber}'
                          : '—',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abmelden'),
        content: const Text(
            'Gespeicherter Token und Verbindungsdaten werden gelöscht. Fortfahren?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) auth.logout();
    });
  }
}
