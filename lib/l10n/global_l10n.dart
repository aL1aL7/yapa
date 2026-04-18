import 'app_localizations.dart';

AppLocalizations? _current;

AppLocalizations? get currentL10n => _current;

void setCurrentL10n(AppLocalizations l10n) {
  _current = l10n;
}
