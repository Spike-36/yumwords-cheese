import 'package:flutter/material.dart';

void showRegionMapSheet(
  BuildContext context, {
  required String mapAsset,
  required String regionName,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (_) {
      return SizedBox(
        height:
            MediaQuery.of(context)
                    .size
                    .height *
                0.50,
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            36,
          ),
          child: Column(
            children: [
              Transform.translate(
                offset: const Offset(
                  0,
                  -10,
                ),
                child: SizedBox(
                  height:
                      MediaQuery.of(context)
                              .size
                              .height *
                          0.36,
                  child: Center(
                    child: Image.asset(
                      mapAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Transform.translate(
                offset: const Offset(
                  0,
                  -40,
                ),
                child: Text(
                  regionName,
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    fontFamily:
                        'SourceSans3',
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}