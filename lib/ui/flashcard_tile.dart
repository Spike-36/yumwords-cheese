import 'package:flutter/material.dart';
import '../data/card.dart';
import '../services/audio_service.dart';
import '../config/flavour.dart'; // flavour-aware audio paths

class FlashcardTile extends StatelessWidget {
  final List<Flashcard> cards;
  final int index;
  final AudioService audio;
  final ValueChanged<int> onCardSelected;
  final String languageCode;

  const FlashcardTile({
    super.key,
    required this.cards,
    required this.index,
    required this.audio,
    required this.onCardSelected,
    this.languageCode = 'en',
  });

  Flashcard get card => cards[index];

  // ------------------------------------------------------------
  // TYPOGRAPHY (FIXED)
  // ------------------------------------------------------------

  TextStyle _headwordTextStyle(String text) {
    final isNonLatin = RegExp(r'[^\u0000-\u007F]').hasMatch(text);
    return TextStyle(
      fontFamily: isNonLatin ? 'SourceSerif4' : 'SourceSans3',
      fontWeight: FontWeight.w600,
      fontSize: 17, // ✅ RESTORED
      height: 1.2,  // ✅ RESTORED
      color: Colors.black,
    );
  }

  static const TextStyle _phoneticStyle = TextStyle(
    fontFamily: 'CharisSIL',
    fontSize: 16,
    height: 1.2,
    color: Colors.black54,
  );

  static const TextStyle _meaningStyle = TextStyle(
    fontFamily: 'SourceSans3',
    fontSize: 17,
    height: 1.3,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // ------------------------------------------------------------
  // AUDIO
  // ------------------------------------------------------------

  Future<void> _playWord(BuildContext context) async {
    final f = (card.audio ?? '').trim();
    if (f.isEmpty) return;

    final path = audioCountryPath(f);
    try {
      await audio.playAsset(path);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio not available: $path')),
      );
    }
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final localizedMeaning = card.meaningFor(languageCode).trim();
    final hasMeaning = localizedMeaning.isNotEmpty;

    final headword = card.headword.trim();
    final headwordStyle = _headwordTextStyle(headword);

    final hasPhonetic = card.phonetic.trim().isNotEmpty;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onCardSelected(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------------------
              // LEFT — Meaning
              // ------------------------------------------------------------
              Expanded(
                flex: 4,
                child: Text(
                  hasMeaning ? localizedMeaning : '—',
                  style: _meaningStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),

              const SizedBox(width: 12),

              // ------------------------------------------------------------
              // MIDDLE — Headword + Phonetic
              // ------------------------------------------------------------
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headword,
                      style: headwordStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    if (hasPhonetic)
                      Text(
                        card.phonetic,
                        style: _phoneticStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ------------------------------------------------------------
              // RIGHT — Audio
              // ------------------------------------------------------------
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.black38),
                tooltip: 'Play word',
                onPressed: () => _playWord(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
