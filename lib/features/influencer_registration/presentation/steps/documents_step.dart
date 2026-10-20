import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

typedef _Missing = ({String label, RegistrationStep step});

enum _Source { camera, gallery, file }

/// يختار الوثيقة: كاميرا، معرض الصور، أو ملف PDF.
Future<UploadFile?> pickDocument(BuildContext context) async {
  final l10n = context.l10n;
  final source = await showModalBottomSheet<_Source>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.fromCamera),
            onTap: () => Navigator.pop(sheetContext, _Source.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.fromGallery),
            onTap: () => Navigator.pop(sheetContext, _Source.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf_outlined),
            title: Text(l10n.regFromFiles),
            onTap: () => Navigator.pop(sheetContext, _Source.file),
          ),
        ],
      ),
    ),
  );
  return switch (source) {
    _Source.camera => await pickPhoto(ImageSource.camera),
    _Source.gallery => await pickPhoto(ImageSource.gallery),
    _Source.file => await pickDocumentFile(),
    null => null,
  };
}

/// خانة وثيقة واحدة (بطاقة التعريف، جواز السفر، الصك...).
/// السيرفر يقرا الوثيقة: صورة ماشي وثيقة تترفض، وبعد 3 محاولات تتقبل وتتراجع في الاجتماع.
class DocumentTile extends StatefulWidget {
  const DocumentTile({
    super.key,
    required this.type,
    required this.slot,
    required this.document,
    required this.busy,
    required this.enabled,
    required this.highlightMissing,
    required this.onUpload,
    required this.onDelete,
  });

  final DocumentType type;

  /// نفس target تاع الكيوبت (النوع، أو الحساب المالي)
  final Object slot;
  final RegistrationDocument? document;
  final bool busy;
  final bool enabled;
  final bool highlightMissing;
  final void Function(UploadFile file, bool acceptUnreadable) onUpload;
  final ValueChanged<RegistrationDocument> onDelete;

  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  int _attempts = 0;
  UploadFile? _lastFile;

  Future<void> _upload(BuildContext context) async {
    final file = await pickDocument(context);
    if (file == null) return;
    _lastFile = file;
    widget.onUpload(file, false);
  }

  Future<void> _listener(BuildContext context, RegistrationState state) async {
    if (state.status == OperationStatus.success) {
      _attempts = 0;
      return;
    }
    final failure = state.failure;
    if (failure == null || !isUnrecognized(failure)) return;
    _attempts++;
    const max = RegistrationCatalog.maxScanAttempts;
    if (_attempts < max) {
      showErrorSnackBar(context, context.l10n.docUnrecognizedRetry(_attempts, max));
      return;
    }
    final file = _lastFile;
    if (file == null) return;
    if (await confirmManualReview(context) && mounted) {
      _attempts = 0;
      widget.onUpload(file, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final document = widget.document;
    final uploaded = document != null;
    final busy = widget.busy;
    final enabled = widget.enabled;

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) =>
          current.action == RegistrationAction.uploadDocument &&
          current.target == widget.slot &&
          previous.status != current.status &&
          current.status != OperationStatus.loading,
      listener: _listener,
      child: ItemCard(
        icon: uploaded ? Icons.task_alt_rounded : Icons.upload_file_rounded,
        highlight: uploaded ? AppColors.success : (widget.highlightMissing ? AppColors.error : null),
        title: l10n.documentLabel(widget.type),
        subtitle: switch (document) {
          RegistrationDocument(verified: true) => l10n.documentVerified,
          RegistrationDocument(check: DocumentCheck.needsManualReview) => l10n.regNeedsReview,
          RegistrationDocument(check: DocumentCheck.passed) => l10n.regDocChecked,
          final RegistrationDocument d => d.fileName.isEmpty ? l10n.documentUploaded : d.fileName,
          null => l10n.documentsSubtitle,
        },
        onTap: enabled && !busy ? () => _upload(context) : null,
        trailing: busy
            ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
            : document != null
                ? IconButton(
                    tooltip: l10n.delete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: enabled ? () => widget.onDelete(document) : null,
                  )
                : Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                    child: Text(
                      l10n.upload,
                      style: context.textTheme.labelMedium?.copyWith(color: context.colors.primary),
                    ),
                  ),
      ),
    );
  }
}

/// اختيار وثيقة الهوية + خاناتها (تُستعمل في المعلومات الشخصية وفي الوثائق).
class IdentityDocuments extends StatelessWidget {
  const IdentityDocuments({
    super.key,
    required this.kind,
    required this.onKindChanged,
    this.showErrors = false,
  });

  final IdentityKind kind;
  final ValueChanged<IdentityKind> onKindChanged;
  final bool showErrors;

  static List<DocumentType> typesFor(IdentityKind kind) => switch (kind) {
        IdentityKind.idCard => const [DocumentType.identityFront, DocumentType.identityBack],
        IdentityKind.passport => const [DocumentType.passport],
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final types = typesFor(kind);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<IdentityKind>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(value: IdentityKind.idCard, label: Text(l10n.regIdCard)),
            ButtonSegment(value: IdentityKind.passport, label: Text(l10n.docPassport)),
          ],
          selected: {kind},
          onSelectionChanged: (value) => onKindChanged(value.first),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final type in types)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: DocumentTile(
              type: type,
              slot: type,
              document: state.documentOf(type),
              busy: state.isLoadingFor(RegistrationAction.uploadDocument, type) ||
                  state.isLoadingFor(RegistrationAction.deleteDocument, type),
              enabled: !state.isLoading,
              highlightMissing: showErrors && state.documentOf(type) == null,
              onUpload: (file, acceptUnreadable) =>
                  cubit.uploadDocument(type, file, acceptUnreadable: acceptUnreadable),
              onDelete: cubit.deleteDocument,
            ),
          ),
        if (showErrors && !state.hasIdentity)
          Text(
            l10n.missingDocumentsWarning(l10n.documentList(types)),
            style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
      ],
    );
  }
}

