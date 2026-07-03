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

    return blocks.map((tb) {
      return cards.firstWhere((c) => c.id == tb.blockID);
    }).toList(growable: false);
  }

  Flashcard heroCardForTopic(String topicID) {
    return cardsForTopic(topicID).first;
  }
}