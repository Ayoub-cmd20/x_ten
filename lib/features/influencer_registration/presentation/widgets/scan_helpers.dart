import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/utils/upload_file.dart';

/// رموز أخطاء القراءة الآلية (من السيرفر)
abstract final class ScanErrors {
  static const documentUnrecognized = 'document_unrecognized';
  static const screenshotUnrecognized = 'screenshot_unrecognized';
  static const ocrUnavailable = 'ocr_unavailable';
  static const accountIncomplete = 'account_incomplete';
}

/// الصورة ماشي الوثيقة/اللقطة المطلوبة (أو ما تقراتش)
bool isUnrecognized(Failure failure) =>
    failure.code == ScanErrors.documentUnrecognized || failure.code == ScanErrors.screenshotUnrecognized;

/// السيرفر ما فيهش القراءة الآلية: الإدخال يدوي
bool isOcrUnavailable(Failure failure) => failure.code == ScanErrors.ocrUnavailable;

/// الحقول اللي قراها السيرفر لما القراءة ناقصة (مثلاً الصك بلا اسم المؤسسة)
Map<String, dynamic> partialFields(Failure failure) => switch (failure) {
      ServerFailure(code: ScanErrors.accountIncomplete, :final details) => switch (details['fields']) {
          final Map<String, dynamic> fields => fields,
          _ => const {},
        },
      _ => const {},
    };

/// بعد 3 محاولات: نبعثو الوثيقة كيما هي وتتراجع يدوياً في الاجتماع؟
Future<bool> confirmManualReview(BuildContext context) async {
  final l10n = context.l10n;
  final accepted = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.docAcceptUnreadableTitle),
      content: Text(l10n.docAcceptUnreadableBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(l10n.docSendForReview)),
      ],
    ),
  );
  return accepted ?? false;
}

/// عدة لقطات شاشة من المعرض
Future<List<UploadFile>> pickScreenshots() async {
  final images = await ImagePicker().pickMultiImage(maxWidth: 2000, imageQuality: 90);
  return [
    for (final image in images) UploadFile(path: image.path, name: image.name, size: await File(image.path).length()),
  ];
}

/// لقطة شاشة وحدة من المعرض
Future<UploadFile?> pickScreenshot() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 2000, imageQuality: 90);
  if (image == null) return null;
  return UploadFile(path: image.path, name: image.name, size: await File(image.path).length());
}