/// نوع الهوية اللي رفعها من قبل
IdentityKind initialIdentityKind(RegistrationState state) =>
    state.documentOf(DocumentType.passport) != null && !state.hasIdCard ? IdentityKind.passport : IdentityKind.idCard;

/// الوثائق المطلوبة للرفع + الإرسال النهائي.
class DocumentsStep extends StatefulWidget {
  const DocumentsStep({super.key});

  @override
  State<DocumentsStep> createState() => _DocumentsStepState();
}

class _DocumentsStepState extends State<DocumentsStep> {
  late IdentityKind _identity;
  List<_Missing> _missing = const [];
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    _identity = initialIdentityKind(context.read<RegistrationCubit>().state);
  }

  void _submit() {
    final cubit = context.read<RegistrationCubit>();
    if (!cubit.state.hasIdentity) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _missing = const []);
    cubit.submit();
  }

  /// يحوّل أخطاء الإرسال من السيرفر لقائمة "أكمل هذه العناصر" مع زر يرجع للخطوة.
  List<_Missing> _missingFrom(ValidationFailure failure) {
    final l10n = context.l10n;
    final details = failure.details;
    bool has(String key) => details.containsKey(key);
    final financialMissing = has(ApiKeys.financialAccounts) ||
        switch (details[ApiKeys.documents]) {
          {ApiKeys.financialAccounts: _} => true,
          _ => false,
        };
    return [
      if ([ApiKeys.firstName, ApiKeys.lastName, ApiKeys.birthDate, ApiKeys.birthPlace, ApiKeys.entityType].any(has))
        (label: l10n.regStepPersonal, step: RegistrationStep.personal),
      if ([
        ApiKeys.displayName,
        ApiKeys.bio,
        ApiKeys.primaryCategories,
        ApiKeys.contentLanguages,
        ApiKeys.addressLanguages,
      ].any(has))
        (label: l10n.regStepProfile, step: RegistrationStep.profile),
      if ([ApiKeys.phone, ApiKeys.whatsapp, ApiKeys.email].any(has))
        (label: l10n.regStepContact, step: RegistrationStep.contact),
      if (has(ApiKeys.socialAccounts)) (label: l10n.socialAccountsEmpty, step: RegistrationStep.accounts),
      if (financialMissing) (label: l10n.regStepFinancial, step: RegistrationStep.financial),
      if ([ApiKeys.acceptedPrivacy, ApiKeys.acceptedTerms, ApiKeys.recoveryMethod, ApiKeys.recoveryPhone].any(has))
        (label: l10n.regStepSecurity, step: RegistrationStep.security),
      if (has('profileImage')) (label: l10n.regStepPhoto, step: RegistrationStep.photo),
      if (failure.missingDocuments.isNotEmpty)
        (
          label: l10n.missingDocumentsWarning(l10n.documentList([
            for (final type in failure.missingDocuments) enumFromApi(DocumentType.values, type, DocumentType.other),
          ])),
          step: RegistrationStep.documents,
        ),
    ];
  }

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.status != OperationStatus.failure || failure == null) return;
    if (state.action == RegistrationAction.submit && failure is ValidationFailure) {
      final missing = _missingFrom(failure);
      if (missing.isNotEmpty) {
        setState(() => _missing = missing);
        return;
      }
    }
    // الوثيقة اللي ما تقراتش: الخانة تتكفّل بيها (المحاولات)
    if (state.action == RegistrationAction.uploadDocument && isUnrecognized(failure)) return;
    const actions = {RegistrationAction.submit, RegistrationAction.uploadDocument, RegistrationAction.deleteDocument};
    if (actions.contains(state.action)) showRegistrationFailure(context, failure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        actions: StepActions(
          isLoading: state.isLoadingFor(RegistrationAction.submit),
          onBack: cubit.back,
          onNext: _submit,
          nextLabel: l10n.submitForReview,
        ),
        children: [
          if (_missing.isNotEmpty) _MissingBox(items: _missing, onFix: cubit.goTo),
          SectionTitle(l10n.regDocumentsTitle),
          IdentityDocuments(
            kind: _identity,
            showErrors: _showErrors,
            onKindChanged: (kind) => setState(() => _identity = kind),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _MissingBox extends StatelessWidget {
  const _MissingBox({required this.items, required this.onFix});

  final List<_Missing> items;
  final ValueChanged<RegistrationStep> onFix;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.submitMissingTitle, style: context.textTheme.titleSmall?.copyWith(color: AppColors.error)),
          const SizedBox(height: AppSpacing.xs),
          for (final item in items)
            Row(
              children: [
                const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(item.label, style: context.textTheme.bodySmall)),
                TextButton(onPressed: () => onFix(item.step), child: Text(l10n.fix)),
              ],
            ),
        ],
      ),
    );
  }
}
