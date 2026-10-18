import 'package:flutter/material.dart';

import 'package:x_ten/features/campaigns/data/promotion_requests_demo_data.dart';
import 'package:x_ten/features/campaigns/domain/models/promotion_request.dart';

class MyPromotionRequestsScreen extends StatefulWidget {
  const MyPromotionRequestsScreen({super.key});

  @override
  State<MyPromotionRequestsScreen> createState() =>
      _MyPromotionRequestsScreenState();
}

class _MyPromotionRequestsScreenState
    extends State<MyPromotionRequestsScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);

  PromotionRequestStatus? _filter;

  List<PromotionRequest> get _requests {
    if (_filter == null) {
      return demoPromotionRequests;
    }

    return demoPromotionRequests
        .where((request) => request.status == _filter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'طلبات الترويج الخاصة بي',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),

            // FILTERS
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _filterChip(
                    label: 'الكل',
                    selected: _filter == null,
                    onTap: () {
                      setState(() {
                        _filter = null;
                      });
                    },
                  ),
                  _filterChip(
                    label: 'قيد الانتظار',
                    selected:
                    _filter == PromotionRequestStatus.pending,
                    onTap: () {
                      setState(() {
                        _filter = PromotionRequestStatus.pending;
                      });
                    },
                  ),
                  _filterChip(
                    label: 'قيد المراجعة',
                    selected:
                    _filter == PromotionRequestStatus.underReview,
                    onTap: () {
                      setState(() {
                        _filter =
                            PromotionRequestStatus.underReview;
                      });
                    },
                  ),
                  _filterChip(
                    label: 'مقبول',
                    selected:
                    _filter == PromotionRequestStatus.accepted,
                    onTap: () {
                      setState(() {
                        _filter = PromotionRequestStatus.accepted;
                      });
                    },
                  ),
                  _filterChip(
                    label: 'مرفوض',
                    selected:
                    _filter == PromotionRequestStatus.rejected,
                    onTap: () {
                      setState(() {
                        _filter = PromotionRequestStatus.rejected;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: _requests.isEmpty
                  ? const _EmptyRequests()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  24,
                ),
                itemCount: _requests.length,
                separatorBuilder: (_, _) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _PromotionRequestCard(
                    request: _requests[index],
                    onTap: () {
                      _showRequestDetails(
                        _requests[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) => onTap(),
        selectedColor: _gold,
        backgroundColor: const Color(0xFF161616),
        side: BorderSide(
          color: selected
              ? _gold
              : Colors.white.withValues(alpha: 0.08),
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showRequestDetails(
      PromotionRequest request,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171717),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  Text(
                    request.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    request.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _detailRow(
                    'رقم الطلب',
                    request.id,
                  ),

                  _detailRow(
                    'الميزانية',
                    '${request.budget.toStringAsFixed(0)} دج',
                  ),

                  _detailRow(
                    'عدد المرفقات',
                    '${request.attachmentsCount}',
                  ),

                  _detailRow(
                    'الحالة',
                    _statusLabel(request.status),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _gold,
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                      child: const Text(
                        'إغلاق',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(
      PromotionRequestStatus status,
      ) {
    switch (status) {
      case PromotionRequestStatus.pending:
        return 'قيد الانتظار';
      case PromotionRequestStatus.underReview:
        return 'قيد المراجعة';
      case PromotionRequestStatus.accepted:
        return 'مقبول';
      case PromotionRequestStatus.rejected:
        return 'مرفوض';
    }
  }
}

class _PromotionRequestCard extends StatelessWidget {
  final PromotionRequest request;
  final VoidCallback onTap;

  const _PromotionRequestCard({
    required this.request,
    required this.onTap,
  });

  static const Color gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1B1B1B),
                Color(0xFF121212),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: gold.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.title,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusBadge(
                    status: request.status,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                request.description,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    color: gold,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${request.budget.toStringAsFixed(0)} دج',
                    style:
                    const TextStyle(
                      color: Colors.white70,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.attach_file_rounded,
                    color: Colors.white38,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${request.attachmentsCount}',
                    style:
                    const TextStyle(
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PromotionRequestStatus status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    switch (status) {
      case PromotionRequestStatus.pending:
        color = Colors.orange;
        label = 'قيد الانتظار';
        break;
      case PromotionRequestStatus.underReview:
        color = Colors.blue;
        label = 'قيد المراجعة';
        break;
      case PromotionRequestStatus.accepted:
        color = Colors.green;
        label = 'مقبول';
        break;
      case PromotionRequestStatus.rejected:
        color = Colors.redAccent;
        label = 'مرفوض';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'لا توجد طلبات ترويج',
        style: TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }
}