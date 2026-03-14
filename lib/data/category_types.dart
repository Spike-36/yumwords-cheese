/// Defines which category types appear for different food regions.
/// This keeps editorial structure out of the UI layer.

/// Regions used by the app
enum FoodRegion {
  asia,
  europe,
  mediterranean,
}

/// Map flavour → region
const Map<String, FoodRegion> flavourRegion = {
  "thailand": FoodRegion.asia,
  "vietnam": FoodRegion.asia,
  "japan": FoodRegion.asia,
  "korea": FoodRegion.asia,
  "malaysia": FoodRegion.asia,

  "france": FoodRegion.europe,

  "turkey": FoodRegion.mediterranean,
};

/// Category sets by region

const List<String> categoriesAsia = [
  "Phrases",
  "Descriptions",
  "Items",
  "Numbers",
  "Mains",
  "Street Food",
  "Breakfasts",
  "Desserts",
  "Drinks",
  "Snacks",
  "Pantry Basics",
  "Vegetables",
  "Fruit",
  "Proteins",
  "Nuts & Seeds",
  "Rice, Noodles & Grains",
  "Herbs & Spices",
  "Aromatics & Pastes",
  "Condiments",
];

const List<String> categoriesEurope = [
  "Phrases",
  "Descriptions",
  "Items",
  "Numbers",
  "Mains",
  "Breakfasts",
  "Cheese",
  "Desserts",
  "Drinks",
  "Snacks",
  "Pantry Basics",
  "Vegetables",
  "Fruit",
  "Proteins",
  "Nuts & Seeds",
  "Rice, Noodles & Grains",
  "Herbs & Spices",
  "Aromatics & Pastes",
  "Condiments",
];

const List<String> categoriesMediterranean = [
  "Phrases",
  "Descriptions",
  "Items",
  "Numbers",
  "Mains",
  "Street Food",
  "Breakfasts",
  "Cheese",
  "Desserts",
  "Drinks",
  "Snacks",
  "Pantry Basics",
  "Vegetables",
  "Fruit",
  "Proteins",
  "Nuts & Seeds",
  "Rice, Noodles & Grains",
  "Herbs & Spices",
  "Aromatics & Pastes",
  "Condiments",
];

/// Returns the correct category list for a flavour
List<String> getCategoriesForFlavour(String flavour) {
  final region = flavourRegion[flavour];

  switch (region) {
    case FoodRegion.asia:
      return categoriesAsia;
    case FoodRegion.europe:
      return categoriesEurope;
    case FoodRegion.mediterranean:
      return categoriesMediterranean;
    default:
      return categoriesAsia;
  }
}