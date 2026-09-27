import 'package:flutter/material.dart';

class CreatorProjectDetailsScreen extends StatelessWidget {
  final String title;
  final String brand;
  final String status;
  final double progress;
  final String deadline;
  final String amount;
  final String deliverables;

  const CreatorProjectDetailsScreen({
    super.key,
    required this.title,
    required this.brand,
    required this.status,
    required this.progress,
    required this.deadline,
    required this.amount,
    required this.deliverables,
  });

  static const gold = Color(0xFFE5C158);
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF151515);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          title: const Text(
            'إدارة المشروع',
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    brand,
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: gold.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius:
                      BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: gold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _ProjectInfo(
              icon: Icons.payments_outlined,
              title: 'قيمة العقد',
              value: amount,
            ),

            _ProjectInfo(
              icon: Icons.schedule_outlined,
              title: 'الموعد',
              value: deadline,
            ),

            _ProjectInfo(
              icon: Icons.task_outlined,
              title: 'المحتوى المطلوب',
              value: deliverables,
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تقدم المشروع',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 14),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor:
                    const Color(0xFF292929),
                    color: gold,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      color: gold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'مراحل التنفيذ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 10),

            const _TaskItem(
              title: 'تأكيد تفاصيل الحملة',
              completed: true,
            ),

            const _TaskItem(
              title: 'إعداد المحتوى',
              completed: true,
            ),

            const _TaskItem(
              title: 'إرسال المحتوى للمراجعة',
              completed: false,
            ),

            const _TaskItem(
              title: 'موافقة العميل',
              completed: false,
            ),

            const _TaskItem(
              title: 'النشر',
              completed: false,
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'سيتم إضافة رفع الملفات في المرحلة التالية',
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.upload_file_outlined,
              ),
              label: const Text(
                'رفع المحتوى',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: Colors.black,
                minimumSize:
                const Size.fromHeight(54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProjectInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF151515),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFE5C158),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final String title;
  final bool completed;

  const _TaskItem({
    required this.title,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        completed
            ? Icons.check_circle
            : Icons.radio_button_unchecked,
        color: completed
            ? Colors.green
            : Colors.white24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}