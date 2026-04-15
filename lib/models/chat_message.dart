class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMine,
    required this.sentAt,
  });

  final String id;
  final String text;
  final bool isMine;
  final DateTime sentAt;
}
