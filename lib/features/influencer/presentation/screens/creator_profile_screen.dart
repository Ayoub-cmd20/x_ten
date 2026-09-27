import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatorProfileScreen extends StatelessWidget {
  const CreatorProfileScreen({
    super.key,
  });

  static const Color gold =
  Color(0xFFE5C158);

  static const Color background =
  Color(0xFF0A0A0A);

  static const Color surface =
  Color(0xFF151515);

  @override
  Widget build(
      BuildContext context,
      ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,

          title: const Text(
            'الملف الشخصي',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          actions: [
            IconButton(
              onPressed: () {
                context.push(
                  '/creator/settings',
                );
              },
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),

        body: ListView(
          padding:
          const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            100,
          ),
          children: [
            _buildProfileHeader(),

            const SizedBox(
              height: 20,
            ),

            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '125K',
                    title: 'المتابعون',
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: _StatCard(
                    value: '4.9',
                    title: 'التقييم',
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: _StatCard(
                    value: '38',
                    title: 'حملة',
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            _section(
              'نبذة عني',
              const Text(
                'صانع محتوى متخصص في التكنولوجيا ونمط الحياة، أعمل مع العلامات التجارية لإنشاء محتوى أصلي وفعال.',
                style: TextStyle(
                  color:
                  Colors.white60,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            _section(
              'منصاتي',
              const Column(
                children: [
                  _SocialRow(
                    name:
                    'Instagram',
                    username:
                    '@creator',
                    followers:
                    '65K',
                    icon: Icons
                        .camera_alt_outlined,
                  ),

                  _SocialRow(
                    name:
                    'TikTok',
                    username:
                    '@creator',
                    followers:
                    '42K',
                    icon: Icons
                        .play_circle_outline,
                  ),

                  _SocialRow(
                    name:
                    'YouTube',
                    username:
                    'Creator Channel',
                    followers:
                    '18K',
                    icon: Icons
                        .video_library_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            _section(
              'أداء الحساب',
              const Column(
                children: [
                  _PerformanceItem(
                    title:
                    'إكمال الحملات',
                    value:
                    '96%',
                  ),

                  _PerformanceItem(
                    title:
                    'التسليم في الموعد',
                    value:
                    '94%',
                  ),

                  _PerformanceItem(
                    title:
                    'إعادة التعاون',
                    value:
                    '82%',
                  ),

                  _PerformanceItem(
                    title:
                    'معدل الاستجابة',
                    value:
                    '98%',
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            _section(
              'معرض الأعمال',
              Column(
                children: [
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children:
                    List.generate(
                      6,
                          (index) {
                        return InkWell(
                          onTap: () {
                            context.push(
                              '/creator/portfolio',
                            );
                          },
                          borderRadius:
                          BorderRadius
                              .circular(
                            12,
                          ),
                          child:
                          Container(
                            decoration:
                            BoxDecoration(
                              color:
                              const Color(
                                0xFF202020,
                              ),
                              borderRadius:
                              BorderRadius
                                  .circular(
                                12,
                              ),
                            ),
                            child:
                            const Icon(
                              Icons
                                  .image_outlined,
                              color:
                              Colors
                                  .white24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  SizedBox(
                    width:
                    double.infinity,
                    child:
                    OutlinedButton
                        .icon(
                      onPressed: () {
                        context.push(
                          '/creator/portfolio',
                        );
                      },
                      icon:
                      const Icon(
                        Icons
                            .collections_outlined,
                      ),
                      label:
                      const Text(
                        'عرض وإدارة Portfolio',
                      ),
                      style:
                      OutlinedButton
                          .styleFrom(
                        foregroundColor:
                        gold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            _section(
              'إعدادات الحساب',
              Column(
                children: [
                  _MenuItem(
                    icon:
                    Icons.edit_outlined,
                    title:
                    'تعديل الملف الشخصي',
                    onTap: () {
                      ScaffoldMessenger
                          .of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'سيتم إضافة شاشة تعديل الملف الشخصي لاحقاً',
                            textDirection:
                            TextDirection
                                .rtl,
                          ),
                        ),
                      );
                    },
                  ),

                  _MenuItem(
                    icon: Icons
                        .collections_outlined,
                    title:
                    'إدارة Portfolio',
                    onTap: () {
                      context.push(
                        '/creator/portfolio',
                      );
                    },
                  ),

                  _MenuItem(
                    icon: Icons
                        .account_balance_outlined,
                    title:
                    'المعلومات المالية',
                    onTap: () {
                      context.push(
                        '/creator/settings',
                      );
                    },
                  ),

                  _MenuItem(
                    icon: Icons
                        .notifications_outlined,
                    title:
                    'الإشعارات',
                    onTap: () {
                      context.push(
                        '/creator/settings',
                      );
                    },
                  ),

                  _MenuItem(
                    icon: Icons
                        .verified_user_outlined,
                    title:
                    'التوثيق',
                    onTap: () {
                      context.push(
                        '/creator/settings',
                      );
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

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundColor:
              Color(
                0xFF202020,
              ),
              child: Icon(
                Icons.person,
                color: gold,
                size: 54,
              ),
            ),

            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                padding:
                const EdgeInsets.all(
                  4,
                ),
                decoration:
                const BoxDecoration(
                  color:
                  Colors.green,
                  shape:
                  BoxShape.circle,
                ),
                child:
                const Icon(
                  Icons.check,
                  color:
                  Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 12,
        ),

        const Text(
          'Creator Name',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight:
            FontWeight.w900,
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        const Text(
          'Technology • Lifestyle',
          style: TextStyle(
            color: gold,
            fontSize: 12,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons
                  .location_on_outlined,
              color:
              Colors.white38,
              size: 16,
            ),

            SizedBox(
              width: 4,
            ),

            Text(
              'Algeria',
              style: TextStyle(
                color:
                Colors.white38,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _section(
      String title,
      Widget child,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          child,
        ],
      ),
    );
  }
}

class _StatCard
    extends StatelessWidget {
  final String value;
  final String title;

  const _StatCard({
    required this.value,
    required this.title,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color:
        const Color(
          0xFF151515,
        ),
        borderRadius:
        BorderRadius.circular(
          15,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style:
            const TextStyle(
              color:
              Color(
                0xFFE5C158,
              ),
              fontSize: 19,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          const SizedBox(
            height: 3,
          ),

          Text(
            title,
            style:
            const TextStyle(
              color:
              Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialRow
    extends StatelessWidget {
  final String name;
  final String username;
  final String followers;
  final IconData icon;

  const _SocialRow({
    required this.name,
    required this.username,
    required this.followers,
    required this.icon,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return ListTile(
      contentPadding:
      EdgeInsets.zero,

      leading: Icon(
        icon,
        color:
        const Color(
          0xFFE5C158,
        ),
      ),

      title: Text(
        name,
        style:
        const TextStyle(
          color: Colors.white,
        ),
      ),

      subtitle: Text(
        username,
        style:
        const TextStyle(
          color:
          Colors.white38,
        ),
      ),

      trailing: Text(
        followers,
        style:
        const TextStyle(
          color:
          Color(
            0xFFE5C158,
          ),
          fontWeight:
          FontWeight.w700,
        ),
      ),
    );
  }
}

class _PerformanceItem
    extends StatelessWidget {
  final String title;
  final String value;

  const _PerformanceItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style:
              const TextStyle(
                color:
                Colors.white60,
              ),
            ),
          ),

          Text(
            value,
            style:
            const TextStyle(
              color:
              Color(
                0xFFE5C158,
              ),
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return ListTile(
      contentPadding:
      EdgeInsets.zero,

      onTap: onTap,

      leading: Icon(
        icon,
        color:
        const Color(
          0xFFE5C158,
        ),
      ),

      title: Text(
        title,
        style:
        const TextStyle(
          color: Colors.white,
        ),
      ),

      trailing:
      const Icon(
        Icons
            .arrow_back_ios_new_rounded,
        size: 14,
        color:
        Colors.white24,
      ),
    );
  }
}