import 'package:flutter/material.dart';

import '../../data/card.dart';
import '../../main.dart';

class FavoriteHeartButton extends StatelessWidget {
  final Flashcard card;
  final double size;

  const FavoriteHeartButton({
    super.key,
    required this.card,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: favoritesService,
      builder: (context, _) {
        final isFavorite = favoritesService.isFavorite(card.id);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            favoritesService.toggleFavorite(card.id);
          },
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Container(
                width: size + 10,
                height: size + 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.35),
                ),
                child: Center(
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: size,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}