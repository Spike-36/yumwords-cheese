import 'package:flutter/material.dart';

import '../data/card.dart';
import '../services/audio_service.dart';
import '../config/flavour.dart';
import 'widgets/back_button_common.dart';
import 'widgets/strength_guide_sheet.dart';
import 'widgets/region_map_sheet.dart';
import 'widgets/cheese_meta_row.dart';
import 'widgets/cheese_info_section.dart';

class FeaturedFoodDetailScreen extends StatefulWidget {
  final int index;

  // 👉 CURRENT VIEWING DATASET
  final List<Flashcard> cards;

  // 👉 MASTER DATASET
  final List<Flashcard>? allCards;

  final AudioService audio;
  final String languageCode;
  final bool autoAudio;

  const FeaturedFoodDetailScreen({
    super.key,
    required this.index,
    required this.cards,

    // 👉 NEW
    this.allCards,

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

  // 👉 FIXED REGION MAP LOOKUP
  String _regionMapPath(String region) {
    switch (
        region
            .toLowerCase()
            .trim()) {

      case 'paris basin & northern heartland':
        return 'assets/shared/maps/france_region_paris_central_north.png';

      case 'normandy & channel coast':
        return 'assets/shared/maps/france_region_normandy_channel_coast.png';

      case 'loire valley & western france':
        return 'assets/shared/maps/france_region_loire_valley_western_france.png';

      case 'southwest & pyrenees':
        return 'assets/shared/maps/france_region_southwest_pyrenees.png';

      case 'auvergne & central mountains':
        return 'assets/shared/maps/france_region_auvergne_central_mountains.png';

      case 'burgundy, jura & eastern france':
        return 'assets/shared/maps/france_region_burgundy_jura_eastern_france.png';

      case 'alps & savoie':
        return 'assets/shared/maps/france_region_alps_savoie.png';

      case 'mediterranean south & corsica':
        return 'assets/shared/maps/france_region_mediterranean_south_corsica.png';

      default:
        debugPrint(
          '⚠️ Unknown region: $region',
        );

        return 'assets/shared/maps/france_region_paris_basin_northern_heartland.png';
    }
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
                              left: 0,
                              top: 10,
                              child: Opacity(
                                opacity: 0,
                                child: Icon(
                                  Icons.volume_up,
                                  size: 28,
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 0,
                              top: 10,
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
                            fontSize: 14,
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
                              _regionMapPath(
                            card.region,
                          ),
                          regionName:
                              card.region,
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

                    CheeseInfoSection(
                      title:
                          'Where you’ll see it',
                      items:
                          card.whereYouWillSeeIt,
                      topSpacing: 36,
                    ),

                    CheeseInfoSection(
                      title:
                          'Regional origin',
                      items:
                          card.regionalOrigin,
                    ),

                    CheeseInfoSection(
                      title:
                          'How people usually eat it',
                      items: card
                          .howPeopleUsuallyEatIt,
                    ),

                    CheeseInfoSection(
                      title: 'Pairings',
                      items: card.pairings,
                    ),

                    CheeseInfoSection(
                      title:
                          'First impressions',
                      items: card
                          .firstImpressions,
                      topSpacing: 28,
                    ),

                    CheeseInfoSection(
                      title: 'Ripeness',
                      items: card.ripeness,
                    ),

                    CheeseInfoSection(
                      title:
                          'Storage & serving',
                      items: card
                          .storageAndServing,
                    ),

                    CheeseInfoSection(
                      title:
                          'Good to know',
                      items:
                          card.goodToKnow,
                    ),

                    if (card
                        .production
                        .isNotEmpty) ...[
                      Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          top: 20,
                          bottom: 4,
                        ),
                        child: const Text(
                          'Production',
                          style: TextStyle(
                            fontFamily:
                                'SourceSans3',
                            fontSize: 15,
                            fontWeight:
                                FontWeight
                                    .w600,
                            color: Colors
                                .black87,
                          ),
                        ),
                      ),

                      Text(
                        card.production,
                        style: const TextStyle(
                          fontFamily: 'SourceSans3',
                          fontSize: 15,
                          height: 1.45,
                          color: Colors.black87,
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
          onPressed: () =>
              Navigator.pop(context),
          topOffset:
              topInset + 12,
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