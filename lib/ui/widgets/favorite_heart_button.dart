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
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.redAccent : Colors.white,
                size: size,
                shadows: const [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black54,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}