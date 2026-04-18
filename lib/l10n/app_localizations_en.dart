// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Yet Another Paperless App';

  @override
  String get appDescription => 'Yet Another Paperless-ngx App';

  @override
  String get navDocuments => 'Documents';

  @override
  String get navNotifications => 'File Tasks';

  @override
  String get navSettings => 'Settings';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Understood';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get actionLogout => 'Log out';

  @override
  String get actionClearAll => 'Clear all';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSave => 'Save';

  @override
  String get loginServerUrl => 'Server URL';

  @override
  String get loginServerUrlHint => 'https://paperless.example.com';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginAllowSelfSigned => 'Allow self-signed certificates';

  @override
  String get loginSecurityWarningTitle => 'Security warning';

  @override
  String get loginSecurityWarningText =>
      'Allowing self-signed certificates reduces security. Only enable if you know what you are doing and trust the server.';

  @override
  String get loginValidateServerUrl => 'Please enter the server URL';

  @override
  String get loginValidateHttps =>
      'Only HTTPS connections allowed (https://...)';

  @override
  String get loginValidateUsername => 'Please enter your username';

  @override
  String get loginValidatePassword => 'Please enter your password';

  @override
  String get loginTabCredentials => 'Credentials';

  @override
  String get loginTabToken => 'API Token';

  @override
  String get loginApiToken => 'API Token';

  @override
  String get loginApiTokenHint => 'Token from your Paperless settings';

  @override
  String get loginValidateToken => 'Please enter your API token';

  @override
  String get documentsSearch => 'Search documents...';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
    );
    return '$_temp0';
  }

  @override
  String get documentsAll => 'All documents';

  @override
  String get documentsEmpty => 'No documents available.';

  @override
  String get documentsEmptyWithFilter => 'No documents found.\nAdjust filters?';

  @override
  String get documentsResetFilter => 'Reset filters';

  @override
  String get detailMenuDetails => 'Details';

  @override
  String get detailMenuDownload => 'Download';

  @override
  String get detailMenuDelete => 'Delete';

  @override
  String detailDownloadSaved(String path) {
    return 'Saved: $path';
  }

  @override
  String get detailDownloadFailed => 'Download failed.';

  @override
  String get detailDeleteTitle => 'Delete document';

  @override
  String get detailDeleteConfirm =>
      'The document will be permanently deleted. This action cannot be undone.';

  @override
  String get detailDeleteFailed => 'Delete failed.';

  @override
  String get detailEdit => 'Edit';

  @override
  String get detailLoading => 'Loading document...';

  @override
  String get detailLoadError => 'Could not load document.';

  @override
  String detailLoadErrorDetail(String error) {
    return 'Could not load document:\n$error';
  }

  @override
  String get detailSaveDialog => 'Save document';

  @override
  String get detailScreenTitle => 'Details';

  @override
  String get detailFieldTitle => 'Title';

  @override
  String get detailFieldCreated => 'Created';

  @override
  String get detailFieldModified => 'Modified';

  @override
  String get detailFieldAdded => 'Added';

  @override
  String get detailFieldCorrespondent => 'Correspondent';

  @override
  String get detailFieldDocumentType => 'Document type';

  @override
  String get detailFieldStoragePath => 'Storage path';

  @override
  String get detailFieldArchiveNumber => 'Archive number';

  @override
  String get detailFieldOriginalFile => 'Original file';

  @override
  String get detailSectionTags => 'Tags';

  @override
  String get detailSectionCustomFields => 'Custom fields';

  @override
  String get detailSectionContent => 'Content (OCR)';

  @override
  String get editTitle => 'Edit';

  @override
  String get editSaveError => 'Error saving.';

  @override
  String get editFieldTitle => 'Title';

  @override
  String get editFieldCreatedDate => 'Created date';

  @override
  String get editFieldCorrespondent => 'Correspondent';

  @override
  String get editFieldDocumentType => 'Document type';

  @override
  String get editFieldStoragePath => 'Storage path';

  @override
  String editDropdownNone(String label) {
    return '— No $label —';
  }

  @override
  String get uploadTitle => 'Upload document';

  @override
  String get uploadButton => 'Upload';

  @override
  String get uploadFailed => 'Upload failed.';

  @override
  String get uploadProcessing => 'Document is being processed...';

  @override
  String get uploadSectionFile => 'File';

  @override
  String get uploadPickFile => 'Choose file';

  @override
  String get uploadTakePhoto => 'Take photo';

  @override
  String get uploadSectionMetadata => 'Metadata';

  @override
  String uploadPhotoTitle(String date) {
    return 'Photo $date';
  }

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterReset => 'Reset';

  @override
  String get filterApply => 'Apply filter';

  @override
  String get filterAll => 'All';

  @override
  String get filterNone => 'None';

  @override
  String get filterFieldLabel => 'Field';

  @override
  String get filterValueContains => 'Value contains';

  @override
  String get filterCondition => 'Condition';

  @override
  String get filterConditionPresent => 'Field present';

  @override
  String get filterConditionIsNull => 'Field is empty';

  @override
  String get filterConditionEquals => 'Value equals';

  @override
  String get filterValueEquals => 'Value';

  @override
  String get filterAddCustomField => 'Add another field';

  @override
  String get filterBoolYes => 'Yes';

  @override
  String get filterBoolNo => 'No';

  @override
  String get filterSectionTags => 'Tags';

  @override
  String get filterSectionCorrespondent => 'Correspondent';

  @override
  String get filterSectionDocumentType => 'Document type';

  @override
  String get filterSectionStoragePath => 'Storage path';

  @override
  String get filterSectionCreatedDate => 'Created date';

  @override
  String get filterSectionAddedDate => 'Added date';

  @override
  String get filterDateFrom => 'From';

  @override
  String get filterDateTo => 'To';

  @override
  String get filterSectionPermissions => 'Permissions';

  @override
  String get filterPermissionMine => 'My documents';

  @override
  String get filterPermissionSharedWithMe => 'Shared with me';

  @override
  String get filterPermissionSharedByMe => 'Shared by me';

  @override
  String get filterPermissionNoOwner => 'No owner';

  @override
  String get filterPermissionUser => 'Specific user';

  @override
  String get filterSectionCustomField => 'Custom field';

  @override
  String get filterSectionSorting => 'Sorting';

  @override
  String get filterSortCreatedNewest => 'Created (newest first)';

  @override
  String get filterSortCreatedOldest => 'Created (oldest first)';

  @override
  String get filterSortModifiedNewest => 'Modified (newest first)';

  @override
  String get filterSortTitleAZ => 'Title (A-Z)';

  @override
  String get filterSortTitleZA => 'Title (Z-A)';

  @override
  String get filterSortAddedNewest => 'Added (newest first)';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionConnection => 'Connection';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsUser => 'User';

  @override
  String get settingsSectionView => 'View';

  @override
  String get settingsDefaultView => 'Default view on start';

  @override
  String get settingsNoSavedViews => 'No saved views available.';

  @override
  String get settingsSectionSecurity => 'Security';

  @override
  String get settingsHttpsOnly => 'HTTPS connections only';

  @override
  String get settingsHttpsOnlyDesc =>
      'Active by default and cannot be disabled';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsLogout => 'Log out';

  @override
  String get settingsLogoutDesc => 'Delete token and saved data';

  @override
  String get settingsLogoutDialogTitle => 'Log out';

  @override
  String get settingsLogoutDialogContent =>
      'Saved token and connection data will be deleted. Continue?';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System language';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsSectionDisplay => 'Display';

  @override
  String get settingsTagsAsDropdown => 'Tags as Dropdown';

  @override
  String get settingsTagsAsDropdownDesc =>
      'Show tags as a multi-select list instead of chips';

  @override
  String get settingsSavedViewsAsDropdown => 'Views as Dropdown';

  @override
  String get settingsSavedViewsAsDropdownDesc =>
      'Show saved views as a dropdown instead of chips';

  @override
  String get tagPickerTitle => 'Select tags';

  @override
  String get tagPickerNone => 'No tags selected';

  @override
  String tagPickerCount(int count) {
    return '$count tags selected';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsConfirmAll => 'Confirm all';

  @override
  String get notificationsEmpty => 'No notifications available.';

  @override
  String get notificationsUnknownFile => 'Unknown file';

  @override
  String get notificationsDismiss => 'Dismiss';

  @override
  String get statusSuccess => 'Success';

  @override
  String get statusFailure => 'Error';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusRevoked => 'Cancelled';

  @override
  String get apiErrorHttpsOnly => 'Only HTTPS connections allowed.';

  @override
  String get apiErrorNoToken => 'No token in server response';

  @override
  String get apiErrorTimeout => 'Connection timeout. Please check server URL.';

  @override
  String get apiErrorSsl =>
      'SSL certificate error. Allow self-signed certificates in settings.';

  @override
  String get apiErrorConnection =>
      'Connection error. Please check server URL and network.';

  @override
  String get apiErrorUnauthorized => 'Invalid credentials.';

  @override
  String get apiErrorForbidden => 'Access denied.';

  @override
  String get apiErrorNotFound => 'Resource not found.';

  @override
  String apiErrorServer(String code) {
    return 'Server error (HTTP $code)';
  }
}
