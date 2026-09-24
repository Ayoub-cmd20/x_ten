import 'package:flutter/material.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MESSAGES',
          style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      body: const Center(
        child: Text(
          'Chat & Messaging Channels Coming Soon',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
