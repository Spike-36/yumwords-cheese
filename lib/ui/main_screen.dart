import 'package:flutter/material.dart';

import '../data/card.dart';
import '../data/repository.dart';
import '../data/topics/topic.dart';
import '../data/topics/topic_block.dart';
import '../data/topics/topic_repository.dart';
import '../services/audio_service.dart';

import 'featured_food_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final AudioService audio = AudioService();
  late final Future<_StartupData> startupFuture = _loadData();

  bool autoAudio = false;

  Future<_StartupData> _loadData() async {
    final cards = await Repository().load();

    final topicRepository = TopicRepository();
    final topics = await topicRepository.loadTopics();
    final topicBlocks = await topicRepository.loadTopicBlocks();

    return _StartupData(
      cards: cards,
      topics: topics,
      topicBlocks: topicBlocks,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YumWords',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<_StartupData>(
        future: startupFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Startup error:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final data = snapshot.data!;

          return FeaturedFoodScreen(
            cards: data.cards,
            topics: data.topics,
            topicBlocks: data.topicBlocks,
            audio: audio,
            languageCode: 'en',
            autoAudio: autoAudio,
          );
        },
      ),
    );
  }
}

class _StartupData {
  final List<Flashcard> cards;
  final List<Topic> topics;
  final List<TopicBlock> topicBlocks;

  const _StartupData({
    required this.cards,
    required this.topics,
    required this.topicBlocks,
  });
}