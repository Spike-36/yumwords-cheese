class TopicBlock {
  final String topicID;
  final String blockID;
  final int sortOrder;

  const TopicBlock({
    required this.topicID,
    required this.blockID,
    required this.sortOrder,
  });

  factory TopicBlock.fromJson(Map<String, dynamic> json) => TopicBlock(
        topicID: json['topicID'],
        blockID: json['blockID'],
        sortOrder: json['sortOrder'],
      );
}