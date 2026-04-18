// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTagline => 'Yet Another Paperless App';

  @override
  String get appDescription => 'Yet Another Paperless-ngx App';

  @override
  String get navDocuments => 'Dokumente';

  @override
  String get navNotifications => 'Dateiaufgaben';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionConfirm => 'Verstanden';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get actionRefresh => 'Aktualisieren';

  @override
  String get actionLogout => 'Abmelden';

  @override
  String get actionClearAll => 'Alle löschen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionSave => 'Speichern';

  @override
  String get loginServerUrl => 'Server-URL';

  @override
  String get loginServerUrlHint => 'https://paperless.example.com';

  @override
  String get loginUsername => 'Benutzername';

  @override
  String get loginPassword => 'Passwort';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get loginAllowSelfSigned => 'Selbst-signierte Zertifikate erlauben';

  @override
  String get loginSecurityWarningTitle => 'Sicherheitswarnung';

  @override
  String get loginSecurityWarningText =>
      'Das Erlauben selbst-signierter Zertifikate verringert die Sicherheit. Nur aktivieren, wenn du weißt, was du tust und dem Server vertraust.';

  @override
  String get loginValidateServerUrl => 'Bitte Server-URL eingeben';

  @override
  String get loginValidateHttps =>
      'Nur HTTPS-Verbindungen erlaubt (https://...)';

  @override
  String get loginValidateUsername => 'Bitte Benutzername eingeben';

  @override
  String get loginValidatePassword => 'Bitte Passwort eingeben';

  @override
  String get loginTabCredentials => 'Anmeldedaten';

  @override
  String get loginTabToken => 'API-Token';

  @override
  String get loginApiToken => 'API-Token';

  @override
  String get loginApiTokenHint => 'Token aus den Paperless-Einstellungen';

  @override
  String get loginValidateToken => 'Bitte API-Token eingeben';

  @override
  String get documentsSearch => 'Dokumente suchen...';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dokumente',
      one: '1 Dokument',
    );
    return '$_temp0';
  }

  @override
  String get documentsAll => 'Alle Dokumente';

  @override
  String get documentsEmpty => 'Keine Dokumente vorhanden.';

  @override
  String get documentsEmptyWithFilter =>
      'Keine Dokumente gefunden.\nFilter anpassen?';

  @override
  String get documentsResetFilter => 'Filter zurücksetzen';

  @override
  String get detailMenuDetails => 'Details';

  @override
  String get detailMenuDownload => 'Herunterladen';

  @override
  String get detailMenuDelete => 'Löschen';

  @override
  String detailDownloadSaved(String path) {
    return 'Gespeichert: $path';
  }

  @override
  String get detailDownloadFailed => 'Download fehlgeschlagen.';

  @override
  String get detailDeleteTitle => 'Dokument löschen';

  @override
  String get detailDeleteConfirm =>
      'Das Dokument wird dauerhaft gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get detailDeleteFailed => 'Löschen fehlgeschlagen.';

  @override
  String get detailEdit => 'Bearbeiten';

  @override
  String get detailLoading => 'Dokument wird geladen...';

  @override
  String get detailLoadError => 'Dokument konnte nicht geladen werden.';

  @override
  String detailLoadErrorDetail(String error) {
    return 'Dokument konnte nicht geladen werden:\n$error';
  }

  @override
  String get detailSaveDialog => 'Dokument speichern';

  @override
  String get detailScreenTitle => 'Details';

  @override
  String get detailFieldTitle => 'Titel';

  @override
  String get detailFieldCreated => 'Erstellt';

  @override
  String get detailFieldModified => 'Geändert';

  @override
  String get detailFieldAdded => 'Hinzugefügt';

  @override
  String get detailFieldCorrespondent => 'Korrespondent';

  @override
  String get detailFieldDocumentType => 'Dokumenttyp';

  @override
  String get detailFieldStoragePath => 'Speicherpfad';

  @override
  String get detailFieldArchiveNumber => 'Archivnummer';

  @override
  String get detailFieldOriginalFile => 'Originaldatei';

  @override
  String get detailSectionTags => 'Tags';

  @override
  String get detailSectionCustomFields => 'Benutzerdefinierte Felder';

  @override
  String get detailSectionContent => 'Inhalt (OCR)';

  @override
  String get editTitle => 'Bearbeiten';

  @override
  String get editSaveError => 'Fehler beim Speichern.';

  @override
  String get editFieldTitle => 'Titel';

  @override
  String get editFieldCreatedDate => 'Erstelldatum';

  @override
  String get editFieldCorrespondent => 'Korrespondent';

  @override
  String get editFieldDocumentType => 'Dokumenttyp';

  @override
  String get editFieldStoragePath => 'Speicherpfad';

  @override
  String editDropdownNone(String label) {
    return '— Kein $label —';
  }

  @override
  String get uploadTitle => 'Dokument hochladen';

  @override
  String get uploadButton => 'Hochladen';

  @override
  String get uploadFailed => 'Upload fehlgeschlagen.';

  @override
  String get uploadProcessing => 'Dokument wird verarbeitet...';

  @override
  String get uploadSectionFile => 'Datei';

  @override
  String get uploadPickFile => 'Datei wählen';

  @override
  String get uploadTakePhoto => 'Foto aufnehmen';

  @override
  String get uploadSectionMetadata => 'Metadaten';

  @override
  String uploadPhotoTitle(String date) {
    return 'Foto $date';
  }

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterReset => 'Zurücksetzen';

  @override
  String get filterApply => 'Filter anwenden';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterNone => 'Keines';

  @override
  String get filterFieldLabel => 'Feld';

  @override
  String get filterValueContains => 'Wert enthält';

  @override
  String get filterCondition => 'Bedingung';

  @override
  String get filterConditionPresent => 'Feld vorhanden';

  @override
  String get filterConditionIsNull => 'Feld ist leer';

  @override
  String get filterConditionEquals => 'Wert ist gleich';

  @override
  String get filterValueEquals => 'Wert';

  @override
  String get filterAddCustomField => 'Weiteres Feld hinzufügen';

  @override
  String get filterBoolYes => 'Ja';

  @override
  String get filterBoolNo => 'Nein';

  @override
  String get filterSectionTags => 'Tags';

  @override
  String get filterSectionCorrespondent => 'Korrespondent';

  @override
  String get filterSectionDocumentType => 'Dokumenttyp';

  @override
  String get filterSectionStoragePath => 'Speicherpfad';

  @override
  String get filterSectionCreatedDate => 'Ausstellungsdatum';

  @override
  String get filterSectionAddedDate => 'Hinzugefügt';

  @override
  String get filterDateFrom => 'Von';

  @override
  String get filterDateTo => 'Bis';

  @override
  String get filterSectionPermissions => 'Berechtigungen';

  @override
  String get filterPermissionMine => 'Meine Dokumente';

  @override
  String get filterPermissionSharedWithMe => 'Für mich freigegeben';

  @override
  String get filterPermissionSharedByMe => 'Von mir freigegeben';

  @override
  String get filterPermissionNoOwner => 'Ohne Eigentümer';

  @override
  String get filterPermissionUser => 'Bestimmter Benutzer';

  @override
  String get filterSectionCustomField => 'Benutzerdefiniertes Feld';

  @override
  String get filterSectionSorting => 'Sortierung';

  @override
  String get filterSortCreatedNewest => 'Erstellt (neueste zuerst)';

  @override
  String get filterSortCreatedOldest => 'Erstellt (älteste zuerst)';

  @override
  String get filterSortModifiedNewest => 'Geändert (neueste zuerst)';

  @override
  String get filterSortTitleAZ => 'Titel (A-Z)';

  @override
  String get filterSortTitleZA => 'Titel (Z-A)';

  @override
  String get filterSortAddedNewest => 'Hinzugefügt (neueste zuerst)';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionConnection => 'Verbindung';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsUser => 'Benutzer';

  @override
  String get settingsSectionView => 'Ansicht';

  @override
  String get settingsDefaultView => 'Standard-Ansicht beim Start';

  @override
  String get settingsNoSavedViews => 'Keine gespeicherten Ansichten vorhanden.';

  @override
  String get settingsSectionSecurity => 'Sicherheit';

  @override
  String get settingsHttpsOnly => 'Nur HTTPS-Verbindungen';

  @override
  String get settingsHttpsOnlyDesc =>
      'Standardmäßig aktiv und nicht deaktivierbar';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsLogout => 'Abmelden';

  @override
  String get settingsLogoutDesc => 'Token und gespeicherte Daten löschen';

  @override
  String get settingsLogoutDialogTitle => 'Abmelden';

  @override
  String get settingsLogoutDialogContent =>
      'Gespeicherter Token und Verbindungsdaten werden gelöscht. Fortfahren?';

  @override
  String get settingsSectionLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Systemsprache';

  @override
  String get settingsLanguageLabel => 'Sprache';

  @override
  String get settingsSectionDisplay => 'Darstellung';

  @override
  String get settingsTagsAsDropdown => 'Tags als Dropdown';

  @override
  String get settingsTagsAsDropdownDesc =>
      'Tags als Multi-Select-Liste anstelle von Chips anzeigen';

  @override
  String get settingsSavedViewsAsDropdown => 'Ansichten als Dropdown';

  @override
  String get settingsSavedViewsAsDropdownDesc =>
      'Gespeicherte Ansichten als Dropdown statt Chips anzeigen';

  @override
  String get tagPickerTitle => 'Tags auswählen';

  @override
  String get tagPickerNone => 'Keine Tags ausgewählt';

  @override
  String tagPickerCount(int count) {
    return '$count Tags ausgewählt';
  }

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsConfirmAll => 'Alle bestätigen';

  @override
  String get notificationsEmpty => 'Keine Benachrichtigungen vorhanden.';

  @override
  String get notificationsUnknownFile => 'Unbekannte Datei';

  @override
  String get notificationsDismiss => 'Verwerfen';

  @override
  String get statusSuccess => 'Erfolgreich';

  @override
  String get statusFailure => 'Fehler';

  @override
  String get statusRunning => 'Läuft';

  @override
  String get statusPending => 'Wartend';

  @override
  String get statusRevoked => 'Abgebrochen';

  @override
  String get apiErrorHttpsOnly => 'Nur HTTPS-Verbindungen erlaubt.';

  @override
  String get apiErrorNoToken => 'Kein Token in Serverantwort';

  @override
  String get apiErrorTimeout => 'Verbindungs-Timeout. Bitte Server-URL prüfen.';

  @override
  String get apiErrorSsl =>
      'SSL-Zertifikatsfehler. Selbst-signierte Zertifikate in den Einstellungen erlauben.';

  @override
  String get apiErrorConnection =>
      'Verbindungsfehler. Bitte Server-URL und Netzwerk prüfen.';

  @override
  String get apiErrorUnauthorized => 'Ungültige Anmeldedaten.';

  @override
  String get apiErrorForbidden => 'Zugriff verweigert.';

  @override
  String get apiErrorNotFound => 'Ressource nicht gefunden.';

  @override
  String apiErrorServer(String code) {
    return 'Serverfehler (HTTP $code)';
  }
}
