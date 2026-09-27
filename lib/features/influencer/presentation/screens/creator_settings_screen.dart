import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatorSettingsScreen extends StatefulWidget {
  const CreatorSettingsScreen({
    super.key,
  });

  @override
  State<CreatorSettingsScreen> createState() =>
      _CreatorSettingsScreenState();
}

class _CreatorSettingsScreenState
    extends State<CreatorSettingsScreen> {
  static const gold = Color(0xFFE5C158);
  static const background = Color(0xFF0A0A0A);

  bool notifications = true;
  bool emailNotifications = true;
  bool smsNotifications = false;
  bool whatsappNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          title: const Text(
            'الإعدادات',
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _section(
              title: 'الحساب',
              children: [
                _item(
                  icon: Icons.person_outline,
                  title: 'تعديل الملف الشخصي',
                ),

                _item(
                  icon: Icons.lock_outline,
                  title: 'الأمان وكلمة المرور',
                ),

                _item(
                  icon: Icons.account_balance_outlined,
                  title: 'المعلومات المالية',
                ),

                _item(
                  icon: Icons.verified_user_outlined,
                  title: 'حالة التوثيق',
                ),
              ],
            ),

            const SizedBox(height: 16),

            _section(
              title: 'الإشعارات',
              children: [
                SwitchListTile(
                  value: notifications,
                  activeThumbColor: gold,
                  title: const Text(
                    'إشعارات التطبيق',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),

                SwitchListTile(
                  value: emailNotifications,
                  activeThumbColor: gold,
                  title: const Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      emailNotifications = value;
                    });
                  },
                ),

                SwitchListTile(
                  value: smsNotifications,
                  activeThumbColor: gold,
                  title: const Text(
                    'SMS',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      smsNotifications = value;
                    });
                  },
                ),

                SwitchListTile(
                  value: whatsappNotifications,
                  activeThumbColor: gold,
                  title: const Text(
                    'WhatsApp',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      whatsappNotifications =
                          value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            _section(
              title: 'X Ten',
              children: [
                _item(
                  icon: Icons.description_outlined,
                  title: 'الشروط والأحكام',
                ),

                _item(
                  icon: Icons.privacy_tip_outlined,
                  title: 'سياسة الخصوصية',
                ),

                _item(
                  icon: Icons.help_outline,
                  title: 'مركز المساعدة',
                ),
              ],
            ),

            const SizedBox(height: 22),

            OutlinedButton.icon(
              onPressed: () {
                context.go('/login');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              label: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.all(16),
            child: Align(
              alignment:
              Alignment.centerRight,
              child: Text(
                title,
                style:
                const TextStyle(
                  color: gold,
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: gold,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white24,
        size: 14,
      ),
      onTap: () {},
    );
  }
}