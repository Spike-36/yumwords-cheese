// lib/config/flavour.dart
//
// Cheese-only asset resolver
// ------------------------------------------------------------
//
// This build is permanently locked to the Cheese flavour.
// No dart-define COUNTRY parameter is required.
//
const String country = 'cheese';
// ------------------------------------------------------------
// APP TITLE
// ------------------------------------------------------------
String appTitle() {
  return 'YumWords – Fromage';
}

// ------------------------------------------------------------
// JSON FILE
// ------------------------------------------------------------
String jsonPath(String fileName) {
  return 'assets/cheese/$fileName';
}

// ------------------------------------------------------------
// WORD IMAGES
// ------------------------------------------------------------
String imageCountryPath(String fileName) {
  final clean = fileName.trim();
  if (clean.isEmpty) return '';
  return 'assets/cheese/images/words/$clean';
}

// ------------------------------------------------------------
// AUDIO FILES
// ------------------------------------------------------------
String audioCountryPath(String? fileName) {
  final clean = (fileName ?? '').trim();
  if (clean.isEmpty) return '';
  return 'assets/cheese/audio/$clean';
}

// ------------------------------------------------------------
// UI IMAGES
// ------------------------------------------------------------
String sharedUi(String fileName) {
  return 'assets/shared/images/ui/$fileName';
}

String countryUi(String fileName) {
  return 'assets/cheese/images/ui/$fileName';
}