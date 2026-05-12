import 'package:flutter/material.dart';

class CheeseInfoSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final double topSpacing;

  const CheeseInfoSection({
    super.key,
    required this.title,
    required this.items,
    this.topSpacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: topSpacing,
            bottom: 4,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'SourceSans3',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: items.map((item) {
            return Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 6,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text('•  '),

                  Expanded(
                    child: Text(
                      item,
                      style:
                          const TextStyle(
                        fontFamily:
                            'SourceSans3',
                        fontSize: 15,
                        height: 1.45,
                        color: Colors
                            .black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}