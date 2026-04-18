// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTagline => 'Yet Another Paperless App';

  @override
  String get appDescription => 'Yet Another Paperless-ngx App';

  @override
  String get navDocuments => 'Documentos';

  @override
  String get navNotifications => 'Tarefas de ficheiros';

  @override
  String get navSettings => 'Definições';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionConfirm => 'Entendido';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get actionRefresh => 'Atualizar';

  @override
  String get actionLogout => 'Terminar sessão';

  @override
  String get actionClearAll => 'Limpar tudo';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get loginServerUrl => 'URL do servidor';

  @override
  String get loginServerUrlHint => 'https://paperless.example.com';

  @override
  String get loginUsername => 'Nome de utilizador';

  @override
  String get loginPassword => 'Palavra-passe';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginAllowSelfSigned => 'Permitir certificados autoassinados';

  @override
  String get loginSecurityWarningTitle => 'Aviso de segurança';

  @override
  String get loginSecurityWarningText =>
      'Permitir certificados autoassinados reduz a segurança. Ative apenas se souber o que está a fazer e confiar no servidor.';

  @override
  String get loginValidateServerUrl => 'Por favor, introduza o URL do servidor';

  @override
  String get loginValidateHttps =>
      'Apenas são permitidas ligações HTTPS (https://...)';

  @override
  String get loginValidateUsername =>
      'Por favor, introduza o nome de utilizador';

  @override
  String get loginValidatePassword => 'Por favor, introduza a palavra-passe';

  @override
  String get documentsSearch => 'Pesquisar documentos...';

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
  String get documentsAll => 'Todos os documentos';

  @override
  String get documentsEmpty => 'Nenhum documento disponível.';

  @override
  String get documentsEmptyWithFilter =>
      'Nenhum documento encontrado.\nAjustar filtros?';

  @override
  String get documentsResetFilter => 'Repor filtros';

  @override
  String get detailMenuDetails => 'Detalhes';

  @override
  String get detailMenuDownload => 'Transferir';

  @override
  String get detailMenuDelete => 'Eliminar';

  @override
  String detailDownloadSaved(String path) {
    return 'Guardado: $path';
  }

  @override
  String get detailDownloadFailed => 'Falha na transferência.';

  @override
  String get detailDeleteTitle => 'Eliminar documento';

  @override
  String get detailDeleteConfirm =>
      'O documento será eliminado permanentemente. Esta ação não pode ser desfeita.';

  @override
  String get detailDeleteFailed => 'Falha ao eliminar.';

  @override
  String get detailEdit => 'Editar';

  @override
  String get detailLoading => 'A carregar documento...';

  @override
  String get detailLoadError => 'Não foi possível carregar o documento.';

  @override
  String detailLoadErrorDetail(String error) {
    return 'Não foi possível carregar o documento:\n$error';
  }

  @override
  String get detailSaveDialog => 'Guardar documento';

  @override
  String get detailScreenTitle => 'Detalhes';

  @override
  String get detailFieldTitle => 'Título';

  @override
  String get detailFieldCreated => 'Criado';

  @override
  String get detailFieldModified => 'Modificado';

  @override
  String get detailFieldAdded => 'Adicionado';

  @override
  String get detailFieldCorrespondent => 'Correspondente';

  @override
  String get detailFieldDocumentType => 'Tipo de documento';

  @override
  String get detailFieldStoragePath => 'Caminho de armazenamento';

  @override
  String get detailFieldArchiveNumber => 'Número de arquivo';

  @override
  String get detailFieldOriginalFile => 'Ficheiro original';

  @override
  String get detailSectionTags => 'Etiquetas';

  @override
  String get detailSectionCustomFields => 'Campos personalizados';

  @override
  String get detailSectionContent => 'Conteúdo (OCR)';

  @override
  String get editTitle => 'Editar';

  @override
  String get editSaveError => 'Erro ao guardar.';

  @override
  String get editFieldTitle => 'Título';

  @override
  String get editFieldCreatedDate => 'Data de criação';

  @override
  String get editFieldCorrespondent => 'Correspondente';

  @override
  String get editFieldDocumentType => 'Tipo de documento';

  @override
  String get editFieldStoragePath => 'Caminho de armazenamento';

  @override
  String editDropdownNone(String label) {
    return '— Sem $label —';
  }

  @override
  String get uploadTitle => 'Carregar documento';

  @override
  String get uploadButton => 'Carregar';

  @override
  String get uploadFailed => 'Falha no carregamento.';

  @override
  String get uploadProcessing => 'O documento está a ser processado...';

  @override
  String get uploadSectionFile => 'Ficheiro';

  @override
  String get uploadPickFile => 'Escolher ficheiro';

  @override
  String get uploadTakePhoto => 'Tirar foto';

  @override
  String get uploadSectionMetadata => 'Metadados';

  @override
  String uploadPhotoTitle(String date) {
    return 'Foto $date';
  }

  @override
  String get filterTitle => 'Filtro';

  @override
  String get filterReset => 'Repor';

  @override
  String get filterApply => 'Aplicar filtro';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterNone => 'Nenhum';

  @override
  String get filterFieldLabel => 'Campo';

  @override
  String get filterValueContains => 'Valor contém';

  @override
  String get filterSectionTags => 'Etiquetas';

  @override
  String get filterSectionCorrespondent => 'Correspondente';

  @override
  String get filterSectionDocumentType => 'Tipo de documento';

  @override
  String get filterSectionCustomField => 'Campo personalizado';

  @override
  String get filterSectionSorting => 'Ordenação';

  @override
  String get filterSortCreatedNewest => 'Criado (mais recente primeiro)';

  @override
  String get filterSortCreatedOldest => 'Criado (mais antigo primeiro)';

  @override
  String get filterSortModifiedNewest => 'Modificado (mais recente primeiro)';

  @override
  String get filterSortTitleAZ => 'Título (A-Z)';

  @override
  String get filterSortTitleZA => 'Título (Z-A)';

  @override
  String get filterSortAddedNewest => 'Adicionado (mais recente primeiro)';

  @override
  String get settingsTitle => 'Definições';

  @override
  String get settingsSectionConnection => 'Ligação';

  @override
  String get settingsServer => 'Servidor';

  @override
  String get settingsUser => 'Utilizador';

  @override
  String get settingsSectionView => 'Vista';

  @override
  String get settingsDefaultView => 'Vista predefinida no arranque';

  @override
  String get settingsNoSavedViews => 'Nenhuma vista guardada disponível.';

  @override
  String get settingsSectionSecurity => 'Segurança';

  @override
  String get settingsHttpsOnly => 'Apenas ligações HTTPS';

  @override
  String get settingsHttpsOnlyDesc =>
      'Ativo por predefinição e não pode ser desativado';

  @override
  String get settingsSectionAccount => 'Conta';

  @override
  String get settingsLogout => 'Terminar sessão';

  @override
  String get settingsLogoutDesc => 'Eliminar token e dados guardados';

  @override
  String get settingsLogoutDialogTitle => 'Terminar sessão';

  @override
  String get settingsLogoutDialogContent =>
      'O token guardado e os dados de ligação serão eliminados. Continuar?';

  @override
  String get settingsSectionLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Idioma do sistema';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsConfirmAll => 'Confirmar tudo';

  @override
  String get notificationsEmpty => 'Nenhuma notificação disponível.';

  @override
  String get notificationsUnknownFile => 'Ficheiro desconhecido';

  @override
  String get notificationsDismiss => 'Ignorar';

  @override
  String get statusSuccess => 'Sucesso';

  @override
  String get statusFailure => 'Erro';

  @override
  String get statusRunning => 'Em execução';

  @override
  String get statusPending => 'Pendente';

  @override
  String get statusRevoked => 'Cancelado';

  @override
  String get apiErrorHttpsOnly => 'Apenas são permitidas ligações HTTPS.';

  @override
  String get apiErrorNoToken => 'Nenhum token na resposta do servidor';

  @override
  String get apiErrorTimeout =>
      'Tempo limite de ligação excedido. Verifique o URL do servidor.';

  @override
  String get apiErrorSsl =>
      'Erro de certificado SSL. Permita certificados autoassinados nas definições.';

  @override
  String get apiErrorConnection =>
      'Erro de ligação. Verifique o URL do servidor e a rede.';

  @override
  String get apiErrorUnauthorized => 'Credenciais inválidas.';

  @override
  String get apiErrorForbidden => 'Acesso negado.';

  @override
  String get apiErrorNotFound => 'Recurso não encontrado.';

  @override
  String apiErrorServer(String code) {
    return 'Erro do servidor (HTTP $code)';
  }
}
