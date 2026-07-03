// lib/data/topics/topic_repository.dart

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../config/flavour.dart';
import 'topic.dart';
import 'topic_block.dart';

class TopicRepository {
  Future<List<Topic>> loadTopics() async {
    final raw = await rootBundle.loadString(jsonPath('topics.json'));

    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();

    final topics = list
        .map((j) => Topic.fromJson(j))
        .toList(growable: false);

    topics.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return topics;
  }

  Future<List<TopicBlock>> loadTopicBlocks() async {
    final raw = await rootBundle.loadString(jsonPath('topicBlocks.json'));

    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();

    final topicBlocks = list
        .map((j) => TopicBlock.fromJson(j))
        .toList(growable: false);

    topicBlocks.sort((a, b) {
      final topicCompare = a.topicID.compareTo(b.topicID);
      if (topicCompare != 0) return topicCompare;
      return a.sortOrder.compareTo(b.sortOrder);
    });

    return topicBlocks;
  }
}