import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/models/freelancer_document.dart';
import '../../domain/models/freelancer_registration.dart';
import '../../domain/models/freelancer_registration_draft.dart';

class DocumentsStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
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
  FreelancerDocument? _findDocument(
      FreelancerDocumentType type,
      ) {
    for (final document in widget.draft.documents) {
      if (document.type == type) {
        return document;
      }
    }

    return null;
  }

  Future<void> _pickDocument(
      FreelancerDocumentType type,
      bool required,
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

    if (result?.files.first.path == null) {
      return;
    }

    final file = result!.files.first;

    setState(() {
      widget.draft.documents.removeWhere(
            (document) => document.type == type,
      );

      widget.draft.documents.add(
        FreelancerDocument(
          id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
          type: type,
          fileName: file.name,
          filePath: file.path!,
          required: required,
        ),
      );
    });

    widget.onChanged();
  }

  Widget _buildDocumentCard(
      FreelancerDocumentType type,
      bool required,
      ) {
    final document = _findDocument(type);

    return Card(
      color: const Color(0xFF151515),
      child: ListTile(
        title: Text(
          type.arabicName,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          document?.fileName ??
              (required ? 'مطلوب' : 'اختياري'),
        ),
        trailing: IconButton(
          onPressed: () {
            _pickDocument(
              type,
              required,
            );
          },
          icon: const Icon(
            Icons.upload_file,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final financialDocument =
    widget.draft.paymentType ==
        FreelancerPaymentType.bank
        ? FreelancerDocumentType.bankRib
        : FreelancerDocumentType.ccpCheque;

    return Column(
      children: [
        _buildDocumentCard(
          FreelancerDocumentType.identityFront,
          true,
        ),

        _buildDocumentCard(
          FreelancerDocumentType.identityBack,
          true,
        ),

        _buildDocumentCard(
          financialDocument,
          true,
        ),

        _buildDocumentCard(
          FreelancerDocumentType.cv,
          false,
        ),

        _buildDocumentCard(
          FreelancerDocumentType.certificate,
          false,
        ),

        _buildDocumentCard(
          FreelancerDocumentType.diploma,
          false,
        ),
      ],
    );
  }
}