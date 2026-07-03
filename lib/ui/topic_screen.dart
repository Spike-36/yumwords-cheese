import 'package:flutter/material.dart';

import '../config/flavour.dart';
import '../data/card.dart';
import '../data/topics/topic.dart';
import '../services/audio_service.dart';
import 'featured_food_detail_screen.dart';
import 'search/search_screen.dart';

class TopicScreen extends StatelessWidget {
  final Topic topic;
  final List<Flashcard> topicCards;
  final List<Flashcard> allCards;
  final AudioService audio;
  final String languageCode;
  final bool autoAudio;

  const TopicScreen({
    super.key,
    required this.topic,
    required this.topicCards,
    required this.allCards,
    required this.audio,
    this.languageCode = 'en',
    this.autoAudio = false,
  });

  void _openNavigatorMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(
          cards: allCards,
          audio: audio,
        ),
      ),
    );
  }

  void _openCard(
    BuildContext context,
    List<Flashcard> list,
    int index,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeaturedFoodDetailScreen(
          index: index,
          cards: list,
          allCards: allCards,
          audio: audio,
          languageCode: languageCode,
          autoAudio: autoAudio,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (topicCards.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: const Center(
          child: Text('No cheeses found for this topic.'),
        ),
      );
    }

    final heroCard = topicCards.first;
    final gridCards = topicCards.skip(1).toList(growable: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              topic.title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 26,
                letterSpacing: 0.06,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: GestureDetector(
              onTap: () => _openCard(
                context,
                topicCards,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        imageCountryPath(heroCard.image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    heroCard.headword,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (gridCards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gridCards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final card = gridCards[index];

                  return GestureDetector(
                    onTap: () => _openCard(
                      context,
                      topicCards,
                      index + 1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imageCountryPath(card.image),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          card.headword,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 84,
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      title: SizedBox(
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                appTitle(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 28,
                  letterSpacing: 0.08,
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: -3,
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
                onPressed: () => _openNavigatorMenu(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}