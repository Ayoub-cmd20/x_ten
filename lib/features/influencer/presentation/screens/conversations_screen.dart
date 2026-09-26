import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:x_ten/features/explore/presentation/pages/advertiser_profile_screen.dart';

class ConversationsScreen extends StatefulWidget {
  final String? advertiserId;
  final String? advertiserName;
  final String? advertiserCategory;

  const ConversationsScreen({
    super.key,
    this.advertiserId,
    this.advertiserName,
    this.advertiserCategory,
  });

  bool get openDirectConversation =>
      advertiserId != null || advertiserName != null;

  @override
  State<ConversationsScreen> createState() =>
      _ConversationsScreenState();
}

class _ConversationsScreenState
    extends State<ConversationsScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF161616);

  final List<_ConversationPreview> _conversations = [
    const _ConversationPreview(
      id: 'advertiser_001',
      name: 'Tech DZ',
      lastMessage:
      'شكراً، سنراجع عرضك ونعود إليك قريباً.',
      time: '18:45',
      unreadCount: 2,
      isOnline: true,
    ),
    const _ConversationPreview(
      id: 'advertiser_002',
      name: 'Fashion Brand',
      lastMessage:
      'هل يمكنك إرسال إحصائيات حساب Instagram؟',
      time: '16:20',
      unreadCount: 1,
      isOnline: false,
    ),
    const _ConversationPreview(
      id: 'advertiser_003',
      name: 'Food Company',
      lastMessage:
      'تم قبول المقترح المبدئي للحملة.',
      time: 'أمس',
      unreadCount: 0,
      isOnline: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: widget.openDirectConversation
          ? _buildDirectConversation()
          : _buildConversationList(),
    );
  }

  // =========================================================
  // GENERAL CONVERSATION LIST
  // =========================================================

  Widget _buildConversationList() {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'المحادثات',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              14,
            ),
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: gold,
              decoration: InputDecoration(
                hintText: 'البحث في المحادثات...',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: gold,
                ),
                filled: true,
                fillColor: surface,
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: _conversations.isEmpty
                ? const _EmptyConversations()
                : ListView.separated(
              padding:
              const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                24,
              ),
              itemCount:
              _conversations.length,
              separatorBuilder:
                  (_, _) =>
              const SizedBox(
                height: 10,
              ),
              itemBuilder:
                  (context, index) {
                final conversation =
                _conversations[index];

                return _ConversationCard(
                  conversation:
                  conversation,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ConversationsScreen(
                              advertiserId:
                              conversation.id,
                              advertiserName:
                              conversation.name,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DIRECT CONVERSATION
  // =========================================================

  Widget _buildDirectConversation() {
    final advertiserName =
    widget.advertiserName?.trim().isNotEmpty == true
        ? widget.advertiserName!
        : 'المعلن';

    return _DirectChatScreen(
      advertiserId: widget.advertiserId ?? 'unknown',
      advertiserName: advertiserName,
      advertiserCategory:
      widget.advertiserCategory ?? 'معلن على X Ten',
    );
  }
}

// ===========================================================
// CONVERSATION PREVIEW MODEL
// ===========================================================

class _ConversationPreview {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const _ConversationPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}

// ===========================================================
// CONVERSATION CARD
// ===========================================================

class _ConversationCard extends StatelessWidget {
  final _ConversationPreview conversation;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.conversation,
    required this.onTap,
  });

  static const Color gold =
  Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius:
      BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(18),
        child: Ink(
          padding:
          const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
            const Color(0xFF151515),
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color:
              gold.withValues(
                alpha: 0.10,
              ),
            ),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration:
                    BoxDecoration(
                      color:
                      gold.withValues(
                        alpha: 0.10,
                      ),
                      shape:
                      BoxShape.circle,
                    ),
                    child:
                    const Icon(
                      Icons
                          .business_outlined,
                      color: gold,
                      size: 25,
                    ),
                  ),

                  if (conversation
                      .isOnline)
                    PositionedDirectional(
                      bottom: 1,
                      end: 1,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration:
                        BoxDecoration(
                          color:
                          Colors.green,
                          shape:
                          BoxShape.circle,
                          border:
                          Border.all(
                            color:
                            const Color(
                              0xFF151515,
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation
                                .name,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 15,
                              fontWeight:
                              FontWeight
                                  .w800,
                            ),
                          ),
                        ),

                        Text(
                          conversation
                              .time,
                          style:
                          const TextStyle(
                            color:
                            Colors.white38,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation
                                .lastMessage,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              color:
                              Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        if (conversation
                            .unreadCount >
                            0) ...[
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            constraints:
                            const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            alignment:
                            Alignment.center,
                            decoration:
                            const BoxDecoration(
                              color: gold,
                              shape:
                              BoxShape.circle,
                            ),
                            child: Text(
                              '${conversation.unreadCount}',
                              style:
                              const TextStyle(
                                color:
                                Colors.black,
                                fontSize: 10,
                                fontWeight:
                                FontWeight
                                    .w800,
                              ),
                            ),
                          ),
                        ],
                      ],
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
}

