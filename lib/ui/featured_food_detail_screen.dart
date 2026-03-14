import 'package:flutter/material.dart';
import '../data/card.dart';
import '../services/audio_service.dart';
import '../config/flavour.dart';
import 'widgets/back_button_common.dart';
import 'widgets/circle_icon_button.dart';
import 'navigator_menu_screen.dart';

class FeaturedFoodDetailScreen extends StatelessWidget {
  final Flashcard card;
  final AudioService audio;
  final List<Flashcard> cards;
  final String languageCode;
  final bool autoAudio;

  const FeaturedFoodDetailScreen({
    super.key,
    required this.card,
    required this.audio,
    required this.cards,
    this.languageCode = 'en',
    this.autoAudio = false,
  });

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
      await audio.playAsset(path);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio not available')),
      );
    }
  }

  bool _isNonLatin(String text) =>
      RegExp(r'[^\u0000-\u007F]').hasMatch(text);

  void _openNavigatorMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NavigatorMenuScreen(
          cards: cards,
          audio: audio,
          languageCode: languageCode,
          autoAudio: autoAudio,
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, {double top = 20}) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'SourceSans3',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•  '),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontFamily: 'SourceSans3',
                    fontSize: 15,
                    height: 1.45,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imgH = MediaQuery.of(context).size.height * 0.45;
    final topInset = MediaQuery.of(context).padding.top;

    final hw = card.headword.trim();
    final hwFont = _isNonLatin(hw) ? 'SourceSerif4' : 'BebasNeue';

    final meaning = card.meaningFor(languageCode);
    final phonetic = card.phonetic.trim();

    final imgPath = _imagePath(card.image);
    final audioPath = _audioPath(card.audio);

    final shortDesc = card.infoShortDescription.trim();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
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
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () => _safePlay(context, audioPath),
                          child: Text(
                            hw,
                            style: TextStyle(
                              fontFamily: hwFont,
                              fontSize: 30,
                              letterSpacing:
                                  hwFont == 'BebasNeue' ? 0.04 : null,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: InkWell(
                          onTap: () => _safePlay(context, audioPath),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.volume_up,
                              size: 32,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                      if (phonetic.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            "[$phonetic]",
                            style: const TextStyle(
                              fontFamily: 'CharisSIL',
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          meaning,
                          style: const TextStyle(
                            fontFamily: 'SourceSans3',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      if (shortDesc.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          shortDesc,
                          style: const TextStyle(
                            fontFamily: 'SourceSans3',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),
                      ],

                      if (card.whereYouWillSeeIt.isNotEmpty) ...[
                        _sectionLabel('Where you’ll see it', top: 36),
                        _bulletList(card.whereYouWillSeeIt),
                      ],
                      if (card.whenItsEaten.isNotEmpty) ...[
                        _sectionLabel('When it’s eaten'),
                        _bulletList(card.whenItsEaten),
                      ],
                      if (card.howPeopleUsuallyEatIt.isNotEmpty) ...[
                        _sectionLabel('How people usually eat it'),
                        _bulletList(card.howPeopleUsuallyEatIt),
                      ],

                      if (card.whyItsPopular.isNotEmpty) ...[
                        _sectionLabel('Why it’s popular', top: 28),
                        _bulletList(card.whyItsPopular),
                      ],
                      if (card.firstImpressions.isNotEmpty) ...[
                        _sectionLabel('First impressions'),
                        _bulletList(card.firstImpressions),
                      ],

                      /// ✅ NEW — SPICE LEVEL (THIS WAS MISSING)
                      if (card.infoSpiceLevel.isNotEmpty) ...[
                        _sectionLabel('Spice level'),
                        _bulletList(card.infoSpiceLevel),
                      ],

                      if (card.goodToKnow.isNotEmpty) ...[
                        _sectionLabel('Good to know'),
                        _bulletList(card.goodToKnow),
                      ],

                      if (card.infoIngredients.isNotEmpty ||
                          card.infoPreparation.isNotEmpty) ...[
                        const SizedBox(height: 36),
                        const Divider(height: 1),
                      ],
                      if (card.infoIngredients.isNotEmpty) ...[
                        _sectionLabel('Ingredients', top: 24),
                        _bulletList(card.infoIngredients),
                      ],
                      if (card.infoPreparation.isNotEmpty) ...[
                        _sectionLabel('Preparation', top: 24),
                        Text(
                          card.infoPreparation,
                          style: const TextStyle(
                            fontFamily: 'SourceSans3',
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          BackButtonCommon(
            onPressed: () => Navigator.pop(context),
            topOffset: topInset + 12,
          ),
          Positioned(
            top: topInset + 17,
            right: 12,
            child: CircleIconButton(
              icon: Icons.search,
              onPressed: () => _openNavigatorMenu(context),
            ),
          ),
        ],
      ),
    );
  }
}
