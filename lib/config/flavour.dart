// lib/config/flavour.dart
//
// Clean + simplified flavour asset resolver
// ------------------------------------------------------------
//
// This file defines the active country flavour and resolves
// all country-specific asset paths.
//
// The active flavour MUST be supplied via:
//   --dart-define=COUNTRY=xxx
//
// Valid values:
//   japan | korea | malaysia | thailand | vietnam | france
//

// ------------------------------------------------------------
// ACTIVE COUNTRY
// ------------------------------------------------------------

// IMPORTANT:
// Do NOT rely on a silent default for release builds.
// If COUNTRY is missing or invalid, the app will still build
// but will clearly indicate a configuration error.

const String country = String.fromEnvironment('COUNTRY');

// ------------------------------------------------------------
// APP TITLE
// ------------------------------------------------------------
String appTitle() {
  switch (country) {
    case 'japan':
      return 'YumWords – Japan';
    case 'korea':
      return 'YumWords – Korea';
    case 'malaysia':
      return 'YumWords – Malaysia';
    case 'thailand':
      return 'YumWords – Thailand';
    case 'vietnam':
      return 'YumWords – Vietnam';
    case 'france':                     // 👉 ADD THIS
      return 'YumWords – France';

    default:
      return 'YumWords';
  }
}

// ------------------------------------------------------------
// JSON FILE
// ------------------------------------------------------------
String jsonPath(String fileName) {
  return 'assets/$country/$fileName';
}

// ------------------------------------------------------------
// WORD IMAGES
// ------------------------------------------------------------
String imageCountryPath(String fileName) {
  final clean = fileName.trim();
  if (clean.isEmpty) return '';
  return 'assets/$country/images/words/$clean';
}

// ------------------------------------------------------------
// AUDIO FILES
// ------------------------------------------------------------
String audioCountryPath(String? fileName) {
  final clean = (fileName ?? '').trim();
  if (clean.isEmpty) return '';
  return 'assets/$country/audio/$clean';
}

// ------------------------------------------------------------
// UI IMAGES
// ------------------------------------------------------------
String sharedUi(String fileName) {
  return 'assets/shared/images/ui/$fileName';
}

String countryUi(String fileName) {
  return 'assets/$country/images/ui/$fileName';
}