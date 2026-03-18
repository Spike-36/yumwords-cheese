import 'featured_thailand.dart';
import 'featured_malaysia.dart';
import 'featured_korea.dart';
import 'featured_japan.dart';
import 'featured_vietnam.dart';
import 'featured_france.dart';
import 'featured_cheese.dart';

const Map<String, Map<String, List<String>>> featuredByFlavour = {
  'thailand': featuredSectionsThailand,
  'malaysia': featuredSectionsMalaysia,
  'korea': featuredSectionsKorea,
  'japan': featuredSectionsJapan,
  'vietnam': featuredSectionsVietnam,
  'france': featuredSectionsFrance,
  'cheese': featuredSectionsCheese,
};

Map<String, List<String>> getFeaturedSections(String flavour) {
  final sections = featuredByFlavour[flavour];
  assert(
    sections != null,
    'No featured sections registered for flavour: $flavour',
  );
  return sections ?? const {};
}