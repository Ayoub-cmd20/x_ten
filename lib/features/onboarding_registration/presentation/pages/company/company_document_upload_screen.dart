import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:x_ten/features/onboarding_registration/presentation/pages/company/company_review_confirm_screen.dart';

class CompanyDocumentUploadScreen extends StatefulWidget {
  const CompanyDocumentUploadScreen({super.key});

  @override
  State<CompanyDocumentUploadScreen> createState() =>
      _CompanyDocumentUploadScreenState();
}

class _DocItem {
  final String title;
  final String subtitle;
  final IconData icon;
  bool isUploaded;
  String? fileName;

  _DocItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isUploaded = false,
    this.fileName,
  });
}

class _CompanyDocumentUploadScreenState
    extends State<CompanyDocumentUploadScreen> {
  late final List<_DocItem> _docs;
  String? _additionalDocName;

  @override
  void initState() {
    super.initState();
    _docs = [
      _DocItem(
        title: 'البطاقة الوطنية / جواز السفر',
        subtitle: 'بطاقة الهوية / جواز السفر',
        icon: Icons.badge_outlined,
        isUploaded: true,
        fileName: 'director_id_scan...',
      ),
      _DocItem(
        title: 'السجل التجاري',
        subtitle: 'السجل التجاري',
        icon: Icons.description_outlined,
      ),
      _DocItem(
        title: 'ختم الشركة',
        subtitle: 'ختم الشركة',
        icon: Icons.soap,
      ),
      _DocItem(
        title: 'شيك ملغى',
        subtitle: 'شيك ملغى',
        icon: Icons.account_balance_outlined,
      ),
    ];
  }

  void _simulateUpload(int index) {
    setState(() {
      _docs[index].isUploaded = true;
      _docs[index].fileName = 'document_${index + 1}.pdf';
    });
  }

  void _removeUpload(int index) {
    setState(() {
      _docs[index].isUploaded = false;
      _docs[index].fileName = null;
    });
  }

  void _simulateAdditionalUpload() {
    setState(() {
      _additionalDocName = 'license_document.pdf';
    });
  }

  void _removeAdditionalUpload() {
    setState(() {
      _additionalDocName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFD4A843),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Company\nRegistration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Step info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'الخطوة 4 من 5',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '80%',
                      style: TextStyle(
                        color: Color(0xFFD4A843),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Progress bar (step 4 / 5 = 80%)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.8,
                    backgroundColor: const Color(0xFF2A2A2A),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFD4A843),
                    ),
                    minHeight: 6,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title & Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'رفع المستندات',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'يرجى تقديم المستندات المطلوبة للشركة. الصيغ المدعومة: PDF، JPG، PNG (بحد أقصى 5 ميغابايت لكل منها).',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Documents List
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ..._docs.asMap().entries.map((entry) {
                        final index = entry.key;
                        final doc = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDocumentCard(doc, index),
                        );
                      }),
                      const SizedBox(height: 12),
                      _buildAdditionalDocCard(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Buttons
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'السابق',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CompanyReviewConfirmScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A843),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'الخطوة التالية',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(_DocItem doc, int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(16),
        border: doc.isUploaded
            ? Border.all(
          color: const Color(0xFFD4A843).withValues(alpha: 0.4),
          width: 1.5,
        )
            : null,
      ),
      child: _DashedBorder(
        color: doc.isUploaded ? Colors.transparent : const Color(0xFF3A3A3A),
        dashWidth: doc.isUploaded ? 0 : 6,
        dashSpace: doc.isUploaded ? 0 : 4,
        borderRadius: 16,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      doc.icon,
                      color: const Color(0xFFD4A843),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          doc.subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(doc.isUploaded),
                ],
              ),

              // File info or Upload button
              if (doc.isUploaded) ...[
                const SizedBox(height: 12),
                Divider(
                  color: Colors.white.withValues(alpha: 0.08),
                  height: 1,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doc.fileName!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeUpload(index),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFFF6B6B),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _simulateUpload(index),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.upload_file,
                        color: Color(0xFFD4A843),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'انقر للرفع',
                        style: TextStyle(
                          color: const Color(0xFFD4A843).withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalDocCard() {
    if (_additionalDocName != null) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4A843).withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFFD4A843),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'مستند ترخيص إضافي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _additionalDocName!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _removeAdditionalUpload,
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFFF6B6B),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _DashedBorder(
      color: const Color(0xFF3A3A3A),
      dashWidth: 6,
      dashSpace: 4,
      borderRadius: 16,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _simulateAdditionalUpload,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 28,
                ),
                const SizedBox(height: 8),
                const Text(
                  'إضافة مستند ترخيص إضافي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'رفع PDF اختياري',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isUploaded) {
    if (isUploaded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFD4A843).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: const Color(0xFFD4A843).withValues(alpha: 0.9),
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              'تم الرفع',
              style: TextStyle(
                color: const Color(0xFFD4A843).withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.pending_outlined,
            color: Colors.white.withValues(alpha: 0.5),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            'قيد الانتظار',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom dashed border painter
class _DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  const _DashedBorder({
    required this.child,
    this.color = const Color(0xFF3A3A3A),
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dashWidth <= 0) return;

    const double strokeWidth = 1;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final dashPath = Path();
    double distance = 0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}