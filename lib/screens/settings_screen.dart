import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
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
            title: Text('Abmelden', style: TextStyle(color: theme.colorScheme.error)),
            subtitle: const Text('Token und gespeicherte Daten löschen'),
            onTap: () => _confirmLogout(context, auth),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('App', style: theme.textTheme.labelLarge),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('YAPA'),
            subtitle: Text('Yet Another Paperless App\npaper-ngx Mobile Client'),
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
