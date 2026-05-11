import 'package:flutter/material.dart';

import '../data/card.dart';
import '../services/audio_service.dart';
import '../config/flavour.dart';
import 'widgets/back_button_common.dart';
import 'widgets/circle_icon_button.dart';
import 'widgets/strength_guide_sheet.dart';
import 'widgets/region_map_sheet.dart';
import 'widgets/cheese_meta_row.dart';
import 'navigator_menu_screen.dart';

class FeaturedFoodDetailScreen extends StatefulWidget {
  final int index;
  final List<Flashcard> cards;
  final AudioService audio;
  final String languageCode;
  final bool autoAudio;

  const FeaturedFoodDetailScreen({
    super.key,
    required this.index,
    required this.cards,
    required this.audio,
    this.languageCode = 'en',
    this.autoAudio = false,
  });

  @override
  State<FeaturedFoodDetailScreen> createState() =>
      _FeaturedFoodDetailScreenState();
}

class _FeaturedFoodDetailScreenState
    extends State<FeaturedFoodDetailScreen> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: widget.index,
    );
  }

  String _flagPath(String country) {
    switch (country.toLowerCase().trim()) {
      case 'france':
        return 'assets/shared/flags/france.png';

      case 'italy':
        return 'assets/shared/flags/italy.png';

      case 'spain':
        return 'assets/shared/flags/spain.png';

      case 'uk':
      case 'united kingdom':
        return 'assets/shared/flags/uk.png';

      case 'ireland':
        return 'assets/shared/flags/ireland.png';

      case 'switzerland':
        return 'assets/shared/flags/switzerland.png';

      case 'netherlands':
        return 'assets/shared/flags/netherlands.png';

      case 'belgium':
        return 'assets/shared/flags/belgium.png';

      case 'germany':
        return 'assets/shared/flags/germany.png';

      case 'austria':
        return 'assets/shared/flags/austria.png';

      case 'portugal':
        return 'assets/shared/flags/portugal.png';

      case 'greece':
        return 'assets/shared/flags/greece.png';

      case 'denmark':
        return 'assets/shared/flags/denmark.png';

      case 'norway':
        return 'assets/shared/flags/norway.png';

      case 'sweden':
        return 'assets/shared/flags/sweden.png';

      case 'finland':
        return 'assets/shared/flags/finland.png';

      case 'romania':
        return 'assets/shared/flags/romania.png';

      case 'turkey':
        return 'assets/shared/flags/turkey.png';

      case 'bulgaria':
        return 'assets/shared/flags/bulgaria.png';

      case 'slovakia':
        return 'assets/shared/flags/slovakia.png';

      case 'poland':
        return 'assets/shared/flags/poland.png';

      default:
        return '';
    }
  }

  String _audioPath(String? filename) {
    final f = (filename ?? '').trim();

    return f.isEmpty
        ? ''
        : audioCountryPath(f);
  }

  String _imagePath(String? filename) {
    final f = (filename ?? '').trim();

    return f.isEmpty
        ? ''
        : imageCountryPath(f);
  }

  Future<void> _safePlay(
    BuildContext context,
    String path,
  ) async {
    if (path.isEmpty) return;

    try {
      await widget.audio.playAsset(path);
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Audio not available',
          ),
        ),
      );
    }
  }

  void _openNavigatorMenu(
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NavigatorMenuScreen(
          cards: widget.cards,
          audio: widget.audio,
          languageCode:
              widget.languageCode,
          autoAudio: widget.autoAudio,
        ),
      ),
    );
  }

  Widget _sectionLabel(
    String text, {
    double top = 20,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        bottom: 4,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'SourceSans3',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _bulletList(
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 6,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text('•  '),

              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontFamily:
                        'SourceSans3',
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

  Widget _buildPage(
    BuildContext context,
    int index,
  ) {
    final card = widget.cards[index];

    final imgH =
        MediaQuery.of(context)
                .size
                .height *
            0.45;

    final topInset =
        MediaQuery.of(context)
            .padding
            .top;

    final hw = card.headword.trim();

    final hwFont = 'BebasNeue';

    final phonetic =
        card.phonetic.trim();

    final imgPath =
        _imagePath(card.image);

    final audioPath =
        _audioPath(card.audio);

    final shortDesc =
        card.infoShortDescription
            .trim();

    final strengthMap = {
      'very mild': '1',
      'mild': '2',
      'medium': '3',
      'strong': '4',
      'very strong': '5',
    };

    final strength =
        strengthMap[
                card.strength
                    .toLowerCase()] ??
            '?';

    final milkType =
        card.milk.isEmpty
            ? '?'
            : '${card.milk[0].toUpperCase()}${card.milk.substring(1)}';

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading:
                  false,
              expandedHeight: imgH,
              backgroundColor:
                  Colors.black,
              flexibleSpace:
                  FlexibleSpaceBar(
                background:
                    imgPath.isEmpty
                        ? Container(
                            color: Colors
                                .black12,
                          )
                        : Image.asset(
                            imgPath,
                            fit: BoxFit
                                .cover,
                          ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  24,
                  20,
                  24,
                  48,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _safePlay(
                        context,
                        audioPath,
                      ),
                      child: SizedBox(
                        height: 44,
                        child: Stack(
                          alignment:
                              Alignment
                                  .center,
                          children: [
                            Center(
                              child: Text(
                                hw,
                                style:
                                    TextStyle(
                                  fontFamily:
                                      hwFont,
                                  fontSize:
                                      30,
                                ),
                                textAlign:
                                    TextAlign
                                        .center,
                              ),
                            ),

                            const Positioned(
                              right: 0,
                              top: 6,
                              child: Icon(
                                Icons
                                    .volume_up,
                                size: 28,
                                color: Colors
                                    .black26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    if (phonetic
                        .isNotEmpty)
                      Center(
                        child: Text(
                          "[$phonetic]",
                          style:
                              const TextStyle(
                            fontFamily:
                                'CharisSIL',
                            fontSize: 16,
                            fontStyle:
                                FontStyle
                                    .italic,
                            color:
                                Colors
                                    .grey,
                          ),
                        ),
                      ),

                    const SizedBox(
                      height: 10,
                    ),

                    CheeseMetaRow(
                      milkType:
                          milkType,
                      strength:
                          strength,

                      onMapTap: () {
                        showRegionMapSheet(
                          context,
                          mapAsset:
                              'assets/shared/maps/france_region_southwest.png',
                        );
                      },

                      onStrengthTap:
                          () {
                        showStrengthGuideSheet(
                          context,
                          strength,
                        );
                      },
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    if (shortDesc
                        .isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          top: 12,
                        ),
                        child: Text(
                          shortDesc,
                        ),
                      ),

                    if (card
                        .whereYouWillSeeIt
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'Where you’ll see it',
                        top: 36,
                      ),

                      _bulletList(
                        card
                            .whereYouWillSeeIt,
                      ),
                    ],

                    if (card
                        .regionalOrigin
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'Regional origin',
                      ),

                      _bulletList(
                        card
                            .regionalOrigin,
                      ),
                    ],

                    if (card
                        .howPeopleUsuallyEatIt
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'How people usually eat it',
                      ),

                      _bulletList(
                        card
                            .howPeopleUsuallyEatIt,
                      ),
                    ],

                    if (card
                        .pairings
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'Pairings',
                      ),

                      _bulletList(
                        card.pairings,
                      ),
                    ],

                    if (card
                        .firstImpressions
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'First impressions',
                        top: 28,
                      ),

                      _bulletList(
                        card
                            .firstImpressions,
                      ),
                    ],

                    if (card
                        .ripeness
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'Ripeness',
                      ),

                      _bulletList(
                        card
                            .ripeness,
                      ),
                    ],

                    if (card
                        .storageAndServing
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'Storage & serving',
                      ),

                      _bulletList(
                        card
                            .storageAndServing,
                      ),
                    ],

                    if (card
                        .goodToKnow
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'Good to know',
                      ),

                      _bulletList(
                        card
                            .goodToKnow,
                      ),
                    ],

                    if (card
                        .production
                        .isNotEmpty) ...[
                      _sectionLabel(
                        'Production',
                      ),

                      Text(
                        card.production,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),

        BackButtonCommon(
          onPressed: () =>
              Navigator.pop(context),
          topOffset:
              topInset + 12,
        ),

        Positioned(
          top: topInset + 17,
          right: 12,
          child: CircleIconButton(
            icon: Icons.search,
            onPressed: () =>
                _openNavigatorMenu(
              context,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount:
            widget.cards.length,
        itemBuilder:
            (context, index) {
          return _buildPage(
            context,
            index,
          );
        },
      ),
    );
  }
}