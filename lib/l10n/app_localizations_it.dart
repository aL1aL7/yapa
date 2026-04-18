// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTagline => 'Yet Another Paperless App';

  @override
  String get appDescription => 'Yet Another Paperless-ngx App';

  @override
  String get navDocuments => 'Documenti';

  @override
  String get navNotifications => 'Attività file';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get actionCancel => 'Annulla';

  @override
  String get actionConfirm => 'Capito';

  @override
  String get actionRetry => 'Riprova';

  @override
  String get actionRefresh => 'Aggiorna';

  @override
  String get actionLogout => 'Disconnetti';

  @override
  String get actionClearAll => 'Cancella tutto';

  @override
  String get actionDelete => 'Elimina';

  @override
  String get actionSave => 'Salva';

  @override
  String get loginServerUrl => 'URL server';

  @override
  String get loginServerUrlHint => 'https://paperless.example.com';

  @override
  String get loginUsername => 'Nome utente';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Accedi';

  @override
  String get loginAllowSelfSigned => 'Consenti certificati autofirmati';

  @override
  String get loginSecurityWarningTitle => 'Avviso di sicurezza';

  @override
  String get loginSecurityWarningText =>
      'Consentire certificati autofirmati riduce la sicurezza. Abilitare solo se sai cosa stai facendo e ti fidi del server.';

  @override
  String get loginValidateServerUrl => 'Inserisci l\'URL del server';

  @override
  String get loginValidateHttps =>
      'Sono consentite solo connessioni HTTPS (https://...)';

  @override
  String get loginValidateUsername => 'Inserisci il nome utente';

  @override
  String get loginValidatePassword => 'Inserisci la password';

  @override
  String get loginTabCredentials => 'Credenziali';

  @override
  String get loginTabToken => 'Token API';

  @override
  String get loginApiToken => 'Token API';

  @override
  String get loginApiTokenHint => 'Token dalle impostazioni di Paperless';

  @override
  String get loginValidateToken => 'Inserisci il token API';

  @override
  String get documentsSearch => 'Cerca documenti...';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documenti',
      one: '1 documento',
    );
    return '$_temp0';
  }

  @override
  String get documentsAll => 'Tutti i documenti';

  @override
  String get documentsEmpty => 'Nessun documento disponibile.';

  @override
  String get documentsEmptyWithFilter =>
      'Nessun documento trovato.\nRegolare i filtri?';

  @override
  String get documentsResetFilter => 'Reimposta filtri';

  @override
  String get detailMenuDetails => 'Dettagli';

  @override
  String get detailMenuDownload => 'Scarica';

  @override
  String get detailMenuDelete => 'Elimina';

  @override
  String detailDownloadSaved(String path) {
    return 'Salvato: $path';
  }

  @override
  String get detailDownloadFailed => 'Download non riuscito.';

  @override
  String get detailDeleteTitle => 'Elimina documento';

  @override
  String get detailDeleteConfirm =>
      'Il documento verrà eliminato definitivamente. Questa azione non può essere annullata.';

  @override
  String get detailDeleteFailed => 'Eliminazione non riuscita.';

  @override
  String get detailEdit => 'Modifica';

  @override
  String get detailLoading => 'Caricamento documento...';

  @override
  String get detailLoadError => 'Impossibile caricare il documento.';

  @override
  String detailLoadErrorDetail(String error) {
    return 'Impossibile caricare il documento:\n$error';
  }

  @override
  String get detailSaveDialog => 'Salva documento';

  @override
  String get detailScreenTitle => 'Dettagli';

  @override
  String get detailFieldTitle => 'Titolo';

  @override
  String get detailFieldCreated => 'Creato';

  @override
  String get detailFieldModified => 'Modificato';

  @override
  String get detailFieldAdded => 'Aggiunto';

  @override
  String get detailFieldCorrespondent => 'Corrispondente';

  @override
  String get detailFieldDocumentType => 'Tipo documento';

  @override
  String get detailFieldStoragePath => 'Percorso di archiviazione';

  @override
  String get detailFieldArchiveNumber => 'Numero archivio';

  @override
  String get detailFieldOriginalFile => 'File originale';

  @override
  String get detailSectionTags => 'Tag';

  @override
  String get detailSectionCustomFields => 'Campi personalizzati';

  @override
  String get detailSectionContent => 'Contenuto (OCR)';

  @override
  String get editTitle => 'Modifica';

  @override
  String get editSaveError => 'Errore durante il salvataggio.';

  @override
  String get editFieldTitle => 'Titolo';

  @override
  String get editFieldCreatedDate => 'Data di creazione';

  @override
  String get editFieldCorrespondent => 'Corrispondente';

  @override
  String get editFieldDocumentType => 'Tipo documento';

  @override
  String get editFieldStoragePath => 'Percorso di archiviazione';

  @override
  String editDropdownNone(String label) {
    return '— Nessun $label —';
  }

  @override
  String get uploadTitle => 'Carica documento';

  @override
  String get uploadButton => 'Carica';

  @override
  String get uploadFailed => 'Caricamento non riuscito.';

  @override
  String get uploadProcessing => 'Il documento è in elaborazione...';

  @override
  String get uploadSectionFile => 'File';

  @override
  String get uploadPickFile => 'Scegli file';

  @override
  String get uploadTakePhoto => 'Scatta foto';

  @override
  String get uploadSectionMetadata => 'Metadati';

  @override
  String uploadPhotoTitle(String date) {
    return 'Foto $date';
  }

  @override
  String get filterTitle => 'Filtro';

  @override
  String get filterReset => 'Reimposta';

  @override
  String get filterApply => 'Applica filtro';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterNone => 'Nessuno';

  @override
  String get filterFieldLabel => 'Campo';

  @override
  String get filterValueContains => 'Il valore contiene';

  @override
  String get filterCondition => 'Condizione';

  @override
  String get filterConditionPresent => 'Campo presente';

  @override
  String get filterConditionIsNull => 'Campo è vuoto';

  @override
  String get filterConditionEquals => 'Il valore è uguale a';

  @override
  String get filterValueEquals => 'Valore';

  @override
  String get filterAddCustomField => 'Aggiungi un altro campo';

  @override
  String get filterBoolYes => 'Sì';

  @override
  String get filterBoolNo => 'No';

  @override
  String get filterSectionTags => 'Tag';

  @override
  String get filterSectionCorrespondent => 'Corrispondente';

  @override
  String get filterSectionDocumentType => 'Tipo documento';

  @override
  String get filterSectionCustomField => 'Campo personalizzato';

  @override
  String get filterSectionSorting => 'Ordinamento';

  @override
  String get filterSortCreatedNewest => 'Creato (più recente prima)';

  @override
  String get filterSortCreatedOldest => 'Creato (più vecchio prima)';

  @override
  String get filterSortModifiedNewest => 'Modificato (più recente prima)';

  @override
  String get filterSortTitleAZ => 'Titolo (A-Z)';

  @override
  String get filterSortTitleZA => 'Titolo (Z-A)';

  @override
  String get filterSortAddedNewest => 'Aggiunto (più recente prima)';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSectionConnection => 'Connessione';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsUser => 'Utente';

  @override
  String get settingsSectionView => 'Vista';

  @override
  String get settingsDefaultView => 'Vista predefinita all\'avvio';

  @override
  String get settingsNoSavedViews => 'Nessuna vista salvata disponibile.';

  @override
  String get settingsSectionSecurity => 'Sicurezza';

  @override
  String get settingsHttpsOnly => 'Solo connessioni HTTPS';

  @override
  String get settingsHttpsOnlyDesc =>
      'Attivo per impostazione predefinita e non disattivabile';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsLogout => 'Disconnetti';

  @override
  String get settingsLogoutDesc => 'Elimina token e dati salvati';

  @override
  String get settingsLogoutDialogTitle => 'Disconnetti';

  @override
  String get settingsLogoutDialogContent =>
      'Il token salvato e i dati di connessione verranno eliminati. Continuare?';

  @override
  String get settingsSectionLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Lingua di sistema';

  @override
  String get settingsLanguageLabel => 'Lingua';

  @override
  String get notificationsTitle => 'Notifiche';

  @override
  String get notificationsConfirmAll => 'Conferma tutto';

  @override
  String get notificationsEmpty => 'Nessuna notifica disponibile.';

  @override
  String get notificationsUnknownFile => 'File sconosciuto';

  @override
  String get notificationsDismiss => 'Ignora';

  @override
  String get statusSuccess => 'Completato';

  @override
  String get statusFailure => 'Errore';

  @override
  String get statusRunning => 'In esecuzione';

  @override
  String get statusPending => 'In attesa';

  @override
  String get statusRevoked => 'Annullato';

  @override
  String get apiErrorHttpsOnly => 'Sono consentite solo connessioni HTTPS.';

  @override
  String get apiErrorNoToken => 'Nessun token nella risposta del server';

  @override
  String get apiErrorTimeout =>
      'Timeout di connessione. Controlla l\'URL del server.';

  @override
  String get apiErrorSsl =>
      'Errore certificato SSL. Consenti certificati autofirmati nelle impostazioni.';

  @override
  String get apiErrorConnection =>
      'Errore di connessione. Controlla l\'URL del server e la rete.';

  @override
  String get apiErrorUnauthorized => 'Credenziali non valide.';

  @override
  String get apiErrorForbidden => 'Accesso negato.';

  @override
  String get apiErrorNotFound => 'Risorsa non trovata.';

  @override
  String apiErrorServer(String code) {
    return 'Errore server (HTTP $code)';
  }
}
