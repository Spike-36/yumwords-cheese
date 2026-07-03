import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../data/card.dart';
import '../data/topics/topic_repository.dart';
import '../services/audio_service.dart';

import 'featured_food_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final AudioService audio = AudioService();

  late final Future<List<Flashcard>> cardsFuture = _loadCards();

  bool autoAudio = false;

  Future<List<Flashcard>> _loadCards() async {
    final cards = await Repository().load();

    final topicRepository = TopicRepository();

    final topics = await topicRepository.loadTopics();
    final topicBlocks = await topicRepository.loadTopicBlocks();


    return cards;
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
      home: FutureBuilder<List<Flashcard>>(
        future: cardsFuture,
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
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return FeaturedFoodScreen(
            cards: snapshot.data!,
            audio: audio,
            languageCode: 'en',
            autoAudio: autoAudio,
          );
        },
      ),
    );
  }
}