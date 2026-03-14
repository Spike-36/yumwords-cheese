import 'package:flutter/material.dart';
import '../data/category_types.dart';

/// Category overview screen with editorial grouping metadata.
/// NOTE:
/// This screen is no longer responsible for navigation or Search.
/// It exists primarily to define category structure and labels
/// consumed by NavigatorMenuScreen.

class CategoryOverviewScreen extends StatelessWidget {
  final void Function(String category) onCategorySelected;
  final String flavour;

  const CategoryOverviewScreen({
    super.key,
    required this.onCategorySelected,
    required this.flavour,
  });

  @override
  Widget build(BuildContext context) {

    // 🔎 DEBUG — verify flavour and categories
    final wordCategories = getCategoriesForFlavour(flavour);
    print("FLAVOUR RECEIVED: $flavour");
    print("WORD CATEGORIES: $wordCategories");

    final groups = {
      "Essentials": const _CategoryGroup(
        subtitle: "Some useful words, dishes, and drinks to start with.",
        categories: [
          "Essential Words",
          "Essential Dishes",
          "Essential Drinks",
        ],
      ),

      "Thai Food & Drink": const _CategoryGroup(
        subtitle: "Information about Thai dishes, drinks, and ingredients.",
        categories: [
          "Dishes",
          "Drinks",
          "Snacks",
          "Sweets",
          "Basics",
          "Vegetables",
          "Fruits",
          "Proteins",
          "Nuts & Seeds",
          "Rice, Noodles & Grains",
          "Herbs, Aromatics & Spices",
          "Sauces, Seasonings & Pastes",
        ],
      ),

      "Words": _CategoryGroup(
        subtitle: "Common food and drink related words and phrases.",
        categories: wordCategories,
      ),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          children: [
            const SizedBox(height: 12),

            // --- Back button ---
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 26),
                color: Colors.black87,
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 8),

            // --- All groups + category rows ---
            for (final entry in groups.entries) ...[
              _buildGroupHeader(
                title: entry.key,
                subtitle: entry.value.subtitle,
              ),
              ...entry.value.categories
                  .map((cat) => _buildCategoryRow(context, cat)),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Group header with subtitle ---
  Widget _buildGroupHeader({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E2E2E),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6F6F6F),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),
        ],
      ),
    );
  }

  // --- Tappable category row ---
  Widget _buildCategoryRow(BuildContext context, String category) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => onCategorySelected(category),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Text(
            category,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2E2E2E),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// --- Simple model for group metadata ---
class _CategoryGroup {
  final String subtitle;
  final List<String> categories;

  const _CategoryGroup({
    required this.subtitle,
    required this.categories,
  });
}