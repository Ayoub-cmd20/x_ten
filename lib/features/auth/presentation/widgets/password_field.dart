import 'package:flutter/material.dart';
import 'package:x_ten/core/localization/localization_extension.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.autofillHints = const [AutofillHints.password],
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? errorText;
  final Iterable<String> autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        obscureText: _obscure,
        enableSuggestions: false,
        autocorrect: false,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        forceErrorText: widget.errorText,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onFieldSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            tooltip: _obscure ? context.l10n.showPassword : context.l10n.hidePassword,
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          ),
        ),
      );
}