// ===========================================================
// DIRECT CHAT SCREEN
// ===========================================================

class _DirectChatScreen extends StatefulWidget {
  final String advertiserId;
  final String advertiserName;
  final String advertiserCategory;

  const _DirectChatScreen({
    required this.advertiserId,
    required this.advertiserName,
    required this.advertiserCategory,
  });

  @override
  State<_DirectChatScreen> createState() =>
      _DirectChatScreenState();
}

class _DirectChatScreenState
    extends State<_DirectChatScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF161616);

  late final TextEditingController
  _messageController;

  late final ScrollController
  _scrollController;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      id: '1',
      text:
      'السلام عليكم، شكراً لتواصلك معنا عبر منصة X Ten.',
      sentAt: DateTime.now().subtract(
        const Duration(minutes: 15),
      ),
      isMine: false,
    ),
    _ChatMessage(
      id: '2',
      text:
      'وعليكم السلام، أنا مهتم بالمشروع وأود معرفة المزيد من التفاصيل.',
      sentAt: DateTime.now().subtract(
        const Duration(minutes: 12),
      ),
      isMine: true,
    ),
    _ChatMessage(
      id: '3',
      text:
      'بالتأكيد، يمكننا مناقشة تفاصيل الحملة والميزانية وموعد النشر هنا.',
      sentAt: DateTime.now().subtract(
        const Duration(minutes: 8),
      ),
      isMine: false,
    ),
  ];

  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    _messageController =
        TextEditingController();

    _scrollController =
        ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text =
    _messageController.text.trim();

    if (text.isEmpty ||
        _isSending) {
      return;
    }

    final message = _ChatMessage(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      text: text,
      sentAt: DateTime.now(),
      isMine: true,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
      _isSending = true;
    });

    _scrollToBottom();

    try {
      // TODO:
      // Replace with real backend call:
      //
      // await messagesRepository.sendMessage(
      //   receiverId: widget.advertiserId,
      //   text: text,
      // );

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _pickAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'webp',
          'pdf',
          'doc',
          'docx',
        ],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      for (final file in result.files) {
        final message = _ChatMessage(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          text: '',
          sentAt: DateTime.now(),
          isMine: true,
          attachmentName: file.name,
          attachmentExtension: file.extension,
          attachmentSize: file.size,
          attachmentPath: file.path,
        );

        if (!mounted) return;

        setState(() {
          _messages.add(message);
        });
      }

      _scrollToBottom();

      // TODO:
      // Upload files to Firebase Storage / Supabase Storage / API
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF1B1B1B),
            content: Text(
              'تعذر اختيار الملف',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!_scrollController
          .hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController
            .position
            .maxScrollExtent,
        duration:
        const Duration(
          milliseconds: 250,
        ),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        titleSpacing: 0,

        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                gold.withValues(
                  alpha: 0.10,
                ),
                shape:
                BoxShape.circle,
              ),
              child: const Icon(
                Icons.business_outlined,
                color: gold,
                size: 20,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.advertiserName,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'متصل الآن',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        actions: [
          PopupMenuButton<String>(
            color: const Color(0xFF1B1B1B),
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white70,
            ),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdvertiserProfileScreen(
                        companyName: widget.advertiserName,
                        category: widget.advertiserCategory,
                      ),
                    ),
                  );
                  break;

                case 'block':
                  _showBlockDialog();
                  break;

                case 'report':
                  _showReportDialog();
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'profile',
                child: Text(
                  'عرض الملف',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'block',
                child: Text(
                  'حظر المستخدم',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Text(
                  'الإبلاغ',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // CHAT SECURITY INFO
            Container(
              width: double.infinity,
              margin:
              const EdgeInsets.fromLTRB(
                14,
                8,
                14,
                8,
              ),
              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color:
                gold.withValues(
                  alpha: 0.06,
                ),
                borderRadius:
                BorderRadius.circular(
                  13,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons
                        .verified_user_outlined,
                    color: gold,
                    size: 17,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'حافظ على التواصل والاتفاقات داخل منصة X Ten لحماية حقوق جميع الأطراف.',
                      style: TextStyle(
                        color:
                        Colors.white54,
                        fontSize: 10.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller:
                _scrollController,
                padding:
                const EdgeInsets.fromLTRB(
                  14,
                  10,
                  14,
                  20,
                ),
                itemCount:
                _messages.length,
                itemBuilder:
                    (context, index) {
                  return _MessageBubble(
                    message:
                    _messages[index],
                  );
                },
              ),
            ),

            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // MESSAGE COMPOSER
  // =========================================================

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        9,
        10,
        10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        border: Border(
          top: BorderSide(
            color:
            Colors.white.withValues(
              alpha: 0.05,
            ),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.end,
        children: [
          IconButton(
            tooltip: 'إرفاق ملف',
            onPressed: _pickAttachments,
            icon: const Icon(
              Icons.attach_file_rounded,
              color: gold,
            ),
          ),

          Expanded(
            child: TextField(
              controller:
              _messageController,
              minLines: 1,
              maxLines: 5,
              textInputAction:
              TextInputAction.newline,
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: gold,
              decoration: InputDecoration(
                hintText:
                'اكتب رسالتك...',
                hintStyle:
                const TextStyle(
                  color: Colors.white30,
                ),
                filled: true,
                fillColor: surface,
                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 7),

          Container(
            width: 46,
            height: 46,
            decoration:
            const BoxDecoration(
              color: gold,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: 'إرسال',
              onPressed:
              _isSending
                  ? null
                  : _sendMessage,
              icon: _isSending
                  ? const SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
                  : const Icon(
                Icons.send_rounded,
                color: Colors.black,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor:
            const Color(0xFF171717),
            title: const Text(
              'حظر المستخدم',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'هل تريد حظر ${widget.advertiserName}؟',
              style: const TextStyle(
                color: Colors.white60,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم حظر المستخدم',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'حظر',
                  style: TextStyle(
                    color:
                    Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor:
            const Color(0xFF171717),
            title: const Text(
              'الإبلاغ عن المستخدم',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: const Text(
              'سيتم إرسال البلاغ إلى فريق X Ten للمراجعة.',
              style: TextStyle(
                color: Colors.white60,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم إرسال البلاغ',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'إرسال البلاغ',
                  style: TextStyle(
                    color: gold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ===========================================================
// MESSAGE MODEL
// ===========================================================

class _ChatMessage {
  final String id;
  final String text;
  final DateTime sentAt;
  final bool isMine;
  final String? attachmentName;
  final String? attachmentExtension;
  final int? attachmentSize;
  final String? attachmentPath;

  const _ChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isMine,
    this.attachmentName,
    this.attachmentExtension,
    this.attachmentSize,
    this.attachmentPath,
  });

  bool get hasAttachment => attachmentName != null;
}

// ===========================================================
// MESSAGE BUBBLE
// ===========================================================

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({
    required this.message,
  });

  static const Color gold =
  Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        constraints:
        const BoxConstraints(
          maxWidth: 290,
        ),
        margin:
        const EdgeInsets.only(
          bottom: 9,
        ),
        padding:
        const EdgeInsets.fromLTRB(
          13,
          10,
          13,
          7,
        ),
        decoration: BoxDecoration(
          color: message.isMine
              ? gold
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft:
            const Radius.circular(17),
            topRight:
            const Radius.circular(17),
            bottomLeft: Radius.circular(
              message.isMine ? 17 : 5,
            ),
            bottomRight: Radius.circular(
              message.isMine ? 5 : 17,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            if (message.hasAttachment) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: message.isMine
                      ? Colors.black.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insert_drive_file_rounded,
                      color: message.isMine ? Colors.black87 : gold,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.attachmentName!,
                            style: TextStyle(
                              color: message.isMine
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (message.attachmentSize != null)
                            Text(
                              '${(message.attachmentSize! / 1024).toStringAsFixed(1)} KB',
                              style: TextStyle(
                                color: message.isMine
                                    ? Colors.black54
                                    : Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (message.text.isNotEmpty)
                const SizedBox(height: 6),
            ],
            if (message.text.isNotEmpty)
              Align(
                alignment:
                AlignmentDirectional
                    .centerStart,
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.isMine
                        ? Colors.black
                        : Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),

            const SizedBox(height: 4),

            Text(
              _formatTime(
                message.sentAt,
              ),
              style: TextStyle(
                color: message.isMine
                    ? Colors.black54
                    : Colors.white30,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(
      DateTime time,
      ) {
    final hour =
    time.hour.toString().padLeft(
      2,
      '0',
    );

    final minute =
    time.minute.toString().padLeft(
      2,
      '0',
    );

    return '$hour:$minute';
  }
}

// ===========================================================
// EMPTY STATE
// ===========================================================

class _EmptyConversations
    extends StatelessWidget {
  const _EmptyConversations();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            Icons
                .chat_bubble_outline_rounded,
            color: Colors.white24,
            size: 60,
          ),
          SizedBox(height: 14),
          Text(
            'لا توجد محادثات بعد',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 15,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}