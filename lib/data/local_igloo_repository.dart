import '../models/chat_message.dart';
import '../models/character_status.dart';
import '../models/memory_item.dart';

class LocalIglooRepository {
  const LocalIglooRepository();

  CharacterStatus myStatus() => CharacterStatus.awake;

  CharacterStatus partnerStatus() => CharacterStatus.asleep;

  List<MemoryItem> memories() => const [
        MemoryItem(
          id: 'm1',
          title: 'ضحكة المساء',
          localPath: 'local://memory/evening.jpg',
          story: 'صورة من أمس على ضوء النافذة.',
        ),
        MemoryItem(
          id: 'm2',
          title: 'قهوة السبت',
          localPath: 'local://memory/coffee.jpg',
          story: 'لحظة هادئة قبل النوم.',
        ),
      ];

  List<ChatMessage> messages() => [
        ChatMessage(
          id: 'c1',
          text: 'أنا هنا، الغرفة دافئة اليوم.',
          isMine: false,
          sentAt: DateTime(2026, 4, 15, 20, 12),
        ),
        ChatMessage(
          id: 'c2',
          text: 'شفت الصورة الجديدة؟ خليتها على الجدار.',
          isMine: true,
          sentAt: DateTime(2026, 4, 15, 20, 17),
        ),
      ];
}
