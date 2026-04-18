// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTagline => 'Yet Another Paperless App';

  @override
  String get appDescription => 'Yet Another Paperless-ngx App';

  @override
  String get navDocuments => 'Documentos';

  @override
  String get navNotifications => 'Tareas de archivos';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionConfirm => 'Entendido';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get actionRefresh => 'Actualizar';

  @override
  String get actionLogout => 'Cerrar sesión';

  @override
  String get actionClearAll => 'Borrar todo';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get loginServerUrl => 'URL del servidor';

  @override
  String get loginServerUrlHint => 'https://paperless.example.com';

  @override
  String get loginUsername => 'Usuario';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginAllowSelfSigned => 'Permitir certificados autofirmados';

  @override
  String get loginSecurityWarningTitle => 'Advertencia de seguridad';

  @override
  String get loginSecurityWarningText =>
      'Permitir certificados autofirmados reduce la seguridad. Solo actívalo si sabes lo que haces y confías en el servidor.';

  @override
  String get loginValidateServerUrl =>
      'Por favor, introduce la URL del servidor';

  @override
  String get loginValidateHttps =>
      'Solo se permiten conexiones HTTPS (https://...)';

  @override
  String get loginValidateUsername => 'Por favor, introduce tu usuario';

  @override
  String get loginValidatePassword => 'Por favor, introduce tu contraseña';

  @override
  String get documentsSearch => 'Buscar documentos...';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos',
      one: '1 documento',
    );
    return '$_temp0';
  }

  @override
  String get documentsAll => 'Todos los documentos';

  @override
  String get documentsEmpty => 'No hay documentos disponibles.';

  @override
  String get documentsEmptyWithFilter =>
      'No se encontraron documentos.\n¿Ajustar filtros?';

  @override
  String get documentsResetFilter => 'Restablecer filtros';

  @override
  String get detailMenuDetails => 'Detalles';

  @override
  String get detailMenuDownload => 'Descargar';

  @override
  String get detailMenuDelete => 'Eliminar';

  @override
  String detailDownloadSaved(String path) {
    return 'Guardado: $path';
  }

  @override
  String get detailDownloadFailed => 'Error al descargar.';

  @override
  String get detailDeleteTitle => 'Eliminar documento';

  @override
  String get detailDeleteConfirm =>
      'El documento se eliminará permanentemente. Esta acción no se puede deshacer.';

  @override
  String get detailDeleteFailed => 'Error al eliminar.';

  @override
  String get detailEdit => 'Editar';

  @override
  String get detailLoading => 'Cargando documento...';

  @override
  String get detailLoadError => 'No se pudo cargar el documento.';

  @override
  String detailLoadErrorDetail(String error) {
    return 'No se pudo cargar el documento:\n$error';
  }

  @override
  String get detailSaveDialog => 'Guardar documento';

  @override
  String get detailScreenTitle => 'Detalles';

  @override
  String get detailFieldTitle => 'Título';

  @override
  String get detailFieldCreated => 'Creado';

  @override
  String get detailFieldModified => 'Modificado';

  @override
  String get detailFieldAdded => 'Añadido';

  @override
  String get detailFieldCorrespondent => 'Corresponsal';

  @override
  String get detailFieldDocumentType => 'Tipo de documento';

  @override
  String get detailFieldStoragePath => 'Ruta de almacenamiento';

  @override
  String get detailFieldArchiveNumber => 'Número de archivo';

  @override
  String get detailFieldOriginalFile => 'Archivo original';

  @override
  String get detailSectionTags => 'Etiquetas';

  @override
  String get detailSectionCustomFields => 'Campos personalizados';

  @override
  String get detailSectionContent => 'Contenido (OCR)';

  @override
  String get editTitle => 'Editar';

  @override
  String get editSaveError => 'Error al guardar.';

  @override
  String get editFieldTitle => 'Título';

  @override
  String get editFieldCreatedDate => 'Fecha de creación';

  @override
  String get editFieldCorrespondent => 'Corresponsal';

  @override
  String get editFieldDocumentType => 'Tipo de documento';

  @override
  String get editFieldStoragePath => 'Ruta de almacenamiento';

  @override
  String editDropdownNone(String label) {
    return '— Sin $label —';
  }

  @override
  String get uploadTitle => 'Subir documento';

  @override
  String get uploadButton => 'Subir';

  @override
  String get uploadFailed => 'Error al subir.';

  @override
  String get uploadProcessing => 'El documento se está procesando...';

  @override
  String get uploadSectionFile => 'Archivo';

  @override
  String get uploadPickFile => 'Elegir archivo';

  @override
  String get uploadTakePhoto => 'Tomar foto';

  @override
  String get uploadSectionMetadata => 'Metadatos';

  @override
  String uploadPhotoTitle(String date) {
    return 'Foto $date';
  }

  @override
  String get filterTitle => 'Filtro';

  @override
  String get filterReset => 'Restablecer';

  @override
  String get filterApply => 'Aplicar filtro';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterNone => 'Ninguno';

  @override
  String get filterFieldLabel => 'Campo';

  @override
  String get filterValueContains => 'El valor contiene';

  @override
  String get filterSectionTags => 'Etiquetas';

  @override
  String get filterSectionCorrespondent => 'Corresponsal';

  @override
  String get filterSectionDocumentType => 'Tipo de documento';

  @override
  String get filterSectionCustomField => 'Campo personalizado';

  @override
  String get filterSectionSorting => 'Ordenación';

  @override
  String get filterSortCreatedNewest => 'Creado (más reciente primero)';

  @override
  String get filterSortCreatedOldest => 'Creado (más antiguo primero)';

  @override
  String get filterSortModifiedNewest => 'Modificado (más reciente primero)';

  @override
  String get filterSortTitleAZ => 'Título (A-Z)';

  @override
  String get filterSortTitleZA => 'Título (Z-A)';

  @override
  String get filterSortAddedNewest => 'Añadido (más reciente primero)';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionConnection => 'Conexión';

  @override
  String get settingsServer => 'Servidor';

  @override
  String get settingsUser => 'Usuario';

  @override
  String get settingsSectionView => 'Vista';

  @override
  String get settingsDefaultView => 'Vista predeterminada al inicio';

  @override
  String get settingsNoSavedViews => 'No hay vistas guardadas disponibles.';

  @override
  String get settingsSectionSecurity => 'Seguridad';

  @override
  String get settingsHttpsOnly => 'Solo conexiones HTTPS';

  @override
  String get settingsHttpsOnlyDesc =>
      'Activo por defecto y no se puede desactivar';

  @override
  String get settingsSectionAccount => 'Cuenta';

  @override
  String get settingsLogout => 'Cerrar sesión';

  @override
  String get settingsLogoutDesc => 'Eliminar token y datos guardados';

  @override
  String get settingsLogoutDialogTitle => 'Cerrar sesión';

  @override
  String get settingsLogoutDialogContent =>
      'El token guardado y los datos de conexión se eliminarán. ¿Continuar?';

  @override
  String get settingsSectionLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Idioma del sistema';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsConfirmAll => 'Confirmar todo';

  @override
  String get notificationsEmpty => 'No hay notificaciones disponibles.';

  @override
  String get notificationsUnknownFile => 'Archivo desconocido';

  @override
  String get notificationsDismiss => 'Descartar';

  @override
  String get statusSuccess => 'Correcto';

  @override
  String get statusFailure => 'Error';

  @override
  String get statusRunning => 'En curso';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusRevoked => 'Cancelado';

  @override
  String get apiErrorHttpsOnly => 'Solo se permiten conexiones HTTPS.';

  @override
  String get apiErrorNoToken => 'No se recibió token del servidor';

  @override
  String get apiErrorTimeout =>
      'Tiempo de espera agotado. Comprueba la URL del servidor.';

  @override
  String get apiErrorSsl =>
      'Error de certificado SSL. Permite certificados autofirmados en los ajustes.';

  @override
  String get apiErrorConnection =>
      'Error de conexión. Comprueba la URL del servidor y la red.';

  @override
  String get apiErrorUnauthorized => 'Credenciales no válidas.';

  @override
  String get apiErrorForbidden => 'Acceso denegado.';

  @override
  String get apiErrorNotFound => 'Recurso no encontrado.';

  @override
  String apiErrorServer(String code) {
    return 'Error del servidor (HTTP $code)';
  }
}
