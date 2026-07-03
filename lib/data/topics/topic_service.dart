import '../card.dart';
import 'topic.dart';
import 'topic_block.dart';

class TopicService {
  final List<Topic> topics;
  final List<TopicBlock> topicBlocks;
  final List<Flashcard> cards;

  const TopicService({
    required this.topics,
    required this.topicBlocks,
    required this.cards,
  });

  List<Topic> featuredTopics() {
    final result = topics.where((t) => t.active && t.featured).toList();

    result.sort((a, b) {
      final weight = b.weight.compareTo(a.weight);
      if (weight != 0) return weight;
      return a.sortOrder.compareTo(b.sortOrder);
    });

    return result;
  }

  List<TopicBlock> blocksForTopic(String topicID) {
    final result =
        topicBlocks.where((tb) => tb.topicID == topicID).toList();

    result.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return result;
  }

  List<Flashcard> cardsForTopic(String topicID) {
    final blocks = blocksForTopic(topicID);

    final result = <Flashcard>[];

    for (final block in blocks) {
      final matches = cards.where((c) => c.id == block.blockID);

      if (matches.isEmpty) {
        print(
          '*** MISSING FLASHCARD *** '
          'topic=$topicID  blockID=${block.blockID}',
        );
        continue;
      }

      result.add(matches.first);
    }

    return result;
  }

  Flashcard heroCardForTopic(String topicID) {
    final topicCards = cardsForTopic(topicID);

    if (topicCards.isEmpty) {
      throw Exception('Topic $topicID contains no valid cards.');
    }

    return topicCards.first;
  }
}