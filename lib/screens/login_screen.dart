import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum _LoginMode { credentials, token }

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureToken = true;
  bool _allowSelfSigned = false;
  bool _showSelfSignedWarning = false;
  _LoginMode _loginMode = _LoginMode.credentials;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final storage = StorageService();
    final creds = await storage.getCredentials();
    final allowSelfSigned = await storage.getAllowSelfSigned();
    if (mounted) {
      setState(() {
        if (creds.serverUrl != null) _serverController.text = creds.serverUrl!;
        if (creds.username != null) {
          _usernameController.text = creds.username!;
          _loginMode = _LoginMode.credentials;
        } else if (creds.serverUrl != null) {
          // Previously logged in with token
          _loginMode = _LoginMode.token;
        }
        _allowSelfSigned = allowSelfSigned;
      });
    }
  }

  @override
  void dispose() {
    _serverController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    if (_loginMode == _LoginMode.token) {
      await auth.loginWithToken(
        serverUrl: _serverController.text.trim(),
        token: _tokenController.text.trim(),
        allowSelfSigned: _allowSelfSigned,
      );
    } else {
      await auth.login(
        serverUrl: _serverController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        allowSelfSigned: _allowSelfSigned,
      );
    }
  }

  String? _validateUrl(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return l10n?.loginValidateServerUrl ?? 'Bitte Server-URL eingeben';
    }
    if (!value.trim().startsWith('https://')) {
      return l10n?.loginValidateHttps ?? 'Nur HTTPS-Verbindungen erlaubt (https://...)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/icon/app_icon.png', width: 182, height: 128),
                const SizedBox(height: 12),
                Text(
                  'YAPA',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  l10n?.appTagline ?? 'Yet Another Paperless App',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 40),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    if (auth.error != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: theme.colorScheme.onErrorContainer, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  auth.error!,
                                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: auth.clearError,
                                color: theme.colorScheme.onErrorContainer,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Mode toggle
                      SegmentedButton<_LoginMode>(
                        segments: [
                          ButtonSegment(
                            value: _LoginMode.credentials,
                            label: Text(l10n?.loginTabCredentials ?? 'Anmeldedaten'),
                            icon: const Icon(Icons.person_outline),
                          ),
                          ButtonSegment(
                            value: _LoginMode.token,
                            label: Text(l10n?.loginTabToken ?? 'API-Token'),
                            icon: const Icon(Icons.key_outlined),
                          ),
                        ],
                        selected: {_loginMode},
                        onSelectionChanged: (selection) => setState(() {
                          _loginMode = selection.first;
                          context.read<AuthProvider>().clearError();
                          _formKey.currentState?.reset();
                        }),
                      ),
                      const SizedBox(height: 20),

                      // Server URL (always shown)
                      TextFormField(
                        controller: _serverController,
                        keyboardType: TextInputType.url,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: l10n?.loginServerUrl ?? 'Server-URL',
                          hintText: l10n?.loginServerUrlHint ?? 'https://paperless.example.com',
                          prefixIcon: const Icon(Icons.dns_outlined),
                          border: const OutlineInputBorder(),
                        ),
                        validator: _validateUrl,
                      ),
                      const SizedBox(height: 16),

                      // Credentials mode fields
                      if (_loginMode == _LoginMode.credentials) ...[
                        TextFormField(
                          controller: _usernameController,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: l10n?.loginUsername ?? 'Benutzername',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? (l10n?.loginValidateUsername ?? 'Bitte Benutzername eingeben')
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: l10n?.loginPassword ?? 'Passwort',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? (l10n?.loginValidatePassword ?? 'Bitte Passwort eingeben')
                              : null,
                          onFieldSubmitted: (_) => _login(),
                        ),
                      ],

                      // Token mode field
                      if (_loginMode == _LoginMode.token)
                        TextFormField(
                          controller: _tokenController,
                          obscureText: _obscureToken,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: l10n?.loginApiToken ?? 'API-Token',
                            hintText: l10n?.loginApiTokenHint ?? 'Token aus den Paperless-Einstellungen',
                            prefixIcon: const Icon(Icons.key_outlined),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureToken
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () =>
                                  setState(() => _obscureToken = !_obscureToken),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? (l10n?.loginValidateToken ?? 'Bitte API-Token eingeben')
                              : null,
                          onFieldSubmitted: (_) => _login(),
                        ),

                      const SizedBox(height: 8),

                      // Self-signed cert checkbox (always shown)
                      InkWell(
                        onTap: () => setState(() {
                          if (!_allowSelfSigned) {
                            _showSelfSignedWarning = true;
                          } else {
                            _allowSelfSigned = false;
                            _showSelfSignedWarning = false;
                          }
                        }),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _allowSelfSigned,
                                onChanged: (v) {
                                  if (v == true) {
                                    setState(() => _showSelfSignedWarning = true);
                                  } else {
                                    setState(() {
                                      _allowSelfSigned = false;
                                      _showSelfSignedWarning = false;
                                    });
                                  }
                                },
                              ),
                              Expanded(
                                child: Text(l10n?.loginAllowSelfSigned ??
                                    'Selbst-signierte Zertifikate erlauben'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showSelfSignedWarning && !_allowSelfSigned)
                        _SelfSignedWarningDialog(
                          onConfirm: () => setState(() {
                            _allowSelfSigned = true;
                            _showSelfSignedWarning = false;
                          }),
                          onCancel: () => setState(() => _showSelfSignedWarning = false),
                        ),
                      const SizedBox(height: 24),
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) => FilledButton(
                          onPressed: auth.isLoading ? null : _login,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n?.loginButton ?? 'Anmelden'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelfSignedWarningDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _SelfSignedWarningDialog({required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.tertiary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_outlined, color: theme.colorScheme.tertiary, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n?.loginSecurityWarningTitle ?? 'Sicherheitswarnung',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.loginSecurityWarningText ??
                'Das Erlauben selbst-signierter Zertifikate verringert die Sicherheit. '
                'Nur aktivieren, wenn du weißt, was du tust und dem Server vertraust.',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text(l10n?.actionCancel ?? 'Abbrechen'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: onConfirm,
                child: Text(l10n?.actionConfirm ?? 'Verstanden'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
