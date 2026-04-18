// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTagline => 'Yet Another Paperless App';

  @override
  String get appDescription => 'Yet Another Paperless-ngx App';

  @override
  String get navDocuments => 'Dokumenty';

  @override
  String get navNotifications => 'Zadania plików';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String get actionCancel => 'Anuluj';

  @override
  String get actionConfirm => 'Rozumiem';

  @override
  String get actionRetry => 'Spróbuj ponownie';

  @override
  String get actionRefresh => 'Odśwież';

  @override
  String get actionLogout => 'Wyloguj';

  @override
  String get actionClearAll => 'Wyczyść wszystko';

  @override
  String get actionDelete => 'Usuń';

  @override
  String get actionSave => 'Zapisz';

  @override
  String get loginServerUrl => 'URL serwera';

  @override
  String get loginServerUrlHint => 'https://paperless.example.com';

  @override
  String get loginUsername => 'Nazwa użytkownika';

  @override
  String get loginPassword => 'Hasło';

  @override
  String get loginButton => 'Zaloguj się';

  @override
  String get loginAllowSelfSigned =>
      'Zezwalaj na certyfikaty z podpisem własnym';

  @override
  String get loginSecurityWarningTitle => 'Ostrzeżenie bezpieczeństwa';

  @override
  String get loginSecurityWarningText =>
      'Zezwolenie na certyfikaty z podpisem własnym obniża bezpieczeństwo. Włącz tylko jeśli wiesz co robisz i ufasz serwerowi.';

  @override
  String get loginValidateServerUrl => 'Proszę podać URL serwera';

  @override
  String get loginValidateHttps =>
      'Dozwolone są tylko połączenia HTTPS (https://...)';

  @override
  String get loginValidateUsername => 'Proszę podać nazwę użytkownika';

  @override
  String get loginValidatePassword => 'Proszę podać hasło';

  @override
  String get loginTabCredentials => 'Dane logowania';

  @override
  String get loginTabToken => 'Token API';

  @override
  String get loginApiToken => 'Token API';

  @override
  String get loginApiTokenHint => 'Token z ustawień Paperless';

  @override
  String get loginValidateToken => 'Proszę podać token API';

  @override
  String get documentsSearch => 'Szukaj dokumentów...';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dokumentu',
      many: '$count dokumentów',
      few: '$count dokumenty',
      one: '1 dokument',
    );
    return '$_temp0';
  }

  @override
  String get documentsAll => 'Wszystkie dokumenty';

  @override
  String get documentsEmpty => 'Brak dostępnych dokumentów.';

  @override
  String get documentsEmptyWithFilter =>
      'Nie znaleziono dokumentów.\nDostosować filtry?';

  @override
  String get documentsResetFilter => 'Resetuj filtry';

  @override
  String get detailMenuDetails => 'Szczegóły';

  @override
  String get detailMenuDownload => 'Pobierz';

  @override
  String get detailMenuDelete => 'Usuń';

  @override
  String detailDownloadSaved(String path) {
    return 'Zapisano: $path';
  }

  @override
  String get detailDownloadFailed => 'Pobieranie nie powiodło się.';

  @override
  String get detailDeleteTitle => 'Usuń dokument';

  @override
  String get detailDeleteConfirm =>
      'Dokument zostanie trwale usunięty. Tej operacji nie można cofnąć.';

  @override
  String get detailDeleteFailed => 'Usuwanie nie powiodło się.';

  @override
  String get detailEdit => 'Edytuj';

  @override
  String get detailLoading => 'Ładowanie dokumentu...';

  @override
  String get detailLoadError => 'Nie można załadować dokumentu.';

  @override
  String detailLoadErrorDetail(String error) {
    return 'Nie można załadować dokumentu:\n$error';
  }

  @override
  String get detailSaveDialog => 'Zapisz dokument';

  @override
  String get detailScreenTitle => 'Szczegóły';

  @override
  String get detailFieldTitle => 'Tytuł';

  @override
  String get detailFieldCreated => 'Utworzono';

  @override
  String get detailFieldModified => 'Zmodyfikowano';

  @override
  String get detailFieldAdded => 'Dodano';

  @override
  String get detailFieldCorrespondent => 'Korespondent';

  @override
  String get detailFieldDocumentType => 'Typ dokumentu';

  @override
  String get detailFieldStoragePath => 'Ścieżka przechowywania';

  @override
  String get detailFieldArchiveNumber => 'Numer archiwum';

  @override
  String get detailFieldOriginalFile => 'Oryginalny plik';

  @override
  String get detailSectionTags => 'Tagi';

  @override
  String get detailSectionCustomFields => 'Pola niestandardowe';

  @override
  String get detailSectionContent => 'Zawartość (OCR)';

  @override
  String get editTitle => 'Edytuj';

  @override
  String get editSaveError => 'Błąd podczas zapisywania.';

  @override
  String get editFieldTitle => 'Tytuł';

  @override
  String get editFieldCreatedDate => 'Data utworzenia';

  @override
  String get editFieldCorrespondent => 'Korespondent';

  @override
  String get editFieldDocumentType => 'Typ dokumentu';

  @override
  String get editFieldStoragePath => 'Ścieżka przechowywania';

  @override
  String editDropdownNone(String label) {
    return '— Brak: $label —';
  }

  @override
  String get uploadTitle => 'Prześlij dokument';

  @override
  String get uploadButton => 'Prześlij';

  @override
  String get uploadFailed => 'Przesyłanie nie powiodło się.';

  @override
  String get uploadProcessing => 'Dokument jest przetwarzany...';

  @override
  String get uploadSectionFile => 'Plik';

  @override
  String get uploadPickFile => 'Wybierz plik';

  @override
  String get uploadTakePhoto => 'Zrób zdjęcie';

  @override
  String get uploadSectionMetadata => 'Metadane';

  @override
  String uploadPhotoTitle(String date) {
    return 'Zdjęcie $date';
  }

  @override
  String get filterTitle => 'Filtr';

  @override
  String get filterReset => 'Resetuj';

  @override
  String get filterApply => 'Zastosuj filtr';

  @override
  String get filterAll => 'Wszystkie';

  @override
  String get filterNone => 'Żaden';

  @override
  String get filterFieldLabel => 'Pole';

  @override
  String get filterValueContains => 'Wartość zawiera';

  @override
  String get filterCondition => 'Warunek';

  @override
  String get filterConditionPresent => 'Pole obecne';

  @override
  String get filterConditionIsNull => 'Pole jest puste';

  @override
  String get filterConditionEquals => 'Wartość jest równa';

  @override
  String get filterValueEquals => 'Wartość';

  @override
  String get filterAddCustomField => 'Dodaj kolejne pole';

  @override
  String get filterBoolYes => 'Tak';

  @override
  String get filterBoolNo => 'Nie';

  @override
  String get filterSectionTags => 'Tagi';

  @override
  String get filterSectionCorrespondent => 'Korespondent';

  @override
  String get filterSectionDocumentType => 'Typ dokumentu';

  @override
  String get filterSectionCustomField => 'Pole niestandardowe';

  @override
  String get filterSectionSorting => 'Sortowanie';

  @override
  String get filterSortCreatedNewest => 'Utworzono (najnowsze pierwsze)';

  @override
  String get filterSortCreatedOldest => 'Utworzono (najstarsze pierwsze)';

  @override
  String get filterSortModifiedNewest => 'Zmodyfikowano (najnowsze pierwsze)';

  @override
  String get filterSortTitleAZ => 'Tytuł (A-Z)';

  @override
  String get filterSortTitleZA => 'Tytuł (Z-A)';

  @override
  String get filterSortAddedNewest => 'Dodano (najnowsze pierwsze)';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsSectionConnection => 'Połączenie';

  @override
  String get settingsServer => 'Serwer';

  @override
  String get settingsUser => 'Użytkownik';

  @override
  String get settingsSectionView => 'Widok';

  @override
  String get settingsDefaultView => 'Domyślny widok przy uruchomieniu';

  @override
  String get settingsNoSavedViews => 'Brak zapisanych widoków.';

  @override
  String get settingsSectionSecurity => 'Bezpieczeństwo';

  @override
  String get settingsHttpsOnly => 'Tylko połączenia HTTPS';

  @override
  String get settingsHttpsOnlyDesc => 'Domyślnie aktywne i nie można wyłączyć';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsLogout => 'Wyloguj';

  @override
  String get settingsLogoutDesc => 'Usuń token i zapisane dane';

  @override
  String get settingsLogoutDialogTitle => 'Wyloguj';

  @override
  String get settingsLogoutDialogContent =>
      'Zapisany token i dane połączenia zostaną usunięte. Kontynuować?';

  @override
  String get settingsSectionLanguage => 'Język';

  @override
  String get settingsLanguageSystem => 'Język systemu';

  @override
  String get settingsLanguageLabel => 'Język';

  @override
  String get settingsSectionDisplay => 'Wygląd';

  @override
  String get settingsTagsAsDropdown => 'Tagi jako lista rozwijana';

  @override
  String get settingsTagsAsDropdownDesc =>
      'Wyświetlaj tagi jako listę wielokrotnego wyboru zamiast chipów';

  @override
  String get settingsSavedViewsAsDropdown => 'Widoki jako lista rozwijana';

  @override
  String get settingsSavedViewsAsDropdownDesc =>
      'Wyświetlaj zapisane widoki jako listę rozwijaną zamiast chipów';

  @override
  String get tagPickerTitle => 'Wybierz tagi';

  @override
  String get tagPickerNone => 'Nie wybrano tagów';

  @override
  String tagPickerCount(int count) {
    return 'Wybrano $count tagów';
  }

  @override
  String get notificationsTitle => 'Powiadomienia';

  @override
  String get notificationsConfirmAll => 'Potwierdź wszystkie';

  @override
  String get notificationsEmpty => 'Brak dostępnych powiadomień.';

  @override
  String get notificationsUnknownFile => 'Nieznany plik';

  @override
  String get notificationsDismiss => 'Odrzuć';

  @override
  String get statusSuccess => 'Sukces';

  @override
  String get statusFailure => 'Błąd';

  @override
  String get statusRunning => 'W toku';

  @override
  String get statusPending => 'Oczekuje';

  @override
  String get statusRevoked => 'Anulowano';

  @override
  String get apiErrorHttpsOnly => 'Dozwolone są tylko połączenia HTTPS.';

  @override
  String get apiErrorNoToken => 'Brak tokenu w odpowiedzi serwera';

  @override
  String get apiErrorTimeout =>
      'Przekroczono limit czasu połączenia. Sprawdź URL serwera.';

  @override
  String get apiErrorSsl =>
      'Błąd certyfikatu SSL. Zezwól na certyfikaty z podpisem własnym w ustawieniach.';

  @override
  String get apiErrorConnection =>
      'Błąd połączenia. Sprawdź URL serwera i sieć.';

  @override
  String get apiErrorUnauthorized => 'Nieprawidłowe dane logowania.';

  @override
  String get apiErrorForbidden => 'Odmowa dostępu.';

  @override
  String get apiErrorNotFound => 'Zasób nie znaleziony.';

  @override
  String apiErrorServer(String code) {
    return 'Błąd serwera (HTTP $code)';
  }
}
