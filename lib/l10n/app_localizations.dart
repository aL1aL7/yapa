import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
    Locale('pt'),
  ];

  /// No description provided for @appTagline.
  ///
  /// In de, this message translates to:
  /// **'Yet Another Paperless App'**
  String get appTagline;

  /// No description provided for @appDescription.
  ///
  /// In de, this message translates to:
  /// **'Yet Another Paperless-ngx App'**
  String get appDescription;

  /// No description provided for @navDocuments.
  ///
  /// In de, this message translates to:
  /// **'Dokumente'**
  String get navDocuments;

  /// No description provided for @navNotifications.
  ///
  /// In de, this message translates to:
  /// **'Dateiaufgaben'**
  String get navNotifications;

  /// No description provided for @navSettings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get navSettings;

  /// No description provided for @actionCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In de, this message translates to:
  /// **'Verstanden'**
  String get actionConfirm;

  /// No description provided for @actionRetry.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get actionRetry;

  /// No description provided for @actionRefresh.
  ///
  /// In de, this message translates to:
  /// **'Aktualisieren'**
  String get actionRefresh;

  /// No description provided for @actionLogout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get actionLogout;

  /// No description provided for @actionClearAll.
  ///
  /// In de, this message translates to:
  /// **'Alle löschen'**
  String get actionClearAll;

  /// No description provided for @actionDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get actionDelete;

  /// No description provided for @actionSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get actionSave;

  /// No description provided for @loginServerUrl.
  ///
  /// In de, this message translates to:
  /// **'Server-URL'**
  String get loginServerUrl;

  /// No description provided for @loginServerUrlHint.
  ///
  /// In de, this message translates to:
  /// **'https://paperless.example.com'**
  String get loginServerUrlHint;

  /// No description provided for @loginUsername.
  ///
  /// In de, this message translates to:
  /// **'Benutzername'**
  String get loginUsername;

  /// No description provided for @loginPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get loginButton;

  /// No description provided for @loginAllowSelfSigned.
  ///
  /// In de, this message translates to:
  /// **'Selbst-signierte Zertifikate erlauben'**
  String get loginAllowSelfSigned;

  /// No description provided for @loginSecurityWarningTitle.
  ///
  /// In de, this message translates to:
  /// **'Sicherheitswarnung'**
  String get loginSecurityWarningTitle;

  /// No description provided for @loginSecurityWarningText.
  ///
  /// In de, this message translates to:
  /// **'Das Erlauben selbst-signierter Zertifikate verringert die Sicherheit. Nur aktivieren, wenn du weißt, was du tust und dem Server vertraust.'**
  String get loginSecurityWarningText;

  /// No description provided for @loginValidateServerUrl.
  ///
  /// In de, this message translates to:
  /// **'Bitte Server-URL eingeben'**
  String get loginValidateServerUrl;

  /// No description provided for @loginValidateHttps.
  ///
  /// In de, this message translates to:
  /// **'Nur HTTPS-Verbindungen erlaubt (https://...)'**
  String get loginValidateHttps;

  /// No description provided for @loginValidateUsername.
  ///
  /// In de, this message translates to:
  /// **'Bitte Benutzername eingeben'**
  String get loginValidateUsername;

  /// No description provided for @loginValidatePassword.
  ///
  /// In de, this message translates to:
  /// **'Bitte Passwort eingeben'**
  String get loginValidatePassword;

  /// No description provided for @loginTabCredentials.
  ///
  /// In de, this message translates to:
  /// **'Anmeldedaten'**
  String get loginTabCredentials;

  /// No description provided for @loginTabToken.
  ///
  /// In de, this message translates to:
  /// **'API-Token'**
  String get loginTabToken;

  /// No description provided for @loginApiToken.
  ///
  /// In de, this message translates to:
  /// **'API-Token'**
  String get loginApiToken;

  /// No description provided for @loginApiTokenHint.
  ///
  /// In de, this message translates to:
  /// **'Token aus den Paperless-Einstellungen'**
  String get loginApiTokenHint;

  /// No description provided for @loginValidateToken.
  ///
  /// In de, this message translates to:
  /// **'Bitte API-Token eingeben'**
  String get loginValidateToken;

  /// No description provided for @documentsSearch.
  ///
  /// In de, this message translates to:
  /// **'Dokumente suchen...'**
  String get documentsSearch;

  /// No description provided for @documentsCount.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Dokument} other{{count} Dokumente}}'**
  String documentsCount(int count);

  /// No description provided for @documentsAll.
  ///
  /// In de, this message translates to:
  /// **'Alle Dokumente'**
  String get documentsAll;

  /// No description provided for @documentsEmpty.
  ///
  /// In de, this message translates to:
  /// **'Keine Dokumente vorhanden.'**
  String get documentsEmpty;

  /// No description provided for @documentsEmptyWithFilter.
  ///
  /// In de, this message translates to:
  /// **'Keine Dokumente gefunden.\nFilter anpassen?'**
  String get documentsEmptyWithFilter;

  /// No description provided for @documentsResetFilter.
  ///
  /// In de, this message translates to:
  /// **'Filter zurücksetzen'**
  String get documentsResetFilter;

  /// No description provided for @detailMenuDetails.
  ///
  /// In de, this message translates to:
  /// **'Details'**
  String get detailMenuDetails;

  /// No description provided for @detailMenuDownload.
  ///
  /// In de, this message translates to:
  /// **'Herunterladen'**
  String get detailMenuDownload;

  /// No description provided for @detailMenuDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get detailMenuDelete;

  /// No description provided for @detailDownloadSaved.
  ///
  /// In de, this message translates to:
  /// **'Gespeichert: {path}'**
  String detailDownloadSaved(String path);

  /// No description provided for @detailDownloadFailed.
  ///
  /// In de, this message translates to:
  /// **'Download fehlgeschlagen.'**
  String get detailDownloadFailed;

  /// No description provided for @detailDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Dokument löschen'**
  String get detailDeleteTitle;

  /// No description provided for @detailDeleteConfirm.
  ///
  /// In de, this message translates to:
  /// **'Das Dokument wird dauerhaft gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.'**
  String get detailDeleteConfirm;

  /// No description provided for @detailDeleteFailed.
  ///
  /// In de, this message translates to:
  /// **'Löschen fehlgeschlagen.'**
  String get detailDeleteFailed;

  /// No description provided for @detailEdit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get detailEdit;

  /// No description provided for @detailLoading.
  ///
  /// In de, this message translates to:
  /// **'Dokument wird geladen...'**
  String get detailLoading;

  /// No description provided for @detailLoadError.
  ///
  /// In de, this message translates to:
  /// **'Dokument konnte nicht geladen werden.'**
  String get detailLoadError;

  /// No description provided for @detailLoadErrorDetail.
  ///
  /// In de, this message translates to:
  /// **'Dokument konnte nicht geladen werden:\n{error}'**
  String detailLoadErrorDetail(String error);

  /// No description provided for @detailSaveDialog.
  ///
  /// In de, this message translates to:
  /// **'Dokument speichern'**
  String get detailSaveDialog;

  /// No description provided for @detailScreenTitle.
  ///
  /// In de, this message translates to:
  /// **'Details'**
  String get detailScreenTitle;

  /// No description provided for @detailFieldTitle.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get detailFieldTitle;

  /// No description provided for @detailFieldCreated.
  ///
  /// In de, this message translates to:
  /// **'Erstellt'**
  String get detailFieldCreated;

  /// No description provided for @detailFieldModified.
  ///
  /// In de, this message translates to:
  /// **'Geändert'**
  String get detailFieldModified;

  /// No description provided for @detailFieldAdded.
  ///
  /// In de, this message translates to:
  /// **'Hinzugefügt'**
  String get detailFieldAdded;

  /// No description provided for @detailFieldCorrespondent.
  ///
  /// In de, this message translates to:
  /// **'Korrespondent'**
  String get detailFieldCorrespondent;

  /// No description provided for @detailFieldDocumentType.
  ///
  /// In de, this message translates to:
  /// **'Dokumenttyp'**
  String get detailFieldDocumentType;

  /// No description provided for @detailFieldStoragePath.
  ///
  /// In de, this message translates to:
  /// **'Speicherpfad'**
  String get detailFieldStoragePath;

  /// No description provided for @detailFieldArchiveNumber.
  ///
  /// In de, this message translates to:
  /// **'Archivnummer'**
  String get detailFieldArchiveNumber;

  /// No description provided for @detailFieldOriginalFile.
  ///
  /// In de, this message translates to:
  /// **'Originaldatei'**
  String get detailFieldOriginalFile;

  /// No description provided for @detailSectionTags.
  ///
  /// In de, this message translates to:
  /// **'Tags'**
  String get detailSectionTags;

  /// No description provided for @detailSectionCustomFields.
  ///
  /// In de, this message translates to:
  /// **'Benutzerdefinierte Felder'**
  String get detailSectionCustomFields;

  /// No description provided for @detailSectionContent.
  ///
  /// In de, this message translates to:
  /// **'Inhalt (OCR)'**
  String get detailSectionContent;

  /// No description provided for @editTitle.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get editTitle;

  /// No description provided for @editSaveError.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Speichern.'**
  String get editSaveError;

  /// No description provided for @editFieldTitle.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get editFieldTitle;

  /// No description provided for @editFieldCreatedDate.
  ///
  /// In de, this message translates to:
  /// **'Erstelldatum'**
  String get editFieldCreatedDate;

  /// No description provided for @editFieldCorrespondent.
  ///
  /// In de, this message translates to:
  /// **'Korrespondent'**
  String get editFieldCorrespondent;

  /// No description provided for @editFieldDocumentType.
  ///
  /// In de, this message translates to:
  /// **'Dokumenttyp'**
  String get editFieldDocumentType;

  /// No description provided for @editFieldStoragePath.
  ///
  /// In de, this message translates to:
  /// **'Speicherpfad'**
  String get editFieldStoragePath;

  /// No description provided for @editDropdownNone.
  ///
  /// In de, this message translates to:
  /// **'— Kein {label} —'**
  String editDropdownNone(String label);

  /// No description provided for @uploadTitle.
  ///
  /// In de, this message translates to:
  /// **'Dokument hochladen'**
  String get uploadTitle;

  /// No description provided for @uploadButton.
  ///
  /// In de, this message translates to:
  /// **'Hochladen'**
  String get uploadButton;

  /// No description provided for @uploadFailed.
  ///
  /// In de, this message translates to:
  /// **'Upload fehlgeschlagen.'**
  String get uploadFailed;

  /// No description provided for @uploadProcessing.
  ///
  /// In de, this message translates to:
  /// **'Dokument wird verarbeitet...'**
  String get uploadProcessing;

  /// No description provided for @uploadSectionFile.
  ///
  /// In de, this message translates to:
  /// **'Datei'**
  String get uploadSectionFile;

  /// No description provided for @uploadPickFile.
  ///
  /// In de, this message translates to:
  /// **'Datei wählen'**
  String get uploadPickFile;

  /// No description provided for @uploadTakePhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto aufnehmen'**
  String get uploadTakePhoto;

  /// No description provided for @uploadSectionMetadata.
  ///
  /// In de, this message translates to:
  /// **'Metadaten'**
  String get uploadSectionMetadata;

  /// No description provided for @uploadPhotoTitle.
  ///
  /// In de, this message translates to:
  /// **'Foto {date}'**
  String uploadPhotoTitle(String date);

  /// No description provided for @filterTitle.
  ///
  /// In de, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @filterReset.
  ///
  /// In de, this message translates to:
  /// **'Zurücksetzen'**
  String get filterReset;

  /// No description provided for @filterApply.
  ///
  /// In de, this message translates to:
  /// **'Filter anwenden'**
  String get filterApply;

  /// No description provided for @filterAll.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get filterAll;

  /// No description provided for @filterNone.
  ///
  /// In de, this message translates to:
  /// **'Keines'**
  String get filterNone;

  /// No description provided for @filterFieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Feld'**
  String get filterFieldLabel;

  /// No description provided for @filterValueContains.
  ///
  /// In de, this message translates to:
  /// **'Wert enthält'**
  String get filterValueContains;

  /// No description provided for @filterCondition.
  ///
  /// In de, this message translates to:
  /// **'Bedingung'**
  String get filterCondition;

  /// No description provided for @filterConditionPresent.
  ///
  /// In de, this message translates to:
  /// **'Feld vorhanden'**
  String get filterConditionPresent;

  /// No description provided for @filterConditionIsNull.
  ///
  /// In de, this message translates to:
  /// **'Feld ist leer'**
  String get filterConditionIsNull;

  /// No description provided for @filterConditionEquals.
  ///
  /// In de, this message translates to:
  /// **'Wert ist gleich'**
  String get filterConditionEquals;

  /// No description provided for @filterValueEquals.
  ///
  /// In de, this message translates to:
  /// **'Wert'**
  String get filterValueEquals;

  /// No description provided for @filterAddCustomField.
  ///
  /// In de, this message translates to:
  /// **'Weiteres Feld hinzufügen'**
  String get filterAddCustomField;

  /// No description provided for @filterBoolYes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get filterBoolYes;

  /// No description provided for @filterBoolNo.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get filterBoolNo;

  /// No description provided for @filterSectionTags.
  ///
  /// In de, this message translates to:
  /// **'Tags'**
  String get filterSectionTags;

  /// No description provided for @filterSectionCorrespondent.
  ///
  /// In de, this message translates to:
  /// **'Korrespondent'**
  String get filterSectionCorrespondent;

  /// No description provided for @filterSectionDocumentType.
  ///
  /// In de, this message translates to:
  /// **'Dokumenttyp'**
  String get filterSectionDocumentType;

  /// No description provided for @filterSectionCustomField.
  ///
  /// In de, this message translates to:
  /// **'Benutzerdefiniertes Feld'**
  String get filterSectionCustomField;

  /// No description provided for @filterSectionSorting.
  ///
  /// In de, this message translates to:
  /// **'Sortierung'**
  String get filterSectionSorting;

  /// No description provided for @filterSortCreatedNewest.
  ///
  /// In de, this message translates to:
  /// **'Erstellt (neueste zuerst)'**
  String get filterSortCreatedNewest;

  /// No description provided for @filterSortCreatedOldest.
  ///
  /// In de, this message translates to:
  /// **'Erstellt (älteste zuerst)'**
  String get filterSortCreatedOldest;

  /// No description provided for @filterSortModifiedNewest.
  ///
  /// In de, this message translates to:
  /// **'Geändert (neueste zuerst)'**
  String get filterSortModifiedNewest;

  /// No description provided for @filterSortTitleAZ.
  ///
  /// In de, this message translates to:
  /// **'Titel (A-Z)'**
  String get filterSortTitleAZ;

  /// No description provided for @filterSortTitleZA.
  ///
  /// In de, this message translates to:
  /// **'Titel (Z-A)'**
  String get filterSortTitleZA;

  /// No description provided for @filterSortAddedNewest.
  ///
  /// In de, this message translates to:
  /// **'Hinzugefügt (neueste zuerst)'**
  String get filterSortAddedNewest;

  /// No description provided for @settingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settingsTitle;

  /// No description provided for @settingsSectionConnection.
  ///
  /// In de, this message translates to:
  /// **'Verbindung'**
  String get settingsSectionConnection;

  /// No description provided for @settingsServer.
  ///
  /// In de, this message translates to:
  /// **'Server'**
  String get settingsServer;

  /// No description provided for @settingsUser.
  ///
  /// In de, this message translates to:
  /// **'Benutzer'**
  String get settingsUser;

  /// No description provided for @settingsSectionView.
  ///
  /// In de, this message translates to:
  /// **'Ansicht'**
  String get settingsSectionView;

  /// No description provided for @settingsDefaultView.
  ///
  /// In de, this message translates to:
  /// **'Standard-Ansicht beim Start'**
  String get settingsDefaultView;

  /// No description provided for @settingsNoSavedViews.
  ///
  /// In de, this message translates to:
  /// **'Keine gespeicherten Ansichten vorhanden.'**
  String get settingsNoSavedViews;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In de, this message translates to:
  /// **'Sicherheit'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsHttpsOnly.
  ///
  /// In de, this message translates to:
  /// **'Nur HTTPS-Verbindungen'**
  String get settingsHttpsOnly;

  /// No description provided for @settingsHttpsOnlyDesc.
  ///
  /// In de, this message translates to:
  /// **'Standardmäßig aktiv und nicht deaktivierbar'**
  String get settingsHttpsOnlyDesc;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In de, this message translates to:
  /// **'Konto'**
  String get settingsSectionAccount;

  /// No description provided for @settingsLogout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutDesc.
  ///
  /// In de, this message translates to:
  /// **'Token und gespeicherte Daten löschen'**
  String get settingsLogoutDesc;

  /// No description provided for @settingsLogoutDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get settingsLogoutDialogTitle;

  /// No description provided for @settingsLogoutDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Gespeicherter Token und Verbindungsdaten werden gelöscht. Fortfahren?'**
  String get settingsLogoutDialogContent;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In de, this message translates to:
  /// **'Systemsprache'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsSectionDisplay.
  ///
  /// In de, this message translates to:
  /// **'Darstellung'**
  String get settingsSectionDisplay;

  /// No description provided for @settingsTagsAsDropdown.
  ///
  /// In de, this message translates to:
  /// **'Tags als Dropdown'**
  String get settingsTagsAsDropdown;

  /// No description provided for @settingsTagsAsDropdownDesc.
  ///
  /// In de, this message translates to:
  /// **'Tags als Multi-Select-Liste anstelle von Chips anzeigen'**
  String get settingsTagsAsDropdownDesc;

  /// No description provided for @settingsSavedViewsAsDropdown.
  ///
  /// In de, this message translates to:
  /// **'Ansichten als Dropdown'**
  String get settingsSavedViewsAsDropdown;

  /// No description provided for @settingsSavedViewsAsDropdownDesc.
  ///
  /// In de, this message translates to:
  /// **'Gespeicherte Ansichten als Dropdown statt Chips anzeigen'**
  String get settingsSavedViewsAsDropdownDesc;

  /// No description provided for @tagPickerTitle.
  ///
  /// In de, this message translates to:
  /// **'Tags auswählen'**
  String get tagPickerTitle;

  /// No description provided for @tagPickerNone.
  ///
  /// In de, this message translates to:
  /// **'Keine Tags ausgewählt'**
  String get tagPickerNone;

  /// No description provided for @tagPickerCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Tags ausgewählt'**
  String tagPickerCount(int count);

  /// No description provided for @notificationsTitle.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen'**
  String get notificationsTitle;

  /// No description provided for @notificationsConfirmAll.
  ///
  /// In de, this message translates to:
  /// **'Alle bestätigen'**
  String get notificationsConfirmAll;

  /// No description provided for @notificationsEmpty.
  ///
  /// In de, this message translates to:
  /// **'Keine Benachrichtigungen vorhanden.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsUnknownFile.
  ///
  /// In de, this message translates to:
  /// **'Unbekannte Datei'**
  String get notificationsUnknownFile;

  /// No description provided for @notificationsDismiss.
  ///
  /// In de, this message translates to:
  /// **'Verwerfen'**
  String get notificationsDismiss;

  /// No description provided for @statusSuccess.
  ///
  /// In de, this message translates to:
  /// **'Erfolgreich'**
  String get statusSuccess;

  /// No description provided for @statusFailure.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get statusFailure;

  /// No description provided for @statusRunning.
  ///
  /// In de, this message translates to:
  /// **'Läuft'**
  String get statusRunning;

  /// No description provided for @statusPending.
  ///
  /// In de, this message translates to:
  /// **'Wartend'**
  String get statusPending;

  /// No description provided for @statusRevoked.
  ///
  /// In de, this message translates to:
  /// **'Abgebrochen'**
  String get statusRevoked;

  /// No description provided for @apiErrorHttpsOnly.
  ///
  /// In de, this message translates to:
  /// **'Nur HTTPS-Verbindungen erlaubt.'**
  String get apiErrorHttpsOnly;

  /// No description provided for @apiErrorNoToken.
  ///
  /// In de, this message translates to:
  /// **'Kein Token in Serverantwort'**
  String get apiErrorNoToken;

  /// No description provided for @apiErrorTimeout.
  ///
  /// In de, this message translates to:
  /// **'Verbindungs-Timeout. Bitte Server-URL prüfen.'**
  String get apiErrorTimeout;

  /// No description provided for @apiErrorSsl.
  ///
  /// In de, this message translates to:
  /// **'SSL-Zertifikatsfehler. Selbst-signierte Zertifikate in den Einstellungen erlauben.'**
  String get apiErrorSsl;

  /// No description provided for @apiErrorConnection.
  ///
  /// In de, this message translates to:
  /// **'Verbindungsfehler. Bitte Server-URL und Netzwerk prüfen.'**
  String get apiErrorConnection;

  /// No description provided for @apiErrorUnauthorized.
  ///
  /// In de, this message translates to:
  /// **'Ungültige Anmeldedaten.'**
  String get apiErrorUnauthorized;

  /// No description provided for @apiErrorForbidden.
  ///
  /// In de, this message translates to:
  /// **'Zugriff verweigert.'**
  String get apiErrorForbidden;

  /// No description provided for @apiErrorNotFound.
  ///
  /// In de, this message translates to:
  /// **'Ressource nicht gefunden.'**
  String get apiErrorNotFound;

  /// No description provided for @apiErrorServer.
  ///
  /// In de, this message translates to:
  /// **'Serverfehler (HTTP {code})'**
  String apiErrorServer(String code);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pl',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
