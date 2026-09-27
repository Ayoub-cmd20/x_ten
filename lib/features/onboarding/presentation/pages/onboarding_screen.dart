import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
  });

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF151515);

  final PageController _pageController =
  PageController();

  int _currentPage = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      icon: Icons.campaign_outlined,
      title: 'فرص حقيقية لصناع المحتوى',
      subtitle:
      'اكتشف حملات وإعلانات وفرص تعاون مع العلامات التجارية المناسبة لمحتواك وجمهورك.',
      englishTitle:
      'Discover real opportunities',
    ),
    _OnboardingItem(
      icon: Icons.handshake_outlined,
      title: 'تعاون احترافي وآمن',
      subtitle:
      'تواصل مع الشركات، أدر حملاتك، تابع المشاريع والمدفوعات من مكان واحد.',
      englishTitle:
      'Professional collaborations',
    ),
    _OnboardingItem(
      icon: Icons.auto_graph_rounded,
      title: 'نمِّ حضورك وأعمالك',
      subtitle:
      'سواء كنت صانع محتوى، مستقلاً أو علامة تجارية، X Ten يساعدك على بناء علاقات وفرص أفضل.',
      englishTitle:
      'Grow with X Ten',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage <
        _items.length - 1) {
      _pageController.nextPage(
        duration:
        const Duration(
          milliseconds: 320,
        ),
        curve:
        Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previous() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration:
        const Duration(
          milliseconds: 320,
        ),
        curve:
        Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    // Change this route to your real account type route.
    context.go(
      '/login',
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final isLastPage =
        _currentPage ==
            _items.length - 1;

    return Directionality(
      textDirection:
      TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        background,

        body: SafeArea(
          child: Column(
            children: [
              // =====================================================
              // TOP BAR
              // =====================================================

              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  0,
                ),

                child: Row(
                  children: [
                    if (_currentPage >
                        0)
                      IconButton(
                        onPressed:
                        _previous,
                        icon:
                        const Icon(
                          Icons
                              .arrow_forward_ios_rounded,
                          color:
                          Colors.white70,
                        ),
                      )
                    else
                      const SizedBox(
                        width:
                        48,
                      ),

                    const Spacer(),

                    TextButton(
                      onPressed:
                      _skip,
                      child:
                      const Text(
                        'تخطي',
                        style:
                        TextStyle(
                          color:
                          Colors.white54,
                          fontSize:
                          14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // PAGE CONTENT
              // =====================================================

              Expanded(
                child:
                PageView.builder(
                  controller:
                  _pageController,

                  itemCount:
                  _items.length,

                  onPageChanged:
                      (index) {
                    setState(
                          () {
                        _currentPage =
                            index;
                      },
                    );
                  },

                  itemBuilder:
                      (
                      context,
                      index,
                      ) {
                    final item =
                    _items[index];

                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal:
                        28,
                      ),

                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                        children: [
                          // =========================================
                          // ILLUSTRATION
                          // =========================================

                          Container(
                            width:
                            220,
                            height:
                            220,

                            decoration:
                            BoxDecoration(
                              shape:
                              BoxShape.circle,

                              gradient:
                              RadialGradient(
                                colors: [
                                  gold.withValues(
                                    alpha:
                                    0.20,
                                  ),
                                  gold.withValues(
                                    alpha:
                                    0.05,
                                  ),
                                  Colors
                                      .transparent,
                                ],
                              ),
                            ),

                            child:
                            Center(
                              child:
                              Container(
                                width:
                                125,
                                height:
                                125,

                                decoration:
                                BoxDecoration(
                                  color:
                                  surface,
                                  borderRadius:
                                  BorderRadius.circular(
                                    35,
                                  ),
                                  border:
                                  Border.all(
                                    color:
                                    gold.withValues(
                                      alpha:
                                      0.35,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      gold.withValues(
                                        alpha:
                                        0.10,
                                      ),
                                      blurRadius:
                                      35,
                                      spreadRadius:
                                      4,
                                    ),
                                  ],
                                ),

                                child:
                                Icon(
                                  item.icon,
                                  color:
                                  gold,
                                  size:
                                  58,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height:
                            45,
                          ),

                          // =========================================
                          // TITLE
                          // =========================================

                          Text(
                            item.title,
                            textAlign:
                            TextAlign.center,
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize:
                              25,
                              fontWeight:
                              FontWeight.w900,
                              height:
                              1.35,
                            ),
                          ),

                          const SizedBox(
                            height:
                            8,
                          ),

                          Text(
                            item.englishTitle,
                            textAlign:
                            TextAlign.center,
                            style:
                            const TextStyle(
                              color:
                              gold,
                              fontSize:
                              13,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),

                          const SizedBox(
                            height:
                            18,
                          ),

                          Text(
                            item.subtitle,
                            textAlign:
                            TextAlign.center,
                            style:
                            const TextStyle(
                              color:
                              Colors.white60,
                              fontSize:
                              15,
                              height:
                              1.8,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // =====================================================
              // INDICATORS
              // =====================================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children:
                List.generate(
                  _items.length,
                      (
                      index,
                      ) {
                    final selected =
                        index ==
                            _currentPage;

                    return AnimatedContainer(
                      duration:
                      const Duration(
                        milliseconds:
                        220,
                      ),

                      margin:
                      const EdgeInsets.symmetric(
                        horizontal:
                        4,
                      ),

                      width:
                      selected
                          ? 26
                          : 8,

                      height:
                      8,

                      decoration:
                      BoxDecoration(
                        color:
                        selected
                            ? gold
                            : Colors
                            .white24,
                        borderRadius:
                        BorderRadius.circular(
                          50,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height:
                26,
              ),

              // =====================================================
              // NEXT BUTTON
              // =====================================================

              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  24,
                ),

                child:
                SizedBox(
                  width:
                  double.infinity,

                  child:
                  ElevatedButton(
                    onPressed:
                    _next,

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      gold,
                      foregroundColor:
                      Colors.black,
                      minimumSize:
                      const Size.fromHeight(
                        56,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),

                    child:
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                      children: [
                        Text(
                          isLastPage
                              ? 'ابدأ الآن'
                              : 'التالي',
                          style:
                          const TextStyle(
                            fontSize:
                            16,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),

                        const SizedBox(
                          width:
                          8,
                        ),

                        Icon(
                          isLastPage
                              ? Icons
                              .rocket_launch_outlined
                              : Icons
                              .arrow_back_ios_new_rounded,
                          size:
                          18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String englishTitle;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.englishTitle,
  });
}