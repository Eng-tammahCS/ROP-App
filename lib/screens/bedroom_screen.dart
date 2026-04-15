import 'package:flutter/material.dart';

import '../data/local_igloo_repository.dart';
import '../models/character_status.dart';
import '../models/memory_item.dart';
import 'chat_room_screen.dart';
import '../widgets/room/igloo_character.dart';
import '../widgets/room/room_shell.dart';

class BedroomScreen extends StatefulWidget {
  const BedroomScreen({
    super.key,
    LocalIglooRepository? repository,
  }) : repository = repository ?? const LocalIglooRepository();

  final LocalIglooRepository repository;

  @override
  State<BedroomScreen> createState() => _BedroomScreenState();
}

class _BedroomScreenState extends State<BedroomScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memories = widget.repository.memories();
    final me = widget.repository.myStatus();
    final partner = widget.repository.partnerStatus();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'غرفتنا',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text(
                  'بيت صغير حيّ بينكما، بعيدًا عن ضجيج العالم.',
                  style: TextStyle(color: Color(0xFFCBBCE4)),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return RoomShell(
                        child: Stack(
                          children: [
                            const Positioned(
                              right: 26,
                              top: 60,
                              child: _WindowGlow(),
                            ),
                            Positioned(
                              left: 28,
                              right: 28,
                              bottom: 58,
                              child: _Bed(status: partner),
                            ),
                            Positioned(
                              right: 24,
                              top: 170,
                              child: _MemoryWall(memories: memories),
                            ),
                            Positioned(
                              left: 42,
                              bottom: me == CharacterStatus.asleep ? 82 : 122,
                              child: IglooCharacter(
                                name: 'نوّا',
                                status: me,
                                color: const Color(0xFFA68EF5),
                                idle: _controller.value,
                              ),
                            ),
                            Positioned(
                              right: 54,
                              bottom: partner == CharacterStatus.asleep ? 84 : 120,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ChatRoomScreen(
                                        partnerName: 'لولو',
                                        messages: widget.repository.messages(),
                                      ),
                                    ),
                                  );
                                },
                                child: IglooCharacter(
                                  name: 'لولو',
                                  status: partner,
                                  color: const Color(0xFF8AD8C4),
                                  idle: _controller.value + 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WindowGlow extends StatelessWidget {
  const _WindowGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      height: 132,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF2CD), Color(0x44FFD68A)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x88FFE2A7), blurRadius: 24, spreadRadius: 2),
        ],
      ),
    );
  }
}

class _Bed extends StatelessWidget {
  const _Bed({required this.status});

  final CharacterStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFCAA9DA), Color(0xFF6C577A)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 18,
            right: 18,
            top: 16,
            child: Container(
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFEEE2F8),
              ),
            ),
          ),
          if (status == CharacterStatus.asleep)
            const Positioned(
              left: 20,
              bottom: 10,
              child: Text(
                'تنفّس هادئ...',
                style: TextStyle(color: Color(0xFFEFE8FF), fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

class _MemoryWall extends StatelessWidget {
  const _MemoryWall({required this.memories});

  final List<MemoryItem> memories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 146,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final memory in memories.take(2))
            Container(
              width: 132,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2F263E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x775F4D71)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF675679),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text('صورة محلية'),
                  ),
                  const SizedBox(height: 6),
                  Text(memory.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
