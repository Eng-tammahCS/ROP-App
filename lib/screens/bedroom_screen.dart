import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/local_igloo_repository.dart';
import '../models/character_status.dart';
import '../models/memory_item.dart';
import '../widgets/room/igloo_character.dart';
import '../widgets/room/room_shell.dart';
import 'chat_room_screen.dart';

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
      duration: const Duration(seconds: 7),
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
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'مساحتكما الدافئة: هدوء، ذكريات، وقرب.',
                  style: TextStyle(color: Color(0xFFCABEE0)),
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
                              left: 22,
                              top: 40,
                              child: _WallLamp(),
                            ),
                            const Positioned(
                              right: 26,
                              top: 52,
                              child: _WindowGlow(),
                            ),
                            Positioned(
                              right: 14,
                              top: 158,
                              child: _MemoryWall(memories: memories),
                            ),
                            Positioned(
                              left: 22,
                              right: 20,
                              bottom: 42,
                              child: _Bed(
                                status: partner,
                                idle: _controller.value,
                                memories: memories,
                              ),
                            ),
                            const Positioned(
                              left: 18,
                              bottom: 72,
                              child: _SideTable(),
                            ),
                            Positioned(
                              left: 34,
                              bottom: me == CharacterStatus.asleep ? 92 : 132,
                              child: IglooCharacter(
                                name: 'نوّا',
                                status: me,
                                color: const Color(0xFFA68EF5),
                                idle: _controller.value,
                              ),
                            ),
                            Positioned(
                              right: partner == CharacterStatus.asleep ? 130 : 54,
                              bottom: partner == CharacterStatus.asleep ? 116 : 130,
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
                                  idle: _controller.value + 0.15,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 24,
                              right: 24,
                              bottom: 14,
                              child: _RoomMoodStrip(
                                partnerStatus: partner,
                                idle: _controller.value,
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

class _WallLamp extends StatelessWidget {
  const _WallLamp();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8C794), Color(0x668F6C4C)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x55F0C994), blurRadius: 18, spreadRadius: 2),
        ],
      ),
    );
  }
}

class _WindowGlow extends StatelessWidget {
  const _WindowGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 136,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x66E9C99E), width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF2CD), Color(0x33FFD68A)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x88FFE2A7), blurRadius: 24, spreadRadius: 2),
        ],
      ),
      child: const Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('ليل هادئ', style: TextStyle(fontSize: 11, color: Color(0xFF4B3B2E))),
        ),
      ),
    );
  }
}

class _Bed extends StatelessWidget {
  const _Bed({
    required this.status,
    required this.idle,
    required this.memories,
  });

  final CharacterStatus status;
  final double idle;
  final List<MemoryItem> memories;

  @override
  Widget build(BuildContext context) {
    final breathe = status == CharacterStatus.asleep ? (math.sin(idle * math.pi * 2) * 2.0) : 0.0;

    return Container(
      height: 138,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD8BEDF), Color(0xFF775D86)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x66120D1D), offset: Offset(0, 14), blurRadius: 22),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 18,
            right: 18,
            top: 14,
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF4ECFA),
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 16,
            child: Transform.translate(
              offset: Offset(0, breathe),
              child: Container(
                width: 92,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFEFDCF8),
                ),
              ),
            ),
          ),
          if (memories.isNotEmpty)
            Positioned(
              right: 14,
              bottom: 14,
              child: _MemoryToken(memory: memories.first),
            ),
          Positioned(
            left: 24,
            bottom: 12,
            child: Text(
              status == CharacterStatus.asleep ? 'لولو نائمة بطمأنينة على السرير' : 'السرير ينتظر لولو',
              style: const TextStyle(
                color: Color(0xFFF1E9FF),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideTable extends StatelessWidget {
  const _SideTable();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 92,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF4F3D54),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 6,
            right: 6,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFE6B8C9),
                borderRadius: BorderRadius.circular(8),
              ),
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
      width: 156,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final memory in memories.take(2))
            Container(
              width: 142,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF312540),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x775F4D71)),
                boxShadow: const [
                  BoxShadow(color: Color(0x400E0B15), blurRadius: 8, offset: Offset(0, 4)),
                ],
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
                    child: Text(_memoryTypeLabel(memory.kind)),
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

  String _memoryTypeLabel(MemoryKind kind) {
    switch (kind) {
      case MemoryKind.image:
        return 'صورة';
      case MemoryKind.audio:
        return 'مقطع صوتي';
      case MemoryKind.video:
        return 'فيديو';
    }
  }
}

class _MemoryToken extends StatelessWidget {
  const _MemoryToken({required this.memory});

  final MemoryItem memory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4F3C66),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x99BAA1D0)),
      ),
      child: Text(
        'ذكرى: ${memory.title}',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _RoomMoodStrip extends StatelessWidget {
  const _RoomMoodStrip({
    required this.partnerStatus,
    required this.idle,
  });

  final CharacterStatus partnerStatus;
  final double idle;

  @override
  Widget build(BuildContext context) {
    final glow = (math.sin(idle * math.pi * 2) + 1) * 0.5;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0x99231D30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color.lerp(const Color(0x66B18FD2), const Color(0x88FFE2A7), glow)!),
      ),
      child: Text(
        partnerStatus == CharacterStatus.asleep
            ? 'المزاج الآن: سكينة ليلية ودفء خافت.'
            : 'المزاج الآن: حضور لطيف وحياة خفيفة.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
