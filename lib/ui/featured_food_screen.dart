import 'package:flutter/material.dart';

import '../config/flavour.dart';
import '../data/card.dart';
import '../data/topics/topic.dart';
import '../data/topics/topic_block.dart';
import '../data/topics/topic_service.dart';
import '../services/audio_service.dart';

import 'featured_food_detail_screen.dart';
import 'search/search_screen.dart';

class FeaturedFoodScreen extends StatefulWidget {
  final List<Flashcard> cards;
  final List<Topic> topics;
  final List<TopicBlock> topicBlocks;
  final AudioService audio;
  final String languageCode;
  final bool autoAudio;

  const FeaturedFoodScreen({
    super.key,
    required this.cards,
    required this.topics,
    required this.topicBlocks,
    required this.audio,
    this.languageCode = 'en',
    this.autoAudio = false,
  });

  @override
  State<FeaturedFoodScreen> createState() => _FeaturedFoodScreenState();
}

class _FeaturedFoodScreenState extends State<FeaturedFoodScreen> {
  // ------------------------------------------------------------
  // FEATURED TOPICS
  // ------------------------------------------------------------
  List<_TopicSection> _buildFeaturedTopicSections() {
    final topicService = TopicService(
      topics: widget.topics,
      topicBlocks: widget.topicBlocks,
      cards: widget.cards,
    );

    final featuredTopics = topicService.featuredTopics();

    return featuredTopics
        .map((topic) {
          final topicCards = topicService.cardsForTopic(topic.id);

          if (topicCards.isEmpty) {
            return null;
          }

          final heroCard = topicCards.first;
          final gridCards = topicCards.skip(1).take(4).toList(growable: false);

          return _TopicSection(
            topic: topic,
            topicCards: topicCards,
            heroCard: heroCard,
            gridCards: gridCards,
          );
        })
        .whereType<_TopicSection>()
        .toList(growable: false);
  }

  // ------------------------------------------------------------
  // SEARCH
  // ------------------------------------------------------------
  void _openNavigatorMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(
          cards: widget.cards,
          audio: widget.audio,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // OPEN CARD
  // ------------------------------------------------------------
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
          allCards: widget.cards,
          audio: widget.audio,
          languageCode: widget.languageCode,
          autoAudio: widget.autoAudio,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionList = _buildFeaturedTopicSections();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 84,
        automaticallyImplyLeading: false,
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
      ),
      body: ListView(
        children: sectionList.map((section) {
          final topic = section.topic;
          final topicCards = section.topicCards;
          final heroCard = section.heroCard;
          final gridCards = section.gridCards;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
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

              // HERO
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

              // GRID
              if (gridCards.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gridCards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
          );
        }).toList(),
      ),
    );
  }
}

class _TopicSection {
  final Topic topic;
  final List<Flashcard> topicCards;
  final Flashcard heroCard;
  final List<Flashcard> gridCards;

  const _TopicSection({
    required this.topic,
    required this.topicCards,
    required this.heroCard,
    required this.gridCards,
  });
}