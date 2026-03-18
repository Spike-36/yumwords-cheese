import 'package:flutter/material.dart';
import '../data/category_types.dart';

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

    final groups = {

      // 🔹 FIND (PRIMARY PURPOSE)
      "Find Cheese": const _CategoryGroup(
        subtitle: "Search or filter to find cheeses you enjoy.",
        categories: [
          "Search",
          "Filter by Type",
          "Filter by Milk",
          "Filter by Strength",
        ],
      ),

      // 🔹 BROWSE (STRUCTURED INDEX)
      "Browse Cheeses": const _CategoryGroup(
        subtitle: "Explore cheeses in a structured way.",
        categories: [
          "By Type",
          "By Country",
          "By Strength",
          "A–Z List",
        ],
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

            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 26),
                color: Colors.black87,
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 8),

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

class _CategoryGroup {
  final String subtitle;
  final List<String> categories;

  const _CategoryGroup({
    required this.subtitle,
    required this.categories,
  });
}