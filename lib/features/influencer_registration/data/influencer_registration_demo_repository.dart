import 'dart:async';

import '../domain/models/influencer_document.dart';
import '../domain/models/influencer_registration.dart';
import '../domain/models/verification_status.dart';

import 'influencer_registration_repository.dart';

class InfluencerRegistrationDemoRepository
    implements
        InfluencerRegistrationRepository {
  InfluencerRegistration? _draft;

  InfluencerRegistration?
  _submittedRegistration;

  InfluencerVerificationStatus
  _verificationStatus =
      InfluencerVerificationStatus.draft;

  final List<InfluencerDocument>
  _uploadedDocuments = [];

  int _registrationCounter = 1;

  @override
  Future<void> saveDraft(
      InfluencerRegistration registration,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
    );

    _draft = registration.copyWith(
      verificationStatus:
      InfluencerVerificationStatus.draft,
    );
  }

  @override
  Future<InfluencerRegistration?>
  getDraft() async {
    await Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    return _draft;
  }

  @override
  Future<String> submitRegistration(
      InfluencerRegistration registration,
      ) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final registrationId =
        'INF-REG-${_registrationCounter.toString().padLeft(5, '0')}';

    _registrationCounter++;

    _verificationStatus =
        InfluencerVerificationStatus
            .submitted;

    _submittedRegistration =
        registration.copyWith(
          id: registrationId,
          registeredAt: DateTime.now(),
          verificationStatus:
          _verificationStatus,
        );

    _draft = null;

    return registrationId;
  }

  @override
  Future<InfluencerVerificationStatus>
  getVerificationStatus(
      String registrationId,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 400,
      ),
    );

    if (_submittedRegistration == null ||
        _submittedRegistration!.id !=
            registrationId) {
      return InfluencerVerificationStatus
          .draft;
    }

    return _verificationStatus;
  }

  @override
  Future<String> uploadProfileImage(
      String localFilePath,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 800,
      ),
    );

    if (localFilePath.trim().isEmpty) {
      throw Exception(
        'Profile image path is empty.',
      );
    }

    // Demo only.
    // لاحقاً سيتم استبداله برابط Firebase/Supabase/API.
    return localFilePath;
  }

  @override
  Future<InfluencerDocument>
  uploadDocument(
      InfluencerDocument document,
      ) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    final uploadedDocument =
    document.copyWith(
      uploaded: true,
    );

    _uploadedDocuments.removeWhere(
          (item) =>
      item.id ==
          uploadedDocument.id,
    );

    _uploadedDocuments.add(
      uploadedDocument,
    );

    return uploadedDocument;
  }

  @override
  Future<void> deleteDocument(
      String documentId,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 400,
      ),
    );

    _uploadedDocuments.removeWhere(
          (document) =>
      document.id ==
          documentId,
    );
  }

  @override
  Future<void> updateRegistration(
      InfluencerRegistration registration,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 600,
      ),
    );

    if (_submittedRegistration?.id ==
        registration.id) {
      _submittedRegistration =
          registration;
    } else {
      _draft = registration;
    }
  }

  @override
  Future<void> cancelRegistration(
      String registrationId,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

    if (_submittedRegistration?.id ==
        registrationId) {
      _submittedRegistration = null;

      _verificationStatus =
          InfluencerVerificationStatus
              .draft;
    }
  }

  // =========================================================
  // DEMO HELPERS
  // =========================================================
  //
  // هذه الدوال ليست ضمن الـ Repository interface.
  // مفيدة فقط أثناء تطوير التطبيق لاختبار الحالات المختلفة.
  // =========================================================

  Future<void> demoSetUnderReview() async {
    await Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
    );

    _setVerificationStatus(
      InfluencerVerificationStatus
          .underReview,
    );
  }

  Future<void>
  demoRequireMeeting() async {
    await Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
    );

    _setVerificationStatus(
      InfluencerVerificationStatus
          .meetingRequired,
    );
  }

  Future<void>
  demoScheduleMeeting() async {
    await Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
    );

    _setVerificationStatus(
      InfluencerVerificationStatus
          .meetingScheduled,
    );
  }

  Future<void> demoVerify() async {
    await Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
    );

    _setVerificationStatus(
      InfluencerVerificationStatus
          .verified,
    );
  }

  Future<void>
  demoRequestChanges() async {
    await Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
    );

    _setVerificationStatus(
      InfluencerVerificationStatus
          .needsChanges,
    );
  }

  Future<void> demoReject() async {
    await Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
    );

    _setVerificationStatus(
      InfluencerVerificationStatus
          .rejected,
    );
  }

  void _setVerificationStatus(
      InfluencerVerificationStatus status,
      ) {
    _verificationStatus = status;

    if (_submittedRegistration != null) {
      _submittedRegistration =
          _submittedRegistration!.copyWith(
            verificationStatus: status,
          );
    }
  }
}