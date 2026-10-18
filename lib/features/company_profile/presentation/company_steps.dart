import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/utils/validators.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';

class BusinessTypeStep extends StatefulWidget {
  const BusinessTypeStep({super.key});

  @override
  State<BusinessTypeStep> createState() => _BusinessTypeStepState();
}

class _BusinessTypeStepState extends State<BusinessTypeStep> {
  BusinessType? _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<CompanyCubit>().state.businessType;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CompanyCubit>();
    final isSaving = context.select((CompanyCubit c) => c.state.isLoadingFor(CompanyAction.saveType));
    final selected = _selected;

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => current.didFail(CompanyAction.saveType) && previous.status != current.status,
      listener: (context, state) => showRegistrationFailure(context, state.failure!),
      child: StepBody(
        actions: StepActions(
          isLoading: isSaving,
          onNext: selected == null
              ? null
              : () {
                  if (selected == cubit.state.businessType) {
                    cubit.next();
                  } else {
                    cubit.saveType(selected);
                  }
                },
        ),
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(l10n.businessTypeQuestion, style: context.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.businessTypeHint, style: context.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xl),
          for (final type in BusinessType.values) ...[
            _ChoiceCard(
              icon: type == BusinessType.registeredBusiness ? Icons.apartment_rounded : Icons.storefront_rounded,
              title: l10n.businessTypeTitle(type),
              description: l10n.businessTypeDescription(type),
              selected: selected == type,
              onTap: isSaving ? null : () => setState(() => _selected = type),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.xxlAll,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentPurple.withValues(alpha: 0.08) : colors.surfaceContainer,
            borderRadius: AppRadius.xxlAll,
            border: Border.all(
              color: selected ? AppColors.accentPurple : colors.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withValues(alpha: 0.12),
                  borderRadius: AppRadius.lgAll,
                ),
                child: Icon(icon, color: AppColors.accentPurple),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(description, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                color: selected ? AppColors.accentPurple : AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyInfoStep extends StatefulWidget {
  const CompanyInfoStep({super.key});

  @override
  State<CompanyInfoStep> createState() => _CompanyInfoStepState();
}

class _CompanyInfoStepState extends State<CompanyInfoStep> with ServerFieldErrors {
  static const _fields = [
    'ownerName',
    'companyName',
    'branch',
    'address',
    'registrationNumber',
    'establishmentDate',
    'ns',
    'nif',
    'rib',
    'professionalTitle',
    'activity',
    'nationalIdNumber',
  ];

  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c;
  late final BusinessType _type;
  DateTime? _establishmentDate;
  bool _declared = false;
  bool _showDeclaredError = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<CompanyCubit>().state;
    final info = state.profile?.info ?? const CompanyInfo();
    _type = state.businessType ?? BusinessType.registeredBusiness;
    _c = {
      'ownerName': TextEditingController(text: info.ownerName),
      'companyName': TextEditingController(text: info.companyName),
      'branch': TextEditingController(text: info.branch),
      'address': TextEditingController(text: info.address),
      'registrationNumber': TextEditingController(text: info.registrationNumber),
      'ns': TextEditingController(text: info.ns),
      'nif': TextEditingController(text: info.nif),
      'rib': TextEditingController(text: info.rib),
      'professionalTitle': TextEditingController(text: info.professionalTitle),
      'activity': TextEditingController(text: info.activity),
      'nationalIdNumber': TextEditingController(text: info.nationalIdNumber),
    };
    _establishmentDate = info.establishmentDate;
    _declared = info.declaredIndividualActivity;
  }

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _registered => _type == BusinessType.registeredBusiness;

  String _t(String key) => _c[key]!.text;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _establishmentDate ?? DateTime(now.year - 1),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) setState(() => _establishmentDate = picked);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    final declaredOk = _registered || _declared;
    if (!declaredOk) setState(() => _showDeclaredError = true);
    if (!valid || !declaredOk) return;
    context.read<CompanyCubit>().saveInfo(CompanyInfo(
          ownerName: _t('ownerName'),
          companyName: _t('companyName'),
          branch: _t('branch'),
          address: _t('address'),
          registrationNumber: _t('registrationNumber'),
          establishmentDate: _establishmentDate,
          ns: _t('ns'),
          nif: _t('nif'),
          rib: _t('rib'),
          professionalTitle: _t('professionalTitle'),
          activity: _t('activity'),
          nationalIdNumber: _t('nationalIdNumber'),
          declaredIndividualActivity: _declared,
        ));
  }

  Widget _field(
    String key,
    String label, {
    bool ltrInput = false,
    bool digits = false,
    int? maxLength,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
  }) =>
      TextFormField(
        controller: _c[key],
        maxLines: maxLines,
        minLines: 1,
        textDirection: ltrInput ? TextDirection.ltr : null,
        keyboardType: digits ? TextInputType.number : null,
        inputFormatters: [
          if (digits) digitsOnly,
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
        forceErrorText: serverError(key),
        onChanged: (_) => clearServerError(key),
        decoration: InputDecoration(labelText: label, alignLabelWithHint: maxLines > 1),
        validator: validator ?? (value) => requiredText(context, value),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CompanyCubit>();
    final isSaving = context.select((CompanyCubit c) => c.state.isLoadingFor(CompanyAction.saveInfo));
    final locale = Localizations.localeOf(context).toLanguageTag();
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => current.didFail(CompanyAction.saveInfo) && previous.status != current.status,
      listener: (context, state) => handleFailure(state.failure!, _fields),
      child: Form(
        key: _formKey,
        child: StepBody(
          actions: StepActions(isLoading: isSaving, onBack: cubit.back, onNext: _submit),
          children: [
            _field('ownerName', l10n.ownerName),
            if (_registered) ...[
              gap,
              _field('companyName', l10n.companyName),
              gap,
              _field('branch', l10n.branch),
              gap,
              _field('address', l10n.address, maxLines: 2),
              SectionTitle(l10n.legalInfo),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _field('registrationNumber', l10n.commercialRegister, ltrInput: true)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: InkWell(
                      borderRadius: AppRadius.lgAll,
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.establishmentDate,
                          suffixIcon: const Icon(Icons.calendar_month_outlined),
                          errorText: serverError('establishmentDate'),
                        ),
                        child: Text(
                          switch (_establishmentDate) {
                            final date? => DateFormat.yMMMd(locale).format(date),
                            null => '—',
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              gap,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _field('nif', l10n.taxId, ltrInput: true)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _field('ns', l10n.nationalId, ltrInput: true)),
                ],
              ),
              gap,
              _field(
                'rib',
                l10n.bankRib,
                ltrInput: true,
                digits: true,
                maxLength: 20,
                validator: (value) {
                  final digits = value?.trim() ?? '';
                  if (digits.isEmpty) return l10n.fieldRequired;
                  return digits.length == 20 ? null : l10n.ribInvalid;
                },
              ),
            ] else ...[
              gap,
              _field('professionalTitle', l10n.professionalTitle),
              gap,
              _field('activity', l10n.activityLabel),
              gap,
              _field('nationalIdNumber', l10n.nationalIdNumber, ltrInput: true, digits: true, maxLength: 18),
              gap,
              _field('address', l10n.address, maxLines: 2),
              gap,
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _declared,
                onChanged: (v) => setState(() {
                  _declared = v ?? false;
                  if (_declared) _showDeclaredError = false;
                }),
                title: Text(l10n.declaredIndividualActivity, style: context.textTheme.bodyMedium),
                subtitle: _showDeclaredError
                    ? Text(l10n.fieldRequired, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error))
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CompanyContactStep extends StatefulWidget {
  const CompanyContactStep({super.key});

  @override
  State<CompanyContactStep> createState() => _CompanyContactStepState();
}

class _CompanyContactStepState extends State<CompanyContactStep> with ServerFieldErrors {
  static const _fields = ['phone', 'email', 'website', 'marketingLinks'];
  static const _maxLinks = 5;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _website;
  late final List<TextEditingController> _links;

  @override
  void initState() {
    super.initState();
    final contact = context.read<CompanyCubit>().state.profile?.contact ?? const CompanyContact();
    _phone = TextEditingController(text: contact.phone);
    _email = TextEditingController(text: contact.email);
    _website = TextEditingController(text: contact.website);
    _links = [
      for (final link in contact.marketingLinks) TextEditingController(text: link),
      if (contact.marketingLinks.isEmpty) TextEditingController(),
    ];
  }

  @override
  void dispose() {
    for (final c in [_phone, _email, _website, ..._links]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<CompanyCubit>().saveContact(CompanyContact(
          phone: _phone.text,
          email: _email.text,
          website: _website.text,
          marketingLinks: [for (final c in _links) c.text],
        ));
  }

  String? _optionalUrl(String? value) => (value ?? '').trim().isEmpty ? null : urlText(context, value);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CompanyCubit>();
    final isSaving = context.select((CompanyCubit c) => c.state.isLoadingFor(CompanyAction.saveContact));
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) =>
          current.didFail(CompanyAction.saveContact) && previous.status != current.status,
      listener: (context, state) => handleFailure(state.failure!, _fields),
      child: Form(
        key: _formKey,
        child: StepBody(
          actions: StepActions(isLoading: isSaving, onBack: cubit.back, onNext: _submit),
          children: [
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              forceErrorText: serverError('phone'),
              onChanged: (_) => clearServerError('phone'),
              decoration: InputDecoration(labelText: l10n.officialPhone, prefixIcon: const Icon(Icons.phone_outlined)),
              validator: (value) {
                final phone = value?.trim() ?? '';
                if (phone.isEmpty) return l10n.phoneRequired;
                return Validators.isAlgerianMobile(phone) || phone.startsWith('+') ? null : l10n.phoneInvalid;
              },
            ),
            gap,
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              forceErrorText: serverError('email'),
              onChanged: (_) => clearServerError('email'),
              decoration: InputDecoration(labelText: l10n.officialEmail, prefixIcon: const Icon(Icons.email_outlined)),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return l10n.emailRequired;
                return Validators.isEmail(email) ? null : l10n.emailInvalid;
              },
            ),
            gap,
            TextFormField(
              controller: _website,
              keyboardType: TextInputType.url,
              textDirection: TextDirection.ltr,
              forceErrorText: serverError('website'),
              onChanged: (_) => clearServerError('website'),
              decoration: InputDecoration(
                labelText: '${l10n.website} (${l10n.optional})',
                prefixIcon: const Icon(Icons.language_rounded),
              ),
              validator: _optionalUrl,
            ),
            SectionTitle(
              l10n.marketingLinks,
              subtitle: l10n.marketingLinksHint,
              trailing: TextButton.icon(
                onPressed: _links.length >= _maxLinks ? null : () => setState(() => _links.add(TextEditingController())),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.add),
              ),
            ),
            for (final link in _links)
              Padding(
                key: ObjectKey(link),
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: link,
                        keyboardType: TextInputType.url,
                        textDirection: TextDirection.ltr,
                        decoration: const InputDecoration(hintText: 'https://instagram.com/...', isDense: true),
                        validator: _optionalUrl,
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.delete,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        setState(() => _links.remove(link));
                        WidgetsBinding.instance.addPostFrameCallback((_) => link.dispose());
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CompanyDocumentsStep extends StatefulWidget {
  const CompanyDocumentsStep({super.key});

  @override
  State<CompanyDocumentsStep> createState() => _CompanyDocumentsStepState();
}

class _CompanyDocumentsStepState extends State<CompanyDocumentsStep> {
  bool _showMissing = false;

  Future<void> _upload(CompanyDocumentType type) async {
    final cubit = context.read<CompanyCubit>();
    final file = await pickDocumentFile();
    if (file != null) await cubit.uploadDocument(type, file);
  }

  void _next() {
    final cubit = context.read<CompanyCubit>();
    if (cubit.state.missingDocuments.isNotEmpty) {
      setState(() => _showMissing = true);
      return;
    }
    cubit.next();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
    final missing = state.missingDocuments;

    return StepBody(
      actions: StepActions(onBack: cubit.back, onNext: state.isLoading ? null : _next, nextLabel: l10n.next),
      children: [
        SectionTitle(l10n.documentsTitle, subtitle: l10n.documentsSubtitle),
        for (final type in CompanyCatalog.requiredDocuments(state.businessType))
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _CompanyDocumentTile(
              type: type,
              document: state.documentOf(type),
              busy: state.isLoadingFor(CompanyAction.uploadDocument, type) ||
                  state.isLoadingFor(CompanyAction.deleteDocument, type),
              enabled: !state.isLoading,
              highlightMissing: _showMissing,
              onUpload: () => _upload(type),
              onDelete: cubit.deleteDocument,
            ),
          ),
        if (_showMissing && missing.isNotEmpty)
          Text(
            l10n.missingDocumentsWarning(l10n.companyDocumentList(missing)),
            style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
      ],
    );
  }
}

class _CompanyDocumentTile extends StatelessWidget {
  const _CompanyDocumentTile({
    required this.type,
    required this.document,
    required this.busy,
    required this.enabled,
    required this.highlightMissing,
    required this.onUpload,
    required this.onDelete,
  });

  final CompanyDocumentType type;
  final CompanyDocument? document;
  final bool busy;
  final bool enabled;
  final bool highlightMissing;
  final VoidCallback onUpload;
  final ValueChanged<CompanyDocument> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final document = this.document;

    return ItemCard(
      icon: document != null ? Icons.task_alt_rounded : Icons.upload_file_rounded,
      highlight: document != null ? AppColors.success : (highlightMissing ? AppColors.error : null),
      title: l10n.companyDocumentLabel(type),
      subtitle: switch (document) {
        CompanyDocument(verified: true) => l10n.documentVerified,
        final CompanyDocument d => d.fileName.isEmpty ? l10n.documentUploaded : d.fileName,
        null => l10n.documentsSubtitle,
      },
      onTap: enabled && !busy ? onUpload : null,
      trailing: busy
          ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
          : document != null
              ? IconButton(
                  tooltip: l10n.delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: enabled ? () => onDelete(document) : null,
                )
              : Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                  child: Text(l10n.upload, style: context.textTheme.labelMedium?.copyWith(color: context.colors.primary)),
                ),
    );
  }
}

typedef _Missing = ({String label, CompanyStep step});

class CompanyReviewStep extends StatefulWidget {
  const CompanyReviewStep({super.key});

  @override
  State<CompanyReviewStep> createState() => _CompanyReviewStepState();
}

class _CompanyReviewStepState extends State<CompanyReviewStep> {
  static const _infoKeys = {
    ApiKeys.ownerName,
    ApiKeys.companyName,
    ApiKeys.branch,
    ApiKeys.address,
    ApiKeys.registrationNumber,
    ApiKeys.establishmentDate,
    ApiKeys.ns,
    ApiKeys.nif,
    ApiKeys.rib,
    ApiKeys.professionalTitle,
    ApiKeys.activity,
    ApiKeys.nationalIdNumber,
    ApiKeys.declaredIndividualActivity,
  };

  late CompanyConsents _consents;
  List<_Missing> _missing = const [];
  bool _showConsentError = false;

  @override
  void initState() {
    super.initState();
    _consents = context.read<CompanyCubit>().state.profile?.consents ?? const CompanyConsents();
  }

  void _submit() {
    if (!_consents.all) {
      setState(() => _showConsentError = true);
      return;
    }
    setState(() => _missing = const []);
    context.read<CompanyCubit>().submit(_consents);
  }

  void _onFailed(BuildContext context, CompanyState state) {
    final failure = state.failure;
    final l10n = context.l10n;
    if (failure is ValidationFailure) {
      final details = failure.details;
      final missing = <_Missing>[
        if (details.containsKey(ApiKeys.businessType)) (label: l10n.companyStepType, step: CompanyStep.type),
        if (details.keys.any(_infoKeys.contains)) (label: l10n.companyStepInfo, step: CompanyStep.info),
        if (details.containsKey(ApiKeys.phone) || details.containsKey(ApiKeys.email))
          (label: l10n.companyStepContact, step: CompanyStep.contact),
        if (failure.missingDocuments.isNotEmpty)
          (
            label: l10n.missingDocumentsWarning(l10n.companyDocumentList([
              for (final type in failure.missingDocuments)
                CompanyDocumentType.values.where((t) => t.name == type).firstOrNull ?? CompanyDocumentType.other,
            ])),
            step: CompanyStep.documents,
          ),
      ];
      if (missing.isNotEmpty) {
        setState(() => _missing = missing);
        return;
      }
    }
    if (failure != null) showRegistrationFailure(context, failure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CompanyCubit>();
    final isSubmitting = context.select((CompanyCubit c) => c.state.isLoadingFor(CompanyAction.submit));

    final rows = <(String, bool, CompanyConsents Function(bool))>[
      (l10n.consentConfirm, _consents.confirmInformation, (v) => _consents.copyWith(confirmInformation: v)),
      (l10n.consentTerms, _consents.acceptedTerms, (v) => _consents.copyWith(acceptedTerms: v)),
      (l10n.consentPrivacy, _consents.acceptedPrivacy, (v) => _consents.copyWith(acceptedPrivacy: v)),
    ];

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => current.didFail(CompanyAction.submit) && previous.status != current.status,
      listener: _onFailed,
      child: StepBody(
        actions: StepActions(
          isLoading: isSubmitting,
          onBack: cubit.back,
          onNext: _submit,
          nextLabel: l10n.submitForReview,
        ),
        children: [
          if (_missing.isNotEmpty)
            Container(
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
                  for (final item in _missing)
                    Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(child: Text(item.label, style: context.textTheme.bodySmall)),
                        TextButton(onPressed: () => cubit.goTo(item.step), child: Text(l10n.fix)),
                      ],
                    ),
                ],
              ),
            ),
          SectionTitle(l10n.consentsTitle),
          for (final (label, value, update) in rows)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(label, style: context.textTheme.bodyMedium),
              value: value,
              onChanged: (v) => setState(() {
                _consents = update(v ?? false);
                if (_consents.all) _showConsentError = false;
              }),
            ),
          TextButton(
            onPressed: () => setState(() {
              _consents = CompanyConsents.allAccepted;
              _showConsentError = false;
            }),
            child: Text(l10n.acceptAll),
          ),
          if (_showConsentError)
            Text(l10n.acceptAllConsents, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error)),
        ],
      ),
    );
  }
}
