enum MemoryKind { image, audio, video }

class MemoryItem {
  const MemoryItem({
    required this.id,
    required this.title,
    required this.kind,
    required this.localPath,
    required this.story,
  });

  final String id;
  final String title;
  final MemoryKind kind;
  final String localPath;
  final String story;
}
