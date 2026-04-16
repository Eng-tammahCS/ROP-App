import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({
    super.key,
    required this.partnerName,
    required this.messages,
  });

  final String partnerName;
  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('محادثة $partnerName'),
          backgroundColor: const Color(0xFF2A2138),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2E243F),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'مساحة خاصة بينكما فقط. كل شيء هنا محلي وآمن على هذا الجهاز.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFDCCFEB), fontSize: 12),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final item = messages[index];
                  return Align(
                    alignment: item.isMine ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: item.isMine ? const Color(0xFF544069) : const Color(0xFF372B4A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x3349D0B6)),
                      ),
                      child: Text(item.text),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 6, 16, 16),
              child: _MessageComposer(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2438),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'اكتب رسالة لطيفة...',
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
