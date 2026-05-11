import 'package:flutter/material.dart';

void showRegionMapSheet(
  BuildContext context, {
  required String mapAsset,
}) {
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
          24,
          24,
          36,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              mapAsset,
              fit: BoxFit.contain,
            ),
          ],
        ),
      );
    },
  );
}