import 'package:flutter/material.dart';

void showStrengthGuideSheet(
  BuildContext context,
  String selectedStrength,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          28,
          24,
          36,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Strength Guide',
              style: TextStyle(
                fontFamily: 'SourceSans3',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            _StrengthRow(
              number: '1',
              label: 'very mild',
              isActive: selectedStrength == '1',
            ),

            _StrengthRow(
              number: '2',
              label: 'mild',
              isActive: selectedStrength == '2',
            ),

            _StrengthRow(
              number: '3',
              label: 'medium',
              isActive: selectedStrength == '3',
            ),

            _StrengthRow(
              number: '4',
              label: 'strong',
              isActive: selectedStrength == '4',
            ),

            _StrengthRow(
              number: '5',
              label: 'very strong',
              isActive: selectedStrength == '5',
            ),
          ],
        ),
      );
    },
  );
}

class _StrengthRow extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;

  const _StrengthRow({
    required this.number,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? Colors.black87 : Colors.black26;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: color,
              ),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                fontFamily: 'SourceSans3',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Text(
            label,
            style: TextStyle(
              fontFamily: 'SourceSans3',
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}