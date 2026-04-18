// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTagline => 'Yet Another Paperless App';

  @override
  String get appDescription => 'Yet Another Paperless-ngx App';

  @override
  String get navDocuments => 'Documents';

  @override
  String get navNotifications => 'Tâches de fichiers';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionConfirm => 'Compris';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get actionRefresh => 'Actualiser';

  @override
  String get actionLogout => 'Se déconnecter';

  @override
  String get actionClearAll => 'Tout effacer';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get loginServerUrl => 'URL du serveur';

  @override
  String get loginServerUrlHint => 'https://paperless.example.com';

  @override
  String get loginUsername => 'Nom d\'utilisateur';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginAllowSelfSigned => 'Autoriser les certificats auto-signés';

  @override
  String get loginSecurityWarningTitle => 'Avertissement de sécurité';

  @override
  String get loginSecurityWarningText =>
      'Autoriser les certificats auto-signés réduit la sécurité. N\'activez cette option que si vous savez ce que vous faites et faites confiance au serveur.';

  @override
  String get loginValidateServerUrl => 'Veuillez saisir l\'URL du serveur';

  @override
  String get loginValidateHttps =>
      'Seules les connexions HTTPS sont autorisées (https://...)';

  @override
  String get loginValidateUsername =>
      'Veuillez saisir votre nom d\'utilisateur';

  @override
  String get loginValidatePassword => 'Veuillez saisir votre mot de passe';

  @override
  String get loginTabCredentials => 'Identifiants';

  @override
  String get loginTabToken => 'Jeton API';

  @override
  String get loginApiToken => 'Jeton API';

  @override
  String get loginApiTokenHint => 'Jeton depuis les paramètres Paperless';

  @override
  String get loginValidateToken => 'Veuillez saisir le jeton API';

  @override
  String get documentsSearch => 'Rechercher des documents...';

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
  String get documentsAll => 'Tous les documents';

  @override
  String get documentsEmpty => 'Aucun document disponible.';

  @override
  String get documentsEmptyWithFilter =>
      'Aucun document trouvé.\nAjuster les filtres ?';

  @override
  String get documentsResetFilter => 'Réinitialiser les filtres';

  @override
  String get detailMenuDetails => 'Détails';

  @override
  String get detailMenuDownload => 'Télécharger';

  @override
  String get detailMenuDelete => 'Supprimer';

  @override
  String detailDownloadSaved(String path) {
    return 'Enregistré : $path';
  }

  @override
  String get detailDownloadFailed => 'Échec du téléchargement.';

  @override
  String get detailDeleteTitle => 'Supprimer le document';

  @override
  String get detailDeleteConfirm =>
      'Le document sera supprimé définitivement. Cette action est irréversible.';

  @override
  String get detailDeleteFailed => 'Échec de la suppression.';

  @override
  String get detailEdit => 'Modifier';

  @override
  String get detailLoading => 'Chargement du document...';

  @override
  String get detailLoadError => 'Impossible de charger le document.';

  @override
  String detailLoadErrorDetail(String error) {
    return 'Impossible de charger le document :\n$error';
  }

  @override
  String get detailSaveDialog => 'Enregistrer le document';

  @override
  String get detailScreenTitle => 'Détails';

  @override
  String get detailFieldTitle => 'Titre';

  @override
  String get detailFieldCreated => 'Créé';

  @override
  String get detailFieldModified => 'Modifié';

  @override
  String get detailFieldAdded => 'Ajouté';

  @override
  String get detailFieldCorrespondent => 'Correspondant';

  @override
  String get detailFieldDocumentType => 'Type de document';

  @override
  String get detailFieldStoragePath => 'Chemin de stockage';

  @override
  String get detailFieldArchiveNumber => 'Numéro d\'archive';

  @override
  String get detailFieldOriginalFile => 'Fichier original';

  @override
  String get detailSectionTags => 'Étiquettes';

  @override
  String get detailSectionCustomFields => 'Champs personnalisés';

  @override
  String get detailSectionContent => 'Contenu (OCR)';

  @override
  String get editTitle => 'Modifier';

  @override
  String get editSaveError => 'Erreur lors de l\'enregistrement.';

  @override
  String get editFieldTitle => 'Titre';

  @override
  String get editFieldCreatedDate => 'Date de création';

  @override
  String get editFieldCorrespondent => 'Correspondant';

  @override
  String get editFieldDocumentType => 'Type de document';

  @override
  String get editFieldStoragePath => 'Chemin de stockage';

  @override
  String editDropdownNone(String label) {
    return '— Aucun(e) $label —';
  }

  @override
  String get uploadTitle => 'Téléverser un document';

  @override
  String get uploadButton => 'Téléverser';

  @override
  String get uploadFailed => 'Échec du téléversement.';

  @override
  String get uploadProcessing => 'Le document est en cours de traitement...';

  @override
  String get uploadSectionFile => 'Fichier';

  @override
  String get uploadPickFile => 'Choisir un fichier';

  @override
  String get uploadTakePhoto => 'Prendre une photo';

  @override
  String get uploadSectionMetadata => 'Métadonnées';

  @override
  String uploadPhotoTitle(String date) {
    return 'Photo $date';
  }

  @override
  String get filterTitle => 'Filtres';

  @override
  String get filterReset => 'Réinitialiser';

  @override
  String get filterApply => 'Appliquer le filtre';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterNone => 'Aucun';

  @override
  String get filterFieldLabel => 'Champ';

  @override
  String get filterValueContains => 'La valeur contient';

  @override
  String get filterCondition => 'Condition';

  @override
  String get filterConditionPresent => 'Champ présent';

  @override
  String get filterConditionIsNull => 'Champ est vide';

  @override
  String get filterConditionEquals => 'La valeur est égale à';

  @override
  String get filterValueEquals => 'Valeur';

  @override
  String get filterAddCustomField => 'Ajouter un autre champ';

  @override
  String get filterBoolYes => 'Oui';

  @override
  String get filterBoolNo => 'Non';

  @override
  String get filterSectionTags => 'Étiquettes';

  @override
  String get filterSectionCorrespondent => 'Correspondant';

  @override
  String get filterSectionDocumentType => 'Type de document';

  @override
  String get filterSectionStoragePath => 'Chemin de stockage';

  @override
  String get filterSectionCreatedDate => 'Date de création';

  @override
  String get filterSectionAddedDate => 'Date d\'ajout';

  @override
  String get filterDateFrom => 'Du';

  @override
  String get filterDateTo => 'Au';

  @override
  String get filterSectionPermissions => 'Autorisations';

  @override
  String get filterPermissionMine => 'Mes documents';

  @override
  String get filterPermissionSharedWithMe => 'Partagé avec moi';

  @override
  String get filterPermissionSharedByMe => 'Partagé par moi';

  @override
  String get filterPermissionNoOwner => 'Sans propriétaire';

  @override
  String get filterPermissionUser => 'Utilisateur spécifique';

  @override
  String get filterSectionCustomField => 'Champ personnalisé';

  @override
  String get filterSectionSorting => 'Tri';

  @override
  String get filterSortCreatedNewest => 'Créé (plus récent en premier)';

  @override
  String get filterSortCreatedOldest => 'Créé (plus ancien en premier)';

  @override
  String get filterSortModifiedNewest => 'Modifié (plus récent en premier)';

  @override
  String get filterSortTitleAZ => 'Titre (A-Z)';

  @override
  String get filterSortTitleZA => 'Titre (Z-A)';

  @override
  String get filterSortAddedNewest => 'Ajouté (plus récent en premier)';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionConnection => 'Connexion';

  @override
  String get settingsServer => 'Serveur';

  @override
  String get settingsUser => 'Utilisateur';

  @override
  String get settingsSectionView => 'Affichage';

  @override
  String get settingsDefaultView => 'Vue par défaut au démarrage';

  @override
  String get settingsNoSavedViews => 'Aucune vue enregistrée disponible.';

  @override
  String get settingsSectionSecurity => 'Sécurité';

  @override
  String get settingsHttpsOnly => 'Connexions HTTPS uniquement';

  @override
  String get settingsHttpsOnlyDesc =>
      'Actif par défaut et ne peut pas être désactivé';

  @override
  String get settingsSectionAccount => 'Compte';

  @override
  String get settingsLogout => 'Se déconnecter';

  @override
  String get settingsLogoutDesc =>
      'Supprimer le token et les données enregistrées';

  @override
  String get settingsLogoutDialogTitle => 'Se déconnecter';

  @override
  String get settingsLogoutDialogContent =>
      'Le token enregistré et les données de connexion seront supprimés. Continuer ?';

  @override
  String get settingsSectionLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Langue du système';

  @override
  String get settingsLanguageLabel => 'Langue';

  @override
  String get settingsSectionDisplay => 'Affichage';

  @override
  String get settingsTagsAsDropdown => 'Étiquettes en liste déroulante';

  @override
  String get settingsTagsAsDropdownDesc =>
      'Afficher les étiquettes sous forme de liste multi-sélection au lieu de puces';

  @override
  String get settingsSavedViewsAsDropdown => 'Vues en liste déroulante';

  @override
  String get settingsSavedViewsAsDropdownDesc =>
      'Afficher les vues enregistrées en liste déroulante au lieu de puces';

  @override
  String get tagPickerTitle => 'Sélectionner des étiquettes';

  @override
  String get tagPickerNone => 'Aucune étiquette sélectionnée';

  @override
  String tagPickerCount(int count) {
    return '$count étiquettes sélectionnées';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsConfirmAll => 'Tout confirmer';

  @override
  String get notificationsEmpty => 'Aucune notification disponible.';

  @override
  String get notificationsUnknownFile => 'Fichier inconnu';

  @override
  String get notificationsDismiss => 'Ignorer';

  @override
  String get statusSuccess => 'Succès';

  @override
  String get statusFailure => 'Erreur';

  @override
  String get statusRunning => 'En cours';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusRevoked => 'Annulé';

  @override
  String get apiErrorHttpsOnly =>
      'Seules les connexions HTTPS sont autorisées.';

  @override
  String get apiErrorNoToken => 'Aucun token dans la réponse du serveur';

  @override
  String get apiErrorTimeout =>
      'Délai de connexion dépassé. Vérifiez l\'URL du serveur.';

  @override
  String get apiErrorSsl =>
      'Erreur de certificat SSL. Autorisez les certificats auto-signés dans les paramètres.';

  @override
  String get apiErrorConnection =>
      'Erreur de connexion. Vérifiez l\'URL du serveur et le réseau.';

  @override
  String get apiErrorUnauthorized => 'Identifiants invalides.';

  @override
  String get apiErrorForbidden => 'Accès refusé.';

  @override
  String get apiErrorNotFound => 'Ressource introuvable.';

  @override
  String apiErrorServer(String code) {
    return 'Erreur serveur (HTTP $code)';
  }
}
