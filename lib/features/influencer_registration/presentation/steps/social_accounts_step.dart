import 'package:flutter/material.dart';

import '../../data/social_platforms_data.dart';
import '../../domain/models/influencer_registration_draft.dart';
import '../../domain/models/social_account.dart';

class SocialAccountsStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const SocialAccountsStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<SocialAccountsStep> createState() =>
      _SocialAccountsStepState();
}

class _SocialAccountsStepState extends State<SocialAccountsStep> {
  static const Color gold = Color(0xFFE5C158);

  Future<void> _openAddAccount() async {
    SocialPlatform platform = SocialPlatform.instagram;
    FacebookAccountType facebookType =
        FacebookAccountType.page;

    final urlController = TextEditingController();
    final nameController = TextEditingController();
    final usernameController = TextEditingController();
    final followersController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showModalBottomSheet<SocialAccount>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  18,
                  18,
                  18,
                  MediaQuery.of(context).viewInsets.bottom + 18,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'إضافة حساب / منصة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 18),

                      DropdownButtonFormField<SocialPlatform>(
                        initialValue: platform,
                        dropdownColor: const Color(0xFF1C1C1C),
                        decoration:
                        _sheetDecoration('المنصة'),
                        items: supportedSocialPlatforms
                            .map(
                              (item) =>
                              DropdownMenuItem<SocialPlatform>(
                                value: item.platform,
                                child: Text(
                                  item.arabicName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setSheetState(() {
                            platform = value;
                          });
                        },
                      ),

                      if (platform == SocialPlatform.facebook) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<FacebookAccountType>(
                          initialValue: facebookType,
                          dropdownColor:
                          const Color(0xFF1C1C1C),
                          decoration:
                          _sheetDecoration('نوع حساب Facebook'),
                          items: FacebookAccountType.values
                              .map(
                                (item) =>
                                DropdownMenuItem<
                                    FacebookAccountType>(
                                  value: item,
                                  child: Text(
                                    item.arabicName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                          )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setSheetState(() {
                              facebookType = value;
                            });
                          },
                        ),
                      ],

                      const SizedBox(height: 12),

                      TextField(
                        controller: urlController,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                        _sheetDecoration('رابط الصفحة / الحساب'),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                        _sheetDecoration('اسم الصفحة / الحساب'),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                        _sheetDecoration('Username - اختياري'),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: followersController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                        _sheetDecoration('عدد المتابعين'),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                        _sheetDecoration('نبذة عن هذه الصفحة'),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: gold.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Text(
                          'التحليل التلقائي للصورة والاسم وعدد المتابعين سيُربط لاحقاً مع APIs الرسمية أو Backend.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      ElevatedButton(
                        onPressed: () {
                          if (urlController.text.trim().isEmpty ||
                              nameController.text.trim().isEmpty) {
                            return;
                          }

                          Navigator.pop(
                            sheetContext,
                            SocialAccount(
                              id: DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),
                              platform: platform,
                              facebookAccountType:
                              platform == SocialPlatform.facebook
                                  ? facebookType
                                  : null,
                              url: urlController.text.trim(),
                              accountName:
                              nameController.text.trim(),
                              username:
                              usernameController.text.trim().isEmpty
                                  ? null
                                  : usernameController.text.trim(),
                              description:
                              descriptionController.text.trim(),
                              followers: int.tryParse(
                                followersController.text.trim(),
                              ) ??
                                  0,
                              verified: false,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: Colors.black,
                          minimumSize:
                          const Size.fromHeight(52),
                        ),
                        child: const Text(
                          'إضافة الحساب',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
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
      },
    );

    if (result == null || !mounted) return;

    setState(() {
      widget.draft.socialAccounts.add(result);
    });

    widget.onChanged();
  }

  InputDecoration _sheetDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _removeAccount(String id) {
    setState(() {
      widget.draft.socialAccounts.removeWhere(
            (account) => account.id == id,
      );
    });

    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'حسابات التواصل الاجتماعي',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'أضف صفحاتك وحساباتك ومنصاتك الشخصية. يمكنك إضافة أكثر من منصة.',
          style: TextStyle(
            color: Colors.white54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 18),

        if (widget.draft.socialAccounts.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.public_rounded,
                  color: Colors.white24,
                  size: 48,
                ),
                SizedBox(height: 10),
                Text(
                  'لم تتم إضافة أي منصة بعد',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          )
        else
          ...widget.draft.socialAccounts.map(
                (account) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: gold.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.public,
                      color: gold,
                    ),
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.accountName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${account.platform.displayName} • ${account.followers} متابع',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () => _removeAccount(account.id),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 14),

        OutlinedButton.icon(
          onPressed: _openAddAccount,
          icon: const Icon(Icons.add_rounded),
          label: const Text('إضافة منصة'),
          style: OutlinedButton.styleFrom(
            foregroundColor: gold,
            minimumSize: const Size.fromHeight(52),
            side: BorderSide(
              color: gold.withValues(alpha: 0.35),
            ),
          ),
        ),
      ],
    );
  }
}