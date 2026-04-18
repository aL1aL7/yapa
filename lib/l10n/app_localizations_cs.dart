// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTagline => 'Yet Another Paperless App';

  @override
  String get appDescription => 'Yet Another Paperless-ngx App';

  @override
  String get navDocuments => 'Dokumenty';

  @override
  String get navNotifications => 'Úlohy souborů';

  @override
  String get navSettings => 'Nastavení';

  @override
  String get actionCancel => 'Zrušit';

  @override
  String get actionConfirm => 'Rozumím';

  @override
  String get actionRetry => 'Zkusit znovu';

  @override
  String get actionRefresh => 'Obnovit';

  @override
  String get actionLogout => 'Odhlásit se';

  @override
  String get actionClearAll => 'Vymazat vše';

  @override
  String get actionDelete => 'Smazat';

  @override
  String get actionSave => 'Uložit';

  @override
  String get loginServerUrl => 'URL serveru';

  @override
  String get loginServerUrlHint => 'https://paperless.example.com';

  @override
  String get loginUsername => 'Uživatelské jméno';

  @override
  String get loginPassword => 'Heslo';

  @override
  String get loginButton => 'Přihlásit se';

  @override
  String get loginAllowSelfSigned => 'Povolit certifikáty s vlastním podpisem';

  @override
  String get loginSecurityWarningTitle => 'Bezpečnostní upozornění';

  @override
  String get loginSecurityWarningText =>
      'Povolení certifikátů s vlastním podpisem snižuje bezpečnost. Aktivujte pouze pokud víte, co děláte, a důvěřujete serveru.';

  @override
  String get loginValidateServerUrl => 'Zadejte prosím URL serveru';

  @override
  String get loginValidateHttps =>
      'Povolena jsou pouze připojení HTTPS (https://...)';

  @override
  String get loginValidateUsername => 'Zadejte prosím uživatelské jméno';

  @override
  String get loginValidatePassword => 'Zadejte prosím heslo';

  @override
  String get loginTabCredentials => 'Přihlašovací údaje';

  @override
  String get loginTabToken => 'API token';

  @override
  String get loginApiToken => 'API token';

  @override
  String get loginApiTokenHint => 'Token z nastavení Paperless';

  @override
  String get loginValidateToken => 'Zadejte prosím API token';

  @override
  String get documentsSearch => 'Hledat dokumenty...';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dokumentů',
      many: '$count dokumentů',
      few: '$count dokumenty',
      one: '1 dokument',
    );
    return '$_temp0';
  }

  @override
  String get documentsAll => 'Všechny dokumenty';

  @override
  String get documentsEmpty => 'Žádné dokumenty k dispozici.';

  @override
  String get documentsEmptyWithFilter =>
      'Žádné dokumenty nenalezeny.\nUpravit filtry?';

  @override
  String get documentsResetFilter => 'Resetovat filtry';

  @override
  String get detailMenuDetails => 'Podrobnosti';

  @override
  String get detailMenuDownload => 'Stáhnout';

  @override
  String get detailMenuDelete => 'Smazat';

  @override
  String detailDownloadSaved(String path) {
    return 'Uloženo: $path';
  }

  @override
  String get detailDownloadFailed => 'Stahování selhalo.';

  @override
  String get detailDeleteTitle => 'Smazat dokument';

  @override
  String get detailDeleteConfirm =>
      'Dokument bude trvale smazán. Tuto akci nelze vrátit zpět.';

  @override
  String get detailDeleteFailed => 'Mazání selhalo.';

  @override
  String get detailEdit => 'Upravit';

  @override
  String get detailLoading => 'Načítání dokumentu...';

  @override
  String get detailLoadError => 'Dokument se nepodařilo načíst.';

  @override
  String detailLoadErrorDetail(String error) {
    return 'Dokument se nepodařilo načíst:\n$error';
  }

  @override
  String get detailSaveDialog => 'Uložit dokument';

  @override
  String get detailScreenTitle => 'Podrobnosti';

  @override
  String get detailFieldTitle => 'Název';

  @override
  String get detailFieldCreated => 'Vytvořeno';

  @override
  String get detailFieldModified => 'Změněno';

  @override
  String get detailFieldAdded => 'Přidáno';

  @override
  String get detailFieldCorrespondent => 'Korespondent';

  @override
  String get detailFieldDocumentType => 'Typ dokumentu';

  @override
  String get detailFieldStoragePath => 'Cesta úložiště';

  @override
  String get detailFieldArchiveNumber => 'Číslo archivu';

  @override
  String get detailFieldOriginalFile => 'Původní soubor';

  @override
  String get detailSectionTags => 'Štítky';

  @override
  String get detailSectionCustomFields => 'Vlastní pole';

  @override
  String get detailSectionContent => 'Obsah (OCR)';

  @override
  String get editTitle => 'Upravit';

  @override
  String get editSaveError => 'Chyba při ukládání.';

  @override
  String get editFieldTitle => 'Název';

  @override
  String get editFieldCreatedDate => 'Datum vytvoření';

  @override
  String get editFieldCorrespondent => 'Korespondent';

  @override
  String get editFieldDocumentType => 'Typ dokumentu';

  @override
  String get editFieldStoragePath => 'Cesta úložiště';

  @override
  String editDropdownNone(String label) {
    return '— Žádný $label —';
  }

  @override
  String get uploadTitle => 'Nahrát dokument';

  @override
  String get uploadButton => 'Nahrát';

  @override
  String get uploadFailed => 'Nahrávání selhalo.';

  @override
  String get uploadProcessing => 'Dokument se zpracovává...';

  @override
  String get uploadSectionFile => 'Soubor';

  @override
  String get uploadPickFile => 'Vybrat soubor';

  @override
  String get uploadTakePhoto => 'Vyfotit';

  @override
  String get uploadSectionMetadata => 'Metadata';

  @override
  String uploadPhotoTitle(String date) {
    return 'Foto $date';
  }

  @override
  String get filterTitle => 'Filtr';

  @override
  String get filterReset => 'Resetovat';

  @override
  String get filterApply => 'Použít filtr';

  @override
  String get filterAll => 'Vše';

  @override
  String get filterNone => 'Žádný';

  @override
  String get filterFieldLabel => 'Pole';

  @override
  String get filterValueContains => 'Hodnota obsahuje';

  @override
  String get filterCondition => 'Podmínka';

  @override
  String get filterConditionPresent => 'Pole je přítomno';

  @override
  String get filterConditionIsNull => 'Pole je prázdné';

  @override
  String get filterConditionEquals => 'Hodnota se rovná';

  @override
  String get filterValueEquals => 'Hodnota';

  @override
  String get filterAddCustomField => 'Přidat další pole';

  @override
  String get filterBoolYes => 'Ano';

  @override
  String get filterBoolNo => 'Ne';

  @override
  String get filterSectionTags => 'Štítky';

  @override
  String get filterSectionCorrespondent => 'Korespondent';

  @override
  String get filterSectionDocumentType => 'Typ dokumentu';

  @override
  String get filterSectionStoragePath => 'Cesta úložiště';

  @override
  String get filterSectionCreatedDate => 'Datum vytvoření';

  @override
  String get filterSectionAddedDate => 'Datum přidání';

  @override
  String get filterDateFrom => 'Od';

  @override
  String get filterDateTo => 'Do';

  @override
  String get filterSectionPermissions => 'Oprávnění';

  @override
  String get filterPermissionMine => 'Moje dokumenty';

  @override
  String get filterPermissionSharedWithMe => 'Sdíleno se mnou';

  @override
  String get filterPermissionSharedByMe => 'Sdíleno mnou';

  @override
  String get filterPermissionNoOwner => 'Bez vlastníka';

  @override
  String get filterPermissionUser => 'Určitý uživatel';

  @override
  String get filterSectionCustomField => 'Vlastní pole';

  @override
  String get filterSectionSorting => 'Řazení';

  @override
  String get filterSortCreatedNewest => 'Vytvořeno (nejnovější nejdříve)';

  @override
  String get filterSortCreatedOldest => 'Vytvořeno (nejstarší nejdříve)';

  @override
  String get filterSortModifiedNewest => 'Změněno (nejnovější nejdříve)';

  @override
  String get filterSortTitleAZ => 'Název (A-Z)';

  @override
  String get filterSortTitleZA => 'Název (Z-A)';

  @override
  String get filterSortAddedNewest => 'Přidáno (nejnovější nejdříve)';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get settingsSectionConnection => 'Připojení';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsUser => 'Uživatel';

  @override
  String get settingsSectionView => 'Zobrazení';

  @override
  String get settingsDefaultView => 'Výchozí zobrazení při spuštění';

  @override
  String get settingsNoSavedViews => 'Žádná uložená zobrazení k dispozici.';

  @override
  String get settingsSectionSecurity => 'Zabezpečení';

  @override
  String get settingsHttpsOnly => 'Pouze připojení HTTPS';

  @override
  String get settingsHttpsOnlyDesc =>
      'Ve výchozím nastavení aktivní a nelze deaktivovat';

  @override
  String get settingsSectionAccount => 'Účet';

  @override
  String get settingsLogout => 'Odhlásit se';

  @override
  String get settingsLogoutDesc => 'Smazat token a uložená data';

  @override
  String get settingsLogoutDialogTitle => 'Odhlásit se';

  @override
  String get settingsLogoutDialogContent =>
      'Uložený token a data připojení budou smazána. Pokračovat?';

  @override
  String get settingsSectionLanguage => 'Jazyk';

  @override
  String get settingsLanguageSystem => 'Jazyk systému';

  @override
  String get settingsLanguageLabel => 'Jazyk';

  @override
  String get settingsSectionDisplay => 'Zobrazení';

  @override
  String get settingsTagsAsDropdown => 'Štítky jako rozbalovací seznam';

  @override
  String get settingsTagsAsDropdownDesc =>
      'Zobrazit štítky jako seznam s vícenásobným výběrem místo čipů';

  @override
  String get settingsSavedViewsAsDropdown => 'Pohledy jako rozbalovací seznam';

  @override
  String get settingsSavedViewsAsDropdownDesc =>
      'Zobrazit uložené pohledy jako rozbalovací seznam místo čipů';

  @override
  String get tagPickerTitle => 'Vybrat štítky';

  @override
  String get tagPickerNone => 'Žádné štítky nevybrány';

  @override
  String tagPickerCount(int count) {
    return 'Vybráno $count štítků';
  }

  @override
  String get notificationsTitle => 'Oznámení';

  @override
  String get notificationsConfirmAll => 'Potvrdit vše';

  @override
  String get notificationsEmpty => 'Žádná oznámení k dispozici.';

  @override
  String get notificationsUnknownFile => 'Neznámý soubor';

  @override
  String get notificationsDismiss => 'Zamítnout';

  @override
  String get statusSuccess => 'Úspěch';

  @override
  String get statusFailure => 'Chyba';

  @override
  String get statusRunning => 'Probíhá';

  @override
  String get statusPending => 'Čeká';

  @override
  String get statusRevoked => 'Zrušeno';

  @override
  String get apiErrorHttpsOnly => 'Povolena jsou pouze připojení HTTPS.';

  @override
  String get apiErrorNoToken => 'Žádný token v odpovědi serveru';

  @override
  String get apiErrorTimeout =>
      'Časový limit připojení. Zkontrolujte URL serveru.';

  @override
  String get apiErrorSsl =>
      'Chyba certifikátu SSL. Povolte certifikáty s vlastním podpisem v nastavení.';

  @override
  String get apiErrorConnection =>
      'Chyba připojení. Zkontrolujte URL serveru a síť.';

  @override
  String get apiErrorUnauthorized => 'Neplatné přihlašovací údaje.';

  @override
  String get apiErrorForbidden => 'Přístup odepřen.';

  @override
  String get apiErrorNotFound => 'Zdroj nenalezen.';

  @override
  String apiErrorServer(String code) {
    return 'Chyba serveru (HTTP $code)';
  }
}
