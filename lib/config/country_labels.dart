// lib/config/country_labels.dart
//
// Provides the countryScript + countryEnglish labels
// for each flavour, without touching data.json.
//

import 'flavour.dart';

class CountryLabels {
  final String script;
  final String english;

  const CountryLabels({
    required this.script,
    required this.english,
  });
}

CountryLabels get countryLabels {
  switch (country) {
    case 'japan':
      return const CountryLabels(
        script: '日本', // Japan
        english: 'Japan',
      );

    case 'korea':
      return const CountryLabels(
        script: '대한민국', // South Korea
        english: 'Korea',
      );

    case 'malaysia':
      return const CountryLabels(
        script: 'Malaysia', // Malay / Latin script
        english: 'Malaysia',
      );

    case 'thailand':
      return const CountryLabels(
        script: 'ประเทศไทย', // Thailand
        english: 'Thailand',
      );

    case 'vietnam':
      return const CountryLabels(
        script: 'Việt Nam', // Vietnamese native form
        english: 'Vietnam',
      );

    default:
      return const CountryLabels(
        script: '',
        english: '',
      );
  }
}