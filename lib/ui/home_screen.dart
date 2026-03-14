import 'package:flutter/material.dart';
import '../config/flavour.dart';
import '../config/country_labels.dart';
import '../data/card.dart';
import '../services/audio_service.dart';
import 'navigator_menu_screen.dart';
import 'featured_food_screen.dart';

class HomeScreen extends StatelessWidget {
  final String languageCode;
  final VoidCallback onLanguageTap;

  final bool autoAudio;
  final ValueChanged<bool> onAutoAudioChanged;

  final List<Flashcard> cards;
  final AudioService audio;

  const HomeScreen({
    super.key,
    required this.languageCode,
    required this.onLanguageTap,
    required this.cards,
    required this.audio,
    required this.autoAudio,
    required this.onAutoAudioChanged,
  });

  static const double topGap = 45;
  static const double headingGap = 20;

  static const TextStyle _labelStyle = TextStyle(
    fontFamily: 'SourceSerif4',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: Color(0xFF555555),
  );

  @override
  Widget build(BuildContext context) {
    final labels = countryLabels;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: topGap),

            Center(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 40,
                    color: Color(0xFF2E2E2E),
                    letterSpacing: 0.9,
                  ),
                  children: [
                    TextSpan(
                      text: 'yum',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'words',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: headingGap),
            const SizedBox(height: 60),

            Center(
              child: Text(
                labels.english,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Color(0xFF555555),
                  letterSpacing: 0.9,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: Image.asset(
                countryUi('flag.png'),
                width: 80,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: Text(
                labels.script,
                style: const TextStyle(
                  fontFamily: 'SourceSerif4',
                  fontWeight: FontWeight.w400,
                  fontSize: 25,
                  color: Color(0xFF2E2E2E),
                  letterSpacing: 0.8,
                ),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          autoAudio ? 'Auto-Audio On' : 'Auto-Audio Off',
                          style: _labelStyle.copyWith(
                            color: autoAudio
                                ? const Color(0xFF2E2E2E)
                                : const Color(0xFF555555),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Switch(
                          value: autoAudio,
                          activeColor: const Color(0xFF444444),
                          onChanged: onAutoAudioChanged,
                        ),
                      ],
                    ),
                  ),

                  // FEATURED FOODS (TEST ENTRY)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: 220,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(
                            color: Color(0xFF999999),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FeaturedFoodScreen(
                                cards: cards,
                                audio: audio,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Featured Foods (Test)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // START (UNCHANGED)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            side: const BorderSide(
                              color: Color(0xFF555555),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NavigatorMenuScreen(
                                  cards: cards,
                                  audio: audio,
                                  languageCode: languageCode,
                                  autoAudio: autoAudio,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Start',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
