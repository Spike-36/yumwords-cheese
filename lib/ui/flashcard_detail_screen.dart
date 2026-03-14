import 'package:flutter/material.dart';
import '../data/card.dart';
import '../services/audio_service.dart';
import '../config/flavour.dart';
import 'widgets/back_button_common.dart';

class FlashcardDetailScreen extends StatefulWidget {
  final List<Flashcard> cards;
  final int index;
  final AudioService audio;
  final ValueChanged<int>? onIndexChange;
  final bool autoAudio;
  final String languageCode;

  const FlashcardDetailScreen({
    super.key,
    required this.cards,
    required this.index,
    required this.audio,
    this.onIndexChange,
    this.autoAudio = false,
    this.languageCode = 'en',
  });

  @override
  State<FlashcardDetailScreen> createState() =>
      _FlashcardDetailScreenState();
}

// =============================================================
// CONSTANTS
// =============================================================

const double kHeadwordSize = 30;
const double kPhoneticSize = 17;
const double kMeaningSize = 22;

const double kChevronButtonSize = 56.0;
const double kChevronIconSize = 32.0;
const double kChevronOuterPad = 12.0;

const Color kSpeakerColor = Colors.black38;
const double kSwipeVelocityThreshold = 300.0;

// =============================================================

class _FlashcardDetailScreenState extends State<FlashcardDetailScreen> {
  int? _lastAutoPlayedIndex;

  Flashcard get card => widget.cards[widget.index];

  String _audioPath(String? filename) {
    final f = (filename ?? '').trim();
    return f.isEmpty ? '' : audioCountryPath(f);
  }

  String _imagePath(String? filename) {
    final f = (filename ?? '').trim();
    return f.isEmpty ? '' : imageCountryPath(f);
  }

  Future<void> _safePlay(BuildContext context, String path) async {
    if (path.isEmpty) return;
    try {
      await widget.audio.playAsset(path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio not available')),
      );
    }
  }

  // 🔄 REVISED SCRIPT DETECTION
  // Detects Asian scripts only. Latin languages (including accents)
  // remain BebasNeue.
  bool _needsSerifFont(String text) {
    return RegExp(
      r'[\u3040-\u30FF\u4E00-\u9FFF\uAC00-\uD7AF\u0E00-\u0E7F]'
    ).hasMatch(text);
  }

  // =============================================================
  // AUTO-AUDIO
  // =============================================================

  void _maybeAutoPlay() {
    if (!widget.autoAudio) return;
    if (_lastAutoPlayedIndex == widget.index) return;

    final path = _audioPath(card.audio);
    if (path.isEmpty) return;

    _lastAutoPlayedIndex = widget.index;
    _safePlay(context, path);
  }

  @override
  void didUpdateWidget(covariant FlashcardDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.index != widget.index ||
        (!oldWidget.autoAudio && widget.autoAudio)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _maybeAutoPlay();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeAutoPlay();
    });
  }

  // =============================================================
  // NAVIGATION
  // =============================================================

  void _goTo(int newIndex) {
    final n = widget.cards.length;
    if (n == 0) return;

    final wrapped = (newIndex % n + n) % n;
    _lastAutoPlayedIndex = null;
    widget.onIndexChange?.call(wrapped);
  }

  Widget _floatingButton(IconData icon, VoidCallback action) {
    return Material(
      color: Colors.white.withOpacity(0.95),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: action,
        child: SizedBox(
          width: kChevronButtonSize,
          height: kChevronButtonSize,
          child: Icon(icon, size: kChevronIconSize),
        ),
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    final hw = card.headword.trim();

    // 🔄 UPDATED FONT LOGIC
    final hwFont = _needsSerifFont(hw) ? 'SourceSerif4' : 'BebasNeue';

    final meaning = card.meaningFor(widget.languageCode);
    final hasPhon = card.phonetic.trim().isNotEmpty;

    final audioPath = _audioPath(card.audio);
    final imgPath = _imagePath(card.image);
    final imgH = MediaQuery.of(context).size.height * 0.45;

    final mainScroll = CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: imgH,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            background: imgPath.isEmpty
                ? Container(color: Colors.black12)
                : Image.asset(imgPath, fit: BoxFit.cover),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _safePlay(context, audioPath),
                  child: Text(
                    hw,
                    style: TextStyle(
                      fontFamily: hwFont,
                      fontSize: kHeadwordSize,
                      letterSpacing:
                          hwFont == 'BebasNeue' ? 0.04 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => _safePlay(context, audioPath),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.volume_up,
                      size: 32,
                      color: kSpeakerColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                if (hasPhon)
                  Text(
                    "[${card.phonetic}]",
                    style: const TextStyle(
                      fontFamily: 'CharisSIL',
                      fontSize: kPhoneticSize,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepOrange,
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  meaning,
                  style: const TextStyle(
                    fontFamily: 'SourceSans3',
                    fontSize: kMeaningSize,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (details) {
              if (widget.onIndexChange == null) return;
              final v = details.primaryVelocity ?? 0;
              if (v.abs() < kSwipeVelocityThreshold) return;
              (v < 0)
                  ? _goTo(widget.index + 1)
                  : _goTo(widget.index - 1);
            },
            child: mainScroll,
          ),
          BackButtonCommon(
            onPressed: () => Navigator.pop(context),
            topOffset: topInset + 12,
          ),
          if (widget.onIndexChange != null) ...[
            Positioned(
              left: 8,
              bottom:
                  kChevronOuterPad + MediaQuery.of(context).padding.bottom,
              child: _floatingButton(
                Icons.chevron_left,
                () => _goTo(widget.index - 1),
              ),
            ),
            Positioned(
              right: 8,
              bottom:
                  kChevronOuterPad + MediaQuery.of(context).padding.bottom,
              child: _floatingButton(
                Icons.chevron_right,
                () => _goTo(widget.index + 1),
              ),
            ),
          ],
        ],
      ),
    );
  }
}