import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/app_palette.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart' show IdentityKind;
import 'package:x_ten/features/influencer_registration/presentation/widgets/document_tiles.dart' show pickDocument;
import 'package:x_ten/features/influencer_registration/presentation/widgets/scan_helpers.dart';

export 'package:x_ten/features/influencer_registration/domain/registration_entities.dart' show IdentityKind;
export 'package:x_ten/features/influencer_registration/presentation/widgets/document_tiles.dart' show pickDocument;
export 'package:x_ten/features/influencer_registration/presentation/widgets/scan_helpers.dart';

String companyDocumentStatus(BuildContext context, CompanyDocument? document) {
  final l10n = context.l10n;
  return switch (document) {
    null => l10n.documentsSubtitle,
    final CompanyDocument d when d.review != DocumentReview.pending => l10n.documentReviewLabel(d),
    CompanyDocument(check: DocumentCheck.needsManualReview) => l10n.regNeedsReview,
    CompanyDocument(check: DocumentCheck.passed) => '${l10n.regDocChecked} · ${l10n.docReviewPending}',
    CompanyDocument(description: final text) when text.isNotEmpty => '$text · ${l10n.docReviewPending}',
    _ => l10n.docReviewPending,
  };
}

Color? companyDocumentColor(AppPalette palette, CompanyDocument? document, {bool highlightMissing = false}) => switch (document) {
      null => highlightMissing ? palette.error : null,
      CompanyDocument(review: DocumentReview.rejected) => palette.error,
      _ => palette.success,
    };

class CompanyDocumentTile extends StatefulWidget {
  const CompanyDocumentTile({
    super.key,
    required this.type,
    required this.slot,
    required this.document,
    required this.onUpload,
    this.title,
    this.highlightMissing = false,
  });

  final CompanyDocumentType type;
  final Object slot;
  final CompanyDocument? document;
  final String? title;
  final bool highlightMissing;
  final void Function(UploadFile file, bool acceptUnreadable) onUpload;

  @override
  State<CompanyDocumentTile> createState() => _CompanyDocumentTileState();
}

class _CompanyDocumentTileState extends State<CompanyDocumentTile> {
  int _attempts = 0;
  UploadFile? _lastFile;

  Future<void> _upload(BuildContext context) async {
    final file = await pickDocument(context);
    if (file == null) {
      return;
    }
    _lastFile = file;
    widget.onUpload(file, false);
  }

  Future<void> _listener(BuildContext context, CompanyState state) async {
    if (state.status == CompanyStatus.success) {
      _attempts = 0;
      return;
    }
    final failure = state.failure;
    if (failure == null) {
      return;
    }
    if (!isUnrecognized(failure)) {
      showRegistrationFailure(context, failure);
      return;
    }
    _attempts++;
    const max = CompanyCatalog.maxScanAttempts;
    if (_attempts < max) {
      showErrorSnackBar(context, context.l10n.docUnrecognizedRetry(_attempts, max));
      return;
    }
    final file = _lastFile;
    if (file == null) {
      return;
    }
    if (await confirmManualReview(context) && mounted) {
      _attempts = 0;
      widget.onUpload(file, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
    final document = widget.document;
    final busy = state.isLoadingFor(CompanyAction.uploadDocument, widget.slot) ||
        (document != null && state.isLoadingFor(CompanyAction.deleteDocument, document.id));
    final enabled = !state.isLoading;

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) =>
          current.action == CompanyAction.uploadDocument &&
          current.target == widget.slot &&
          previous.status != current.status &&
          current.status != CompanyStatus.loading,
      listener: _listener,
      child: ItemCard(
        icon: document == null ? Icons.upload_file_rounded : Icons.task_alt_rounded,
        highlight: companyDocumentColor(context.palette, document, highlightMissing: widget.highlightMissing),
        title: widget.title ?? l10n.companyDocumentLabel(widget.type),
        subtitle: companyDocumentStatus(context, document),
        onTap: enabled && !busy ? () => _upload(context) : null,
        trailing: busy
            ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
            : document != null
                ? IconButton(
                    tooltip: l10n.delete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: enabled ? () => cubit.deleteDocument(document) : null,
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

class CompanyIdentityDocuments extends StatelessWidget {
  const CompanyIdentityDocuments({
    super.key,
    required this.kind,
    required this.onKindChanged,
    this.showErrors = false,
  });

  final IdentityKind kind;
  final ValueChanged<IdentityKind> onKindChanged;
  final bool showErrors;

  static List<CompanyDocumentType> typesFor(IdentityKind kind) => switch (kind) {
        IdentityKind.idCard => const [CompanyDocumentType.identityFront],
        IdentityKind.passport => const [CompanyDocumentType.passport],
      };

  static IdentityKind initialKind(CompanyState state) =>
      state.documentOf(CompanyDocumentType.passport) != null && !state.hasIdCard
          ? IdentityKind.passport
          : IdentityKind.idCard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
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
            child: CompanyDocumentTile(
              type: type,
              slot: type,
              title: req(l10n.companyDocumentLabel(type)),
              document: state.documentOf(type),
              highlightMissing: showErrors && state.documentOf(type) == null,
              onUpload: (file, acceptUnreadable) =>
                  cubit.uploadDocument(type, file, acceptUnreadable: acceptUnreadable),
            ),
          ),
        if (showErrors && !state.hasIdentity)
          Text(
            l10n.missingDocumentsWarning(l10n.companyDocumentList(types)),
            style: context.textTheme.bodySmall?.copyWith(color: context.palette.error),
          ),
      ],
    );
  }
}
