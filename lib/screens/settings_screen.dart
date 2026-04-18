import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/documents_provider.dart';
import '../providers/locale_provider.dart';
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

  static const _supportedLocales = [
    (code: 'de', name: 'Deutsch'),
    (code: 'en', name: 'English'),
    (code: 'es', name: 'Español'),
    (code: 'fr', name: 'Français'),
    (code: 'it', name: 'Italiano'),
    (code: 'pl', name: 'Polski'),
    (code: 'pt', name: 'Português'),
    (code: 'cs', name: 'Čeština'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<DocumentsProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final appSettings = context.watch<AppSettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.settingsTitle ?? 'Einstellungen')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(l10n?.settingsSectionConnection ?? 'Verbindung', style: theme.textTheme.labelLarge),
          ),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: Text(l10n?.settingsServer ?? 'Server'),
            subtitle: Text(auth.serverUrl ?? '—'),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n?.settingsUser ?? 'Benutzer'),
            subtitle: Text(auth.username ?? '—'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(l10n?.settingsSectionView ?? 'Ansicht', style: theme.textTheme.labelLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: _defaultViewLoaded
                ? DropdownButtonFormField<int?>(
                    initialValue: _defaultViewId,
                    decoration: InputDecoration(
                      labelText: l10n?.settingsDefaultView ?? 'Standard-Ansicht beim Start',
                      prefixIcon: const Icon(Icons.bookmark_outline),
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(l10n?.documentsAll ?? 'Alle Dokumente'),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                l10n?.settingsNoSavedViews ?? 'Keine gespeicherten Ansichten vorhanden.',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          const SizedBox(height: 8),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(l10n?.settingsSectionLanguage ?? 'Sprache', style: theme.textTheme.labelLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: DropdownButtonFormField<String?>(
              value: localeProvider.locale?.languageCode,
              decoration: InputDecoration(
                labelText: l10n?.settingsLanguageLabel ?? 'Sprache',
                prefixIcon: const Icon(Icons.language),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(l10n?.settingsLanguageSystem ?? 'Systemsprache'),
                ),
                ..._supportedLocales.map((loc) => DropdownMenuItem(
                      value: loc.code,
                      child: Text(loc.name),
                    )),
              ],
              onChanged: (code) {
                localeProvider.setLocale(
                  code == null ? null : Locale(code),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(l10n?.settingsSectionDisplay ?? 'Darstellung', style: theme.textTheme.labelLarge),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.label_outline),
            title: Text(l10n?.settingsTagsAsDropdown ?? 'Tags als Dropdown'),
            subtitle: Text(l10n?.settingsTagsAsDropdownDesc ?? 'Tags als Multi-Select-Liste anstelle von Chips anzeigen'),
            value: appSettings.tagsAsDropdown,
            onChanged: appSettings.setTagsAsDropdown,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.bookmark_outline),
            title: Text(l10n?.settingsSavedViewsAsDropdown ?? 'Ansichten als Dropdown'),
            subtitle: Text(l10n?.settingsSavedViewsAsDropdownDesc ?? 'Gespeicherte Ansichten als Dropdown statt Chips anzeigen'),
            value: appSettings.savedViewsAsDropdown,
            onChanged: appSettings.setSavedViewsAsDropdown,
          ),
          const SizedBox(height: 8),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(l10n?.settingsSectionSecurity ?? 'Sicherheit', style: theme.textTheme.labelLarge),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text(l10n?.settingsHttpsOnly ?? 'Nur HTTPS-Verbindungen'),
            subtitle: Text(l10n?.settingsHttpsOnlyDesc ?? 'Standardmäßig aktiv und nicht deaktivierbar'),
            trailing: const Icon(Icons.lock, color: Colors.green),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(l10n?.settingsSectionAccount ?? 'Konto', style: theme.textTheme.labelLarge),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text(
              l10n?.settingsLogout ?? 'Abmelden',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            subtitle: Text(l10n?.settingsLogoutDesc ?? 'Token und gespeicherte Daten löschen'),
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
                      l10n?.appDescription ?? 'Yet Another Paperless-ngx App',
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
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.settingsLogoutDialogTitle ?? 'Abmelden'),
        content: Text(
            l10n?.settingsLogoutDialogContent ??
                'Gespeicherter Token und Verbindungsdaten werden gelöscht. Fortfahren?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n?.actionCancel ?? 'Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n?.settingsLogout ?? 'Abmelden'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) auth.logout();
    });
  }
}
