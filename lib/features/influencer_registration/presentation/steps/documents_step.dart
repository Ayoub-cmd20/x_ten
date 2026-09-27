import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../domain/models/influencer_document.dart';
import '../../domain/models/influencer_registration_draft.dart';

class DocumentsStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const DocumentsStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<DocumentsStep> createState() => _DocumentsStepState();
}

class _DocumentsStepState extends State<DocumentsStep> {
  static const Color gold = Color(0xFFE5C158);

  InfluencerDocument? _findDocument(
      InfluencerDocumentType type,
      ) {
    for (final document in widget.draft.documents) {
      if (document.type == type) {
        return document;
      }
    }
    return null;
  }

  Future<void> _pickDocument(
      InfluencerDocumentType type,
      ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
      ],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.first;

    if (file.path == null) return;

    final document = InfluencerDocument(
      id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      fileName: file.name,
      filePath: file.path!,
      uploaded: true,
      verified: false,
    );

    setState(() {
      widget.draft.documents.removeWhere(
            (item) => item.type == type,
      );
      widget.draft.documents.add(document);
    });

    widget.onChanged();
  }

  void _removeDocument(InfluencerDocumentType type) {
    setState(() {
      widget.draft.documents.removeWhere(
            (item) => item.type == type,
      );
    });

    widget.onChanged();
  }

  Widget _documentCard({
    required InfluencerDocumentType type,
    required String helper,
  }) {
    final document = _findDocument(type);
    final uploaded = document != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: uploaded
              ? Colors.green.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: uploaded
                  ? Colors.green.withValues(alpha: 0.10)
                  : gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              uploaded
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_file_rounded,
              color: uploaded ? Colors.green : gold,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.arabicName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  uploaded ? document.fileName : helper,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          if (uploaded)
            IconButton(
              tooltip: 'حذف',
              onPressed: () => _removeDocument(type),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
            ),

          IconButton(
            tooltip: uploaded ? 'تغيير' : 'رفع',
            onPressed: () => _pickDocument(type),
            icon: Icon(
              uploaded
                  ? Icons.refresh_rounded
                  : Icons.add_circle_outline_rounded,
              color: gold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final financialType =
    widget.draft.paymentType.name == 'bank'
        ? InfluencerDocumentType.bankRib
        : InfluencerDocumentType.ccpCheque;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'رفع الوثائق',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'ارفع صوراً واضحة أو ملفات PDF. سيتم التأكد من الوثائق أثناء اجتماع التوثيق.',
          style: TextStyle(
            color: Colors.white54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        _documentCard(
          type: InfluencerDocumentType.identityFront,
          helper: 'الوجه الأمامي لبطاقة التعريف',
        ),

        _documentCard(
          type: InfluencerDocumentType.identityBack,
          helper: 'الوجه الخلفي لبطاقة التعريف',
        ),

        _documentCard(
          type: financialType,
          helper: financialType == InfluencerDocumentType.bankRib
              ? 'ارفع RIB البنكي'
              : 'ارفع Chèque CCP barré',
        ),
      ],
    );
  }
}