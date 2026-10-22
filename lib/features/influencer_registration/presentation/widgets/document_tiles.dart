import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

enum _Source { camera, gallery, file }

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
        IdentityKind.idCard => const [DocumentType.identityFront],
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

IdentityKind initialIdentityKind(RegistrationState state) =>
    state.documentOf(DocumentType.passport) != null && !state.hasIdCard ? IdentityKind.passport : IdentityKind.idCard;

