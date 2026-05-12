import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheeseMetaRow extends StatelessWidget {
  final String milkType;
  final String strength;
  final VoidCallback onMapTap;
  final VoidCallback onStrengthTap;

  const CheeseMetaRow({
    super.key,
    required this.milkType,
    required this.strength,
    required this.onMapTap,
    required this.onStrengthTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 0,
          ),
          child: IconButton(
            onPressed: onMapTap,
            icon: const FaIcon(
              FontAwesomeIcons.locationDot,
              size: 28,
              color: Colors.black26,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 9,
          ),
          child: Text(
            milkType,
            style: const TextStyle(
              fontFamily: 'SourceSans3',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black26,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 9,
          ),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(40),
            onTap: onStrengthTap,
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black26,
                  width: 1.4,
                ),
                shape: BoxShape.circle,
              ),
              child: Text(
                strength,
                style: const TextStyle(
                  fontFamily: 'SourceSans3',
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                  color: Colors.black26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}